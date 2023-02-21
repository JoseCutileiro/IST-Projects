/******************************************************************************\
* Distance vector routing protocol without reverse path poisoning.            *
\******************************************************************************/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "routing-simulator.h"

#define TRUE 1;
#define FALSE 0;

// Message format to send between nodes.
typedef struct {
} data_t;

// State format.
typedef struct {
  node_t node;
  cost_t D[MAX_NODES][MAX_NODES];
  node_t hops[MAX_NODES];
} state_t;

void bellmanford() {
  state_t* state = (state_t*)get_state();
  node_t node_x = state->node;
  //state->D[node_x][neighbor] = new_cost;
  //state->D[neighbor][node_x] = new_cost;
  int change = FALSE;
  for (node_t node_y = get_first_node();
    node_y <= get_last_node();
    node_y = get_next_node(node_y)) {
    if (node_x != node_y) {
      node_t next_hop = -1;
      cost_t min = COST_INFINITY;
      for (node_t node_v = get_first_node();
      node_v <= get_last_node();
      node_v = get_next_node(node_v)) {
        if (node_v != node_x) {
          cost_t cost_y = COST_ADD(get_link_cost(node_v),state->D[node_v][node_y]);
          if (min > cost_y) {
            min = cost_y;
            next_hop = node_v;
          }
        }
      }
      if (min != state->D[node_x][node_y]) {
        change = TRUE;
        state->D[node_x][node_y] = min;
        state->hops[node_y] = next_hop;
        set_route(node_y,next_hop,min);
      }
    }
  }

  if (change) {
    // TO DO: MSG
    node_t node_x = state->node;
    message_t msg;
    cost_t tmp[MAX_NODES];
    void* data = (void*) state->D[node_x];
    msg.size = sizeof(data);
    msg.data = data;

    for (node_t node_y = get_first_node();
    node_y <= get_last_node();
    node_y = get_next_node(node_y)) {

      // SEND MSG TO NEIGHBORS
      // (message is now specific for each neighbor)
      if (get_link_cost(node_y) < COST_INFINITY && node_x != node_y) {
        memcpy(tmp,state->D[node_x],sizeof(state->D[node_x]));
        for (node_t node_v = get_first_node();
              node_v <= get_last_node();
              node_v = get_next_node(node_v)) {
          if (state->hops[node_v] == node_y) {
            printf("ANTES: TMP: %d || OG: %d\n",tmp[node_v],state->D[node_x][node_v]);
            tmp[node_v] = COST_INFINITY;
            printf("DEPOIS: TMP: %d || OG: %d\n",tmp[node_v],state->D[node_x][node_v]);
          }
        }
        msg.data = (void*) tmp;
        msg.size = sizeof(msg.data);
        send_message(node_y,msg);
      }
      
    }
  }
}

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
            state->D[node_x][node_y] = 0;
          }
          else {
            state->D[node_x][node_y] = COST_INFINITY;
          }
      }
      state->hops[node_x] = -1;
  }

  return state;
}

// Notify a node that a neighboring link has changed cost.
void notify_link_change(node_t neighbor, cost_t new_cost) {
  bellmanford();
}


// Receive a message sent by a neighboring node.
void notify_receive_message(node_t sender, message_t message) {

  // COPY VECTOR
  state_t* state = (state_t*) get_state();
  //cost_t* list = (cost_t*) message.data;
  memcpy(state->D[sender],(cost_t*)message.data,message.size);
  bellmanford();
}

