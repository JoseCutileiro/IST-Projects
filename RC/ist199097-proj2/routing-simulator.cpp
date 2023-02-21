/******************************************************************************\
* Event based routing protocol simulation engine.                              *
*                                                                              *
* Do not implement router modules in this file.                                *
* This file will be overwritten during grading.                                *
\******************************************************************************/

#include "routing-simulator.h"

#include <assert.h>
#include <string.h>

#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <sstream>

// Initial set of node colors. Subsequent colors chosen randomly.
static std::map<node_t, std::string> colors = {
    {0, "/set19/1"}, {1, "/set19/2"}, {2, "/set19/3"},
    {3, "/set19/4"}, {4, "/set19/5"}, {5, "/set19/6"},
    {6, "/set19/7"}, {7, "/set19/8"}, {8, "/set19/9"},
};
#define COLOR_CURRENT_MESSAGE "black"
#define COLOR_FUTURE_MESSAGE "gray"

// Command-line flags.
static bool show_future_messages = true;
static bool show_messages = true;
static node_t show_routes_for = -1;
static long max_events = -1;
// Flag to output each step, or only one per epoch.
static bool epoch_steps = false;

enum event_type_t { LINK_CHANGE, MESSAGE };
typedef struct {
  event_type_t type;

  union {
    struct {
      node_t node;
      node_t neighbor;
      cost_t new_cost;
    } link_change;

    struct {
      node_t source;
      node_t destination;
      void *content;
      int size;
    } message;
  };
} event_t;

// Ordered sequence of events to process.
static std::multimap<event_time_t, event_t> events;
// Unique set of all nodes in network.
static std::set<node_t> nodes;
// Network topology: map[link] -> cost.
// Undirected graph, first node always < second.
static std::map<std::pair<node_t, node_t>, cost_t> topology;
// Router set routes: map[source][destination] -> <neighbor, route cost>
static std::map<node_t, std::map<node_t, std::pair<node_t, cost_t>>> routes;
// Node black box state.
static std::map<node_t, void *> node_states;

static std::ifstream topology_file;
static std::ofstream steps_dot_file;
static std::ofstream final_dot_file;

// Current event context.
static node_t current_node;
static event_time_t current_time = -1;
static bool changed = false;

// Simulation stats
static long num_events = 0;
static long num_link_changes = 0;
static long num_messages = 0;

static cost_t get_topology_cost(node_t first_node, node_t second_node) {
  // Avoid data duplication in undirected network graph.
  if (first_node > second_node) {
    std::swap(first_node, second_node);
  }

  if (first_node == second_node) {
    return 0;
  } else if (topology.count(std::make_pair(first_node, second_node))) {
    return topology[std::make_pair(first_node, second_node)];
  } else {
    return COST_INFINITY;
  }
}

static void set_topology_cost(node_t first_node, node_t second_node,
                              cost_t cost) {
  assert(first_node != second_node && "Setting cost of self-edge.");
  // Avoid data duplication in undirected network graph.
  if (first_node > second_node) {
    std::swap(first_node, second_node);
  }

  topology[std::make_pair(first_node, second_node)] = cost;
}

static void make_color(node_t node) {
  if (!colors.count(node)) {  // Generate new color if not already defined.
    // Random hue, full saturation and value.
    colors[node] = std::to_string((float)rand() / RAND_MAX) + " 1.0 1.0";
  }
}

static void load_topology_events() {
  std::string line;
  // Iterate file lines.
  while (std::getline(topology_file, line)) {
    std::istringstream iss(line);
    event_time_t time;
    node_t first_node, second_node;
    unsigned cost_int;  // Used to read cost as a number and not a char.
    // Parse line.
    if (!(iss >> time >> first_node >> second_node >> cost_int)) {
      std::cerr << "Syntax error in topology file." << std::endl;
      exit(EXIT_FAILURE);
    }
    cost_t cost = cost_int > COST_INFINITY ? COST_INFINITY : cost_int;

    // Insert two link change events, one for each side of the link.
    event_t event;
    event.type = LINK_CHANGE;
    event.link_change.node = first_node;
    event.link_change.neighbor = second_node;
    event.link_change.new_cost = cost;
    events.insert(std::make_pair(time, event));
    event.link_change.node = second_node;
    event.link_change.neighbor = first_node;
    events.insert(std::make_pair(time, event));

    // Keep track of known nodes.
    nodes.insert(first_node);
    nodes.insert(second_node);

    // Generate colors for the nodes, as needed.
    make_color(first_node);
    make_color(second_node);
  }

  // Initialize network costs.
  for (auto first_node : nodes) {
    for (auto second_node : nodes) {
      if (first_node < second_node) {
        set_topology_cost(first_node, second_node, COST_INFINITY);
      }
    }
  }
}

