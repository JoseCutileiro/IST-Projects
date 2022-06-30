# takuzu.py: Template para implementação do projeto de Inteligência Artificial 2021/2022.
# Devem alterar as classes e funções neste ficheiro de acordo com as instruções do enunciado.
# Além das funções e classes já definidas, podem acrescentar outras que considerem pertinentes.

# Grupo tp016
# 96925 Gonçalo Silva
# 99097 José Cutileiro

import time
import sys
import os
import numpy as np

from search import (
    Problem,
    Node,
    astar_search,
    breadth_first_tree_search,
    depth_first_tree_search,
    greedy_search,
    recursive_best_first_search,
    compare_searchers
)


class TakuzuState:
    state_id = 0

    def __init__(self, board):
        self.board = board



    def __lt__(self, other):
        return self.id < other.id

    # TODO: outros metodos da classe


class Board:
    """Representação interna de um tabuleiro de Takuzu."""
    
    to_fill = 0

    def __init__(self, size) -> None:
        self.content = np.empty([size, size], dtype=int)
        self.size = size

    def __repr__(self):
        return str(self.content)

    def get_number(self, row: int, col: int) -> int:
        return self.content[row][col]

    def adjacent_vertical_numbers(self, row: int, col: int) -> (int, int):
        if row == 0:
            return (self.content[row + 1][col], None)
        elif row == self.size - 1:
            return (None, self.content[row - 1][col])
        return (self.content[row + 1][col], self.content[row - 1][col]) 

    def adjacent_horizontal_numbers(self, row: int, col: int) -> (int, int):
        if col == 0:
            return (None, self.content[row][col + 1])
        elif col == self.size - 1:
            return (self.content[row][col - 1], None)
        return (self.content[row][col - 1], self.content[row][col + 1])    
    
    def duplas_cima(self,row: int, col:int):
        if row < 2:
            return [-1,-2]
        return (self.content[row-1][col], self.content[row-2][col])
    
    def duplas_baixo(self,row: int, col:int):
        if row > self.size-3:
            return [-1,-2]
        return (self.content[row+1][col], self.content[row+2][col])
    
    def duplas_esq(self,row: int, col:int):
        if col < 2:
            return [-1,-2]
        return (self.content[row][col-1], self.content[row][col-2])

    def duplas_dir(self,row: int, col:int):
        if col > self.size-3:
            return [-1,-2]
        return (self.content[row][col+1], self.content[row][col+2])

    def get_columns(self):
        return np.transpose(self.content)
    
    def count(self,row,col):
        val = self.size/2
        if self.size % 2 != 0:
            val = int(val) + 1
        sum_row_0 = 0
        sum_col_0 = 0
        sum_row_1 = 0
        sum_col_1 = 0
        for i in range(self.size):
            if (self.content[row][i] == 0):
                sum_row_0 += 1     
            if (self.content[i][col] == 0):
                sum_col_0 += 1  
            if (self.content[row][i] == 1):
                sum_row_1 += 1     
            if (self.content[i][col] == 1):
                sum_col_1 += 1 
                
        if (sum_row_1 >= val or sum_col_1 >= val):
            return  0;   
        if (sum_row_0 >= val or sum_col_0 >= val):
            return  1;  
        return -1
    #   return [np.count_nonzero(self.content[row], axis=1),
    #          np.count_nonzero(self.content[row], 0),
    #         np.count_nonzero(self.get_columns[col], 1),
    #        np.count_nonzero(self.get_columns[col], 0)]
    

    @staticmethod
    def parse_instance_from_stdin():
        size = int(sys.stdin.readline())
        board = Board(size)
        board.to_fill = 0

        for i in range(board.size):
            line = sys.stdin.readline().split('\t')
            for j in range(board.size):
                a = int(line[j])
                if a == 2:
                    board.to_fill += 1
                board.content[i][j] = a
                 
        return board



