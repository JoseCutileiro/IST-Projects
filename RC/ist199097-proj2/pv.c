/******************************************************************************\
* Distance vector routing protocol without reverse path poisoning.             *
\******************************************************************************/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "routing-simulator.h"

#define TRUE 1
#define FALSE 0
#define NO_PATH (-1)

// Message format to send between nodes.
typedef struct {
  cost_t D[MAX_NODES];
  node_t path[MAX_NODES][MAX_NODES];
} data_t;

// State format.
typedef struct {
  node_t node;
  cost_t D[MAX_NODES][MAX_NODES];
  node_t path[MAX_NODES][MAX_NODES][MAX_NODES];
} state_t;

// Handler for the node to allocate and initialize its state.
void *init_state() {
  state_t *state = (state_t *)calloc(1, sizeof(state_t));
  state->node = get_current_node();
  for (node_t node_x = get_first_node();
    node_x <= get_last_node();
    node_x = get_next_node(node_x)) {
      for (node_t node_y = get_first_node();
        node_y <= get_last_node();
        node_y = get_next_node(node_y)) {
          if (node_x == node_y) {
            // Same nodes basics
            // 1. No cost on D
            // 2. Best path to self is self
            // 3. Only pass on it self to get to him self
            // example: [SELF][NO_PATH][NOT INICIALIZED]...[NOT INICIALIZED] 
            state->D[node_x][node_y] = 0;
            state->path[node_x][node_y][0] = node_x;
            state->path[node_x][node_y][1] = NO_PATH;
          }
          else {
            state->D[node_x][node_y] = COST_INFINITY;
            state->path[node_x][node_y][0] = NO_PATH;
          }
      }
  }
  return state;
}

int includePath(node_t *path, node_t node_x) {
  size_t i = 0;
  while (path[i] != NO_PATH && i < MAX_NODES) {
    if (path[i] == node_x) {
      return TRUE;
    }
    i++;
  }
  return FALSE;
}

void changePath(node_t node_x,node_t node_y, node_t next_hop) {
  state_t* state = (state_t*) get_state();
  node_t *path = state->path[node_x][node_y];

  // Reset path because it changed drastically
  if (next_hop == NO_PATH) {
    path[0] = NO_PATH;
  }
  else {
    node_t *keep = state->path[next_hop][node_y];
    size_t i = 0;
    path[i] = node_x;
    // Run until we find NO_PATH or until we get to all nodes
    // Nota: Não sei se precisamos da segunda porque o 
    //       path em principio nunca enche
    while (path[i] != NO_PATH && i < MAX_NODES) {
      path[i+1] = keep[i];
      i++;
    }
  }

}

void bellmanFord() {

  state_t* state = (state_t*) get_state();

  // Bellman FORD 
  node_t node_x = state->node;
  int change = FALSE;
  for (node_t node_y = get_first_node();
    node_y <= get_last_node();
    node_y = get_next_node(node_y)) {
    if (node_x != node_y) {
      node_t next_hop = NO_PATH;
      cost_t min = COST_INFINITY;
      for (node_t node_v = get_first_node();
      node_v <= get_last_node();
      node_v = get_next_node(node_v)) {
        if (node_v != node_x) {
          cost_t cost_y = COST_ADD(get_link_cost(node_v),state->D[node_v][node_y]);
          if (min > cost_y && !includePath(state->path[node_v][node_y],node_x)) {
            min = cost_y;
            next_hop = node_v;
          }
        }
      }

      if(min != state->D[node_x][node_y]) {
        change = TRUE;
        state->D[node_x][node_y] = min;
        set_route(node_y,next_hop,min);
        changePath(node_x,node_y,next_hop);
        printf("[%d]SET ROUTE: [%d]->[%d] via %d with %d\n",node_x,node_x,node_y,next_hop,min);
      }
    }
  }

  if (change) {
    node_t node_x = state->node;
    // Prepare message to send to neighbors
    message_t msg;
    msg.data = (data_t*)malloc(sizeof(data_t));
    data_t *data=(data_t*)msg.data;
    memcpy(data->D,state->D[node_x], sizeof(state->D[node_x]));
    memcpy(data->path,state->path[node_x],sizeof(state->path[node_x]));
    msg.size = sizeof(data_t);

    // Send message to ALL neighbors and not to self
    for(node_t node_y = get_first_node(); 
        node_y <= get_last_node(); 
        node_y = get_next_node(node_y)) {
      if(get_link_cost(node_y) < COST_INFINITY && node_y != node_x){
        send_message(node_y,msg);
      }
    }
    // Free malloc resources since we dont need them anymore
    free(msg.data);
  }
}

// Notify a node that a neighboring link has changed cost.
void notify_link_change(node_t neighbor, cost_t new_cost) {
  // Main alg
  // Nota: Enviar mensagem no algoritmo também
  bellmanFord();
}


// Receive a message sent by a neighboring node.
void notify_receive_message(node_t sender, message_t message) {

  // COPY MESSAGE INFO TO STATE 
  // > Update distance vector
  // > Update path vector
  state_t* state = (state_t*) get_state();
  data_t *data = (data_t*)message.data;
  memcpy(state->D[sender],(cost_t*)data->D,sizeof(state->D[sender]));
  memcpy(state->path[sender],(node_t*)data->path,sizeof(state->path[sender]));

  // Main alg
  // Nota: Enviar mensagem no algoritmo também
  bellmanFord();
}