static void init_node_states() {
  for (auto node : nodes) {
    current_node = node;
    node_states[current_node] = init_state();
  }
}

static void dump_network_snapshot(std::ostream &dot_file) {
  // Graphviz header and timestamp.
  dot_file << "digraph N {" << std::endl                              //
           << "  label = \"t=" << current_time << "\";" << std::endl  //
           << "  labelloc = \"top\";" << std::endl                    //
           << "  labeljust = \"left\";" << std::endl;

  // Dump colored nodes. Highlight recipient of next event in bold.
  for (auto node : nodes) {
    dot_file << "  node" << node                  //
             << " [ label = \"" << node << "\" "  //
             << "style = \"filled"                //
             << (((!epoch_steps) && (!events.empty()) &&
                  ((events.begin()->second.type == LINK_CHANGE &&
                    events.begin()->second.link_change.node == node) ||
                   (events.begin()->second.type == MESSAGE &&
                    events.begin()->second.message.destination == node)))
                     ? ",bold"
                     : "")
             << "\" "  //
             << "fillcolor = \"" << colors[node] << "\" ];" << std::endl;
  }

  // Bold black lines for undirected topology.
  // Add dot for interface that is being notified of change.
  for (auto edge : topology) {
    if (edge.second < COST_INFINITY ||
        ((!events.empty()) && events.begin()->second.type == LINK_CHANGE &&
         ((events.begin()->second.link_change.node == edge.first.first &&
           events.begin()->second.link_change.neighbor == edge.first.second) ||
          (events.begin()->second.link_change.node == edge.first.second &&
           events.begin()->second.link_change.neighbor == edge.first.first)))) {
      dot_file << "  node" << edge.first.first     //
               << " -> node" << edge.first.second  //
               << " [ dir = \"both\" "             //
               << "label = \""
               << (edge.second < COST_INFINITY
                       ? std::to_string((int)edge.second)
                       : "∞")
               << "\" "                //
               << "style = \"bold\" "  //
               << "arrowtail = \""
               << ((!epoch_steps) && (!events.empty()) &&
                           events.begin()->second.type == LINK_CHANGE &&
                           events.begin()->second.link_change.node ==
                               edge.first.first &&
                           events.begin()->second.link_change.neighbor ==
                               edge.first.second
                       ? "dot"
                       : "none")
               << "\" "  //
               << "arrowhead = \""
               << ((!epoch_steps) && (!events.empty()) &&
                           events.begin()->second.type == LINK_CHANGE &&
                           events.begin()->second.link_change.node ==
                               edge.first.second &&
                           events.begin()->second.link_change.neighbor ==
                               edge.first.first
                       ? "dot"
                       : "none")
               << "\"];" << std::endl;
    }
  }

  // Colored arrows for directed routes.
  for (auto node : routes) {
    for (auto destination : node.second) {
      if ((show_routes_for < 0 || show_routes_for == destination.first)) {
        dot_file << "  node" << node.first                               //
                 << " -> node" << destination.second.first               //
                 << " [ color = \"" << colors[destination.first]         //
                 << "\" fontcolor = \"" << colors[destination.first]     //
                 << "\" label = \"" << ((int)destination.second.second)  //
                 << "\" ];" << std::endl;
      }
    }
  }

  // Dashed arrow for messages. Black if being delivered, gray for future
  // delivery.
  if (show_messages) {
    for (auto event = events.begin(); event != events.end(); event++) {
      if (event->second.type == MESSAGE) {
        if (show_future_messages || event == events.begin()) {
          dot_file << "  node" << event->second.message.source         //
                   << " -> node" << event->second.message.destination  //
                   << " [ color = \""
                   << ((!epoch_steps) && event == events.begin()
                           ? COLOR_CURRENT_MESSAGE
                           : COLOR_FUTURE_MESSAGE)  //
                   << "\" style = \"dashed\" ];" << std::endl;
        }
      }
    }
  }

  // Footer.
  dot_file << "}" << std::endl << std::endl;
}