class Takuzu(Problem):
    def __init__(self, board: Board):
        self.initial = TakuzuState(board)


    def actions(self, state: TakuzuState):
        #TODO: Alterar isto
        actions = []
        i = 0
        for line in state.board.content:
            j = 0
            for pos in line:
                if pos == 2:
                    
                    # Restricao 0
                    ret = state.board.count(i,j)
                    if (ret != -1):
                        #print("FEITO GARANTIDO SOMA LINHAS/COL: " + str([[i,j,ret]]))
                        return [[i,j,ret]]
                    
                    
                    # Restricao 1 (verticais iguais)
                    v = state.board.adjacent_vertical_numbers(i,j)
                    if (v[0] == v[1] and v[0] != 2):
                        #print("FEITO GARANTIDO ADJACENTES VERTICAIS: " + str([[i,j,(v[0]-1)/-1]]))
                        return [[i,j,(v[0]-1)/(-1)]]
                    
                    # Restricao 2 (horizontais iguais)
                    v = state.board.adjacent_horizontal_numbers(i,j)
                    if (v[0] == v[1] and v[0] != 2):
                        #print("FEITO GARANTIDO ADJACENTES HORIZONTAIS: " + str([[i,j,(v[0]-1)/-1]]))
                        return [[i,j,(v[0]-1)/(-1)]]
                    
                    # Restricao 3 (duplas cima)
                    v = state.board.duplas_cima(i,j)
                    if (v[0] == v[1] and v[0] != 2):
                        #print("FEITO GARANTIDO DUPLAS EM CIMA: " + str([[i,j,(v[0]-1)/-1]]))
                        return [[i,j,(v[0]-1)/(-1)]]
                    
                    # Restricao 4 (duplas baixo)
                    v = state.board.duplas_baixo(i,j)
                    if (v[0] == v[1] and v[0] != 2):
                        #print("FEITO GARANTIDO DUPLAS EM BAIXO: " + str([[i,j,(v[0]-1)/-1]]))
                        return [[i,j,(v[0]-1)/(-1)]]
                    
                    # Restricao 5 (duplas cima)
                    v = state.board.duplas_dir(i,j)
                    if (v[0] == v[1] and v[0] != 2):
                        #print("FEITO GARANTIDO DUPLAS DIREITA: " + str([[i,j,(v[0]-1)/-1]]))
                        return [[i,j,(v[0]-1)/(-1)]]
                    
                    # Restricao 6 (duplas cima)
                    v = state.board.duplas_esq(i,j)
                    if (v[0] == v[1] and v[0] != 2):
                        #print("FEITO GARANTIDO DUPLAS ESQUERDA: " + str([[i,j,(v[0]-1)/-1]]))
                        return [[i,j,(v[0]-1)/(-1)]]
                    
                    
                    if (len(actions) == 0):
                        actions.append( [i, j, 0])
                        actions.append([i, j, 1])
                j += 1
            i += 1
        #HERE
        # print("AVAILABLE ACTIONS: " + str(actions))
        return actions
                    

    def result(self, state: TakuzuState, action):
        updated_board = Board(state.board.size);
        updated_board.content = state.board.content.copy()
        updated_board.to_fill = state.board.to_fill - 1
        #print("PUT: " + str(action))
        updated_board.content[action[0]][action[1]] = action[2]
        new_state = TakuzuState(updated_board)
        return new_state


    def goal_test(self, state: TakuzuState):
        #print("CURRENT FILL: " + str(state.board.to_fill))
        #print("TESTING: Board Full")
        #print("FILL FACTOR: " + str(state.board.to_fill))

        if state.board.to_fill != 0:
            return False

        #os.system('clear')
        #HERE
        #print("TESTING...\n" + str(state.board.content))
        #time.sleep(1)
        #print("TESTING: Unique lines")
        if len(np.unique(state.board.content, axis=0)) != state.board.size:
            return False

        columns = state.board.get_columns()

        if len(np.unique(columns, axis=0)) != state.board.size:
            return False
        
        # A VER 
        #size = state.board.size/2
        #if (size%2):
            #size += 1
        
        #for sum in state.board.content.sum(axis=1):
            #if sum != size or sum != size-1:
                #return False

        #for sum in state.board.content.sum(axis=0):
            #if sum != size or sum != size-1:
                #return False
        size = state.board.size
        for sum in state.board.content.sum(axis=1):
            if size % 2 != 0:
                break
            else:
                if sum * 2 != size:  # or sum != size-1:
                    return False

        for sum in state.board.content.sum(axis=0):
            if size % 2 != 0:
                break
            else:
                if sum * 2 != size:  # or sum != size-1:
                    return False

        for i in range(state.board.size):
            for j in range(state.board.size):
                h = state.board.adjacent_horizontal_numbers(i, j)
                v = state.board.adjacent_vertical_numbers(i, j)
                value = state.board.get_number(i,j)
                if (value == h[0] == h[1] or value == v[0] == v[1]):
                    return False

        #print("TESTS PASSED")




        return True


    def h(self, node: Node):
        """Função heuristica utilizada para a procura A*."""
        # TODO
        pass
        return 0

    # TODO: outros metodos da classe


if __name__ == "__main__":
    start_time = time.time() 
    board = Board.parse_instance_from_stdin()

    #print("Inicial: \n", board)
    # Criar uma instância de Takuzu:
    problem = Takuzu(board)
    # Obter o nó solução usando a procura em profundidade:
    goal_node = depth_first_tree_search(problem)
    # Verificar se foi atingida a solução
    print("Is goal?", problem.goal_test(goal_node.state))
    #print("Solution:")
    
    #for line in goal_node.state.board.content:
    #    print ('\t'.join(map(str, line)))
    
    #print("Solution:\n", goal_node.state.board, sep="")
    
    
    compare_searchers(problems=[problem],header=['Algoritmo','Problema #1'])  
    print("--- %s seconds ---" % (time.time() - start_time))



    
