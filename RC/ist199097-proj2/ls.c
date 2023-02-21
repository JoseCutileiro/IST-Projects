/******************************************************************************\
* Link state routing protocol.                                                 *
\******************************************************************************/

#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "routing-simulator.h"

#define TRUE 1
#define FALSE 0
#define NO_NODE -1

typedef struct {
cost_t link_cost[MAX_NODES];
int version;
} link_state_t;

// Message format to send between nodes.
typedef struct {
  link_state_t ls[MAX_NODES];
} data_t;

// State format.
typedef struct {
  link_state_t ls[MAX_NODES];
  node_t self;
} state_t;

// Handler for the node to allocate and initialize its state.
void *init_state() {
  state_t *state = (state_t *)calloc(1, sizeof(state_t));
  state->self = get_current_node();
  for (node_t node_x = get_first_node();
    node_x <= get_last_node();
    node_x = get_next_node(node_x)) {
      for (node_t node_y = get_first_node();
                  node_y <= get_last_node();
                  node_y = get_next_node(node_y)) {
        state->ls[node_x].link_cost[node_y] = COST_INFINITY;
        if (node_x == node_y) {
          state->ls[node_x].link_cost[node_y] = 0;
        }
      }
      state->ls[node_x].version = 0;
  }
  return state;
}

int notIn(node_t N_linha[MAX_NODES],node_t node_w) {
  if (N_linha[node_w] == node_w) {
    return FALSE;
  }
  return TRUE;
}

void dijkstra() { 

  state_t *state = (state_t*) get_state();

  // INICIALIZE D and N_linha
  cost_t D[MAX_NODES];
  node_t N_linha[MAX_NODES];
  node_t previous[MAX_NODES];
  for (node_t node_x = get_first_node();
    node_x <= get_last_node();
    node_x = get_next_node(node_x)) {
    D[node_x] = get_link_cost(node_x);
    N_linha[node_x] = NO_NODE;
    if (D[node_x] < COST_INFINITY && node_x != state->self) {
      previous[node_x] = state->self;
    }
  }
  N_linha[state->self] = state->self;

  // LOOP (until N_linha = N)
  while(TRUE) {

    // SELECT MINIMUM
    node_t node_min = NO_NODE;
    cost_t cost_min = COST_INFINITY;

    for (node_t node_w = get_first_node();
      node_w <= get_last_node();
      node_w = get_next_node(node_w)) {
        if (cost_min > D[node_w] && notIn(N_linha,node_w)) {
          cost_min = D[node_w];
          node_min = node_w;
        }
    }

    // STOP (node min was selected)
    // If node min == -1 -> Break
    if (node_min == NO_NODE) {
      for(node_t node_v = get_first_node();
                node_v <= get_last_node();
                node_v = get_next_node(node_v)){
        if(N_linha[node_v] != node_v){
          set_route(node_v,NO_NODE,COST_INFINITY);
        }
      }
      return;
    }

    // Percorrer previous para descobrir o next hop
    N_linha[node_min] = node_min;
    node_t next_hop = node_min;

    while(previous[next_hop] != state->self) {
      next_hop = previous[next_hop];
    }

    set_route(node_min,next_hop,cost_min);

    // Atualizar dados
    for (node_t node_v = get_first_node();
                node_v <= get_last_node();
                node_v = get_next_node(node_v)) {
      if (!notIn(N_linha,node_v) || state->ls[node_min].link_cost[node_v] == COST_INFINITY) {
        continue;
      }
      else {
        cost_t nc = COST_ADD(D[node_min],state->ls[node_min].link_cost[node_v]);
        if (D[node_v] > nc) {
          D[node_v] = nc;
          previous[node_v] = node_min;
        }
      }
    }
  }
}

// Notify a node that a neighboring link has changed cost.
void notify_link_change(node_t neighbor, cost_t new_cost) {
  state_t *state = (state_t*) get_state();
  node_t node_x = state->self;
  state->ls[node_x].link_cost[neighbor] = new_cost;
  state->ls[node_x].version++;

  // SEND MSG
  message_t msg;
  msg.data = malloc(sizeof(data_t));
  msg.size = sizeof(data_t);
  data_t *data = (data_t*)msg.data;
  memcpy(data->ls, state->ls, sizeof(state->ls));
  for (node_t node_y = get_first_node();
    node_y <= get_last_node();
    node_y = get_next_node(node_y)) {
      if (get_link_cost(node_y) < COST_INFINITY && node_x != node_y) {
        send_message(node_y,msg);
      }
  }

  // DIJ
  dijkstra();

}

// Receive a message sent by a neighboring node.
void notify_receive_message(node_t sender, message_t message) {
  state_t *state = (state_t*) get_state();
  node_t node_x = state->self;

  // CHECK VERSION (if no new version -> Ignore)
  int any_change = FALSE;
  data_t *data = (data_t*)message.data;
  for (node_t node_y = get_first_node();
    node_y <= get_last_node();
    node_y = get_next_node(node_y)) {
    if (data->ls[node_y].version > state->ls[node_y].version) {
      any_change = TRUE;
      memcpy(&state->ls[node_y], &data->ls[node_y], sizeof(link_state_t));
    }
  }
  if (!any_change) {
    return;
  }


  // SEND MSG
  message_t msg;
  msg.data = malloc(sizeof(data_t));
  msg.size = sizeof(data_t);
  //data_t *data_s = (data_t*)msg.data;
  for (node_t node_y = get_first_node();
    node_y <= get_last_node();
    node_y = get_next_node(node_y)) {
      if (get_link_cost(node_y) < COST_INFINITY && node_x != node_y) {
        send_message(node_y,msg);
      }
  }
  free(msg.data);

  // DIJSKTRA
  dijkstra();
}