static void process_event(event_t event) {
  switch (event.type) {
    case LINK_CHANGE: {  // Update topology and notify node.
      set_topology_cost(event.link_change.node, event.link_change.neighbor,
                        event.link_change.new_cost);
      changed = true;

      current_node = event.link_change.node;
      notify_link_change(event.link_change.neighbor,
                         event.link_change.new_cost);
      ++num_link_changes;
    } break;

    case MESSAGE: {  // Deliver message to node and free the message buffer.
      current_node = event.message.destination;
      message_t message;
      message.data = event.message.content;
      message.size = event.message.size;
      notify_receive_message(event.message.source, message);
      free(event.message.content);
      ++num_messages;
    } break;

    default: {
      assert(false && "Unknown event type.");
    }
  }
}

static void process_events() {
  // Continue until no more events.
  while (!events.empty() && (max_events < 0 || num_events < max_events)) {
    current_time = events.begin()->first;

    static event_time_t last_snapshot_epoch = -1;
    if (!epoch_steps || current_time > last_snapshot_epoch) {
      last_snapshot_epoch = current_time;

      if (!epoch_steps || changed) {
        dump_network_snapshot(steps_dot_file);
        changed = false;
      }
    }

    // Remove event from queue and process it.
    event_t event = events.begin()->second;
    events.erase(events.begin());

    process_event(event);
    ++num_events;
  }
  if (!epoch_steps || changed) {
    dump_network_snapshot(steps_dot_file);
  }
  dump_network_snapshot(final_dot_file);
}

static void show_usage(std::string command) {
  std::cerr                                                              //
      << "Usage: " << command                                            //
      << " [--epoch-steps]"                                              //
      << " [--final-dot <dot-file>]"                                     //
      << " [--help]"                                                     //
      << " [--hide-future-messages]"                                     //
      << " [--hide-messages]"                                            //
      << " [--max-events <limit>]"                                       //
      << " [--show-routes-for <node>]"                                   //
      << " [--steps-dot <dot-file>]"                                     //
      << " [--] <topology-file>" << std::endl                            //
      << std::endl                                                       //
      << " --epoch-steps             "                                   //
      << "- Only show one step per epoch in the steps dot file."         //
      << std::endl                                                       //
      << " --final-dot <dot-file>    "                                   //
      << "- Generate a dot file showing the final result."               //
      << std::endl                                                       //
      << " --help                    "                                   //
      << "- Show this help screen."                                      //
      << std::endl                                                       //
      << " --hide-future-messages    "                                   //
      << "- Declutter dot files by only showing the current message "    //
      << "(default: show)."                                              //
      << std::endl                                                       //
      << " --hide-messages    "                                          //
      << "- Declutter dot files by hiding all messages "                 //
      << "(default: show)."                                              //
      << std::endl                                                       //
      << " --max-events <limit>      "                                   //
      << "- Put a limit on the number of simulation events to process "  //
      << "(default: no limit)."                                          //
      << std::endl                                                       //
      << " --show-routes-for <node>  "                                   //
      << "- Declutter dot files by only showing routes for <node> "      //
      << "(default: show all)."                                          //
      << std::endl                                                       //
      << " --steps-dot <dot-file>    "                                   //
      << "- Generate a dot file showing each simulation step."           //
      << std::endl;
  exit(EXIT_FAILURE);
}

static void report_stats() {
  std::cout << "Simulated network of " << nodes.size() << " nodes with "
            << num_events << " events." << std::endl
            << "Processed " << num_link_changes << " link change events."
            << std::endl
            << "Processed " << num_messages << " messages." << std::endl
            << "Simulation converged after " << current_time << " time epochs."
            << std::endl;
}

