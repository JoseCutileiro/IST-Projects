/******************************************************************************\
* Distance vector routing protocol without reverse path poisoning.             *
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
} state_t;

void bellmanFord() {  
  state_t* state = (state_t*) get_state();
  node_t node_x = state->node;
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

      if(min != state->D[node_x][node_y]) {
        change = TRUE;
        state->D[node_x][node_y] = min;
        set_route(node_y,next_hop,min);
        printf("[%d]SET ROUTE: dest:%d hop:%d cost: %d\n",node_x,node_y,next_hop,min);
      }
    }
  }

  if (change) {
    // TO DO: MSG
    node_t node_x = state->node;
    message_t msg;
    void* data = (void*) state->D[node_x];
    msg.size = sizeof(data);
    msg.data = data;

    for (node_t node_y = get_first_node();
    node_y <= get_last_node();
    node_y = get_next_node(node_y)) {

      // SEND MSG TO NEIGHBORS
      if (get_link_cost(node_y) < COST_INFINITY && node_x != node_y) {
        send_message(node_y,msg);
      }
    }
  }
}

// Handler for the node to allocate and initialize its state.
void *init_state() {

  state_t *state = (state_t *)calloc(1, sizeof(state_t));

  // This way we can avoid to comput the current node 
  // for the entire code
  state->node = get_current_node();

  for (node_t node_x = get_first_node();
    node_x <= get_last_node();
    node_x = get_next_node(node_x)) {

      for (node_t node_y = get_first_node();
        node_y <= get_last_node();
        node_y = get_next_node(node_y)) {
          
          if (node_x == node_y) {
            // Cost to self is 0 by default
            state->D[node_x][node_y] = 0;
          }
          else {
            // Cost to other is infinity when we dont 
            // have any links yet
            state->D[node_x][node_y] = COST_INFINITY;
          }
      }
  }

  return state;
}

// Notify a node that a neighboring link has changed cost.
void notify_link_change(node_t neighbor, cost_t new_cost) {
  bellmanFord();
}


// Receive a message sent by a neighboring node.
void notify_receive_message(node_t sender, message_t message) {
  // COPY VECTOR
  state_t* state = (state_t*) get_state();
  memcpy(state->D[sender],(cost_t*)message.data,message.size);
  //BF
  bellmanFord();

}