int main(int argc, char *argv[]) {
  // Parse command-line arguments.
  std::string topology_file_name;
  std::string steps_dot_file_name = "/dev/null";
  std::string final_dot_file_name = "/dev/null";
  bool positional_mode = false;

  for (int a = 1; a < argc; ++a) {
    std::string arg = argv[a];
    if (arg == "--epoch-steps") {
      epoch_steps = true;
    } else if (arg == "--final-dot") {
      if (argc <= a + 1) {
        show_usage(argv[0]);
      }
      final_dot_file_name = argv[++a];
    } else if (arg == "--help") {
      show_usage(argv[0]);
    } else if (arg == "--hide-future-messages") {
      show_future_messages = false;
    } else if (arg == "--hide-messages") {
      show_messages = false;
    } else if (arg == "--max-events") {
      if (argc <= a + 1) {
        show_usage(argv[0]);
      }
      try {
        max_events = std::stoi(argv[++a]);
      } catch (...) {
        show_usage(argv[0]);
      }
    } else if (arg == "--show-routes-for") {
      if (argc <= a + 1) {
        show_usage(argv[0]);
      }
      try {
        show_routes_for = std::stoi(argv[++a]);
      } catch (...) {
        show_usage(argv[0]);
      }
    } else if (arg == "--steps-dot") {
      if (argc <= a + 1) {
        show_usage(argv[0]);
      }
      steps_dot_file_name = argv[++a];
    } else if (arg == "--") {
      positional_mode = true;
    } else {
      if ((arg.rfind("-", 0) == 0 && !positional_mode) ||
          !topology_file_name.empty()) {
        std::cerr << "Unknown option: " << arg << std::endl;
        show_usage(argv[0]);
      }
      topology_file_name = arg;
    }
  }

  if (topology_file_name.empty()) {
    show_usage(argv[0]);
  }
  topology_file.open(topology_file_name);
  if (!topology_file.is_open()) {
    std::cerr << "Error opening topology file: " << topology_file_name
              << std::endl;
    exit(EXIT_FAILURE);
  }

  steps_dot_file.open(steps_dot_file_name);
  if (!steps_dot_file.is_open()) {
    std::cerr << "Error opening output file: " << steps_dot_file_name
              << std::endl;
    exit(EXIT_FAILURE);
  }

  final_dot_file.open(final_dot_file_name);
  if (!final_dot_file.is_open()) {
    std::cerr << "Error opening output file: " << final_dot_file_name
              << std::endl;
    exit(EXIT_FAILURE);
  }

  // Load network topology and create the initial set of link change events.
  load_topology_events();
  // Initialize each node's state.
  init_node_states();
  // Process events until none are left.
  process_events();
  // Show final report.
  report_stats();
  return 0;
}

/******************************************************************************\
* Router API: Functions called by the router module.                           *
\******************************************************************************/

node_t get_current_node() { return current_node; }

event_time_t get_current_time() { return current_time; }

void *get_state() { return node_states[current_node]; }

node_t get_first_node() { return *nodes.begin(); }

node_t get_next_node(node_t node) { return node + 1; }

node_t get_last_node() { return *nodes.rbegin(); }

cost_t get_link_cost(node_t neighbor) {
  return get_topology_cost(current_node, neighbor);
}

void set_route(node_t destination, node_t next_hop, cost_t cost) {
  assert(nodes.count(current_node) && "Current node unknown.");
  assert((nodes.count(destination) || cost == COST_INFINITY) &&
         "Route destination unknown.");
  assert((nodes.count(next_hop) || cost == COST_INFINITY) &&
         "Route next hop unknown.");
  assert((get_link_cost(next_hop) < COST_INFINITY || cost == COST_INFINITY) &&
         "Route next hop not a neighbor.");

  if (cost < COST_INFINITY) {
    if ((!routes[current_node].count(destination)) ||
        routes[current_node][destination] != std::make_pair(next_hop, cost)) {
      changed = true;
    }

    routes[current_node][destination] = std::make_pair(next_hop, cost);
  } else {
    if (routes[current_node].count(destination)) {
      changed = true;
    }

    routes[current_node].erase(destination);
  }
}

void send_message(node_t neighbor, message_t message) {
  assert(neighbor != current_node && "Sending message to self.");
  assert(get_link_cost(neighbor) < COST_INFINITY &&
         "Message destination not a neighbor.");

  // Send message during the next epoch.
  event_t event;
  event.type = MESSAGE;
  event.message.source = current_node;
  event.message.destination = neighbor;
  event.message.content = malloc(message.size);
  memcpy(event.message.content, message.data, message.size);
  event.message.size = message.size;
  events.insert(std::make_pair(current_time + 1, event));
}
