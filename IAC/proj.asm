;;; Grupo 7 - Projeto ;;;

; Inês Garcia - 99083
; José Cutileiro - 99097
; Pedro Lobo - 99115

;-------------------------------------------;
;--------------- Constantes ----------------;
;-------------------------------------------;
; Periféricos
DISPLAYS       EQU 0A000H     ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN        EQU 0C000H     ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL        EQU 0E000H     ; endereço das colunas do teclado (periférico PIN)

; Desenhar objetos
APAGAR_ECRA    EQU 6000H      ; apaga todos os pixeis do ecra
APAGAR_TOTAL   EQU 6002H      ; apaga todos os pixeis de todos os ecras
DEFINE_LINHA   EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA  EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL   EQU 6012H      ; endereço do comando para escrever um pixel
LARGURA_NAVE   EQU 5   		  ; largura da nave
LARGURA_MISSIL EQU 3          ; largura do missil
LARGURA_MEGA   EQU 3          ; largura do objeto mega
LARGURA_VING   EQU 5          ; largura do objeto vingança
LARGURA_EXPLOSAO EQU 5        ; largura da explosão
LARGURA_PEQUENO EQU 3
TAMANHO_GRANDE EQU 2          ; tamanho dos objetos: pequeno - 0 // médio - 1 // grande - 2
TAMANHO_MEDIO  EQU 1
MEGA_MEDIO     EQU 4          ; coordenada de transformação de médio para grande do mega
RESET_Y_VING   EQU 4          ; reiniciar coordenada y da vingança
RESET_X_VING   EQU 30         ; reiniciar coordenada x da vingança
RESET_OBJ_Y    EQU 3
RESET_OBJ_1_X  EQU 27
RESET_OBJ_2_X  EQU 30
RESET_OBJ_3_X  EQU 33
VOID           EQU 35         ; encontra-se fora do ecrã
LINHA_MAX      EQU 32         ; linha máxima do ecrã
LINHA_MIN      EQU 4          ; linha mínima de movimento no ecrã

; Colisões
LEITOR_OBJ     EQU 5          ; vê se algum objeto está a colidir
LEITOR_MISSIL  EQU 3          ; vê se o míssil está a colidir
COMPARAR_MISSIL EQU 10H       ; número de pixeis que o míssil percorre
EXPULSAR_MISSIL EQU 1000H     ; quando se dá uma colisão o míssil sai do ecrã
EXPULSAR_MISSIL2 EQU 2000H     ; quando se dá uma colisão o míssil sai do ecrã
EXPULSAR_OBJ   EQU 400        ; quando se dá uma colisão o objeto sai do ecrã

; Multimédia
; Contém os números dos elementos correspondentes
BG_INICIO      EQU 0
BG_FUNDO       EQU 1
BG_PAUSA       EQU 2
BG_SEM_ENERG   EQU 3
BG_COLISAO     EQU 4
BG_FIM_JOGO    EQU 5
SOM_FUNDO      EQU 0
SOM_ENERGIA    EQU 1          ; som ao ganhar energia
SOM_PAUSA      EQU 2
SOM_DISPARO    EQU 3
SOM_NAVE_EXP   EQU 2          ; explosão da nave
SOM_COLISAO    EQU 5
SOM_FIM_JOGO   EQU 6

; Backgrounds, sons e vídeos
BACKGROUND     EQU 6042H      ; seleciona o número do cenário de fundo a visualizar
DELET_BG       EQU 6040H      ; elimina o cenário de fundo
FRONT_BG       EQU 6046H      ; seleciona o número do cenário de fundo frontal a visualizar
DELET_FRONT_BG EQU 6044H      ; elimina o cenário de fundo frontal
SEL_MEDIA      EQU 6048H      ; seleciona o vídeo/som a ser reproduzido
PLAY_MEDIA     EQU 605AH      ; inicia a reprodução do som/vídeo especificado
PAUSE_MEDIA    EQU 605EH      ; pausa a reprodução do som/vídeo especificado
CONTINUE_MEDIA EQU 6060H      ; continua a reprodução do som/vídeo especificado
PLAY_LOOP      EQU 605CH      ; reproduz o som/vídeo especificado em ciclo até ser parado
STOP_LOOP      EQU 6066H      ; termina a reprodução do som/vídeo especificado
TROCA_VIDEO    EQU 6056H      ; especifica um padrão de transição entre vídeos
VOLUME         EQU 604AH      ; especifica o volume do som do vídeo/som especificado
DEL_ALL_PIXELS EQU 6002H      ; apaga todos os pixeis de todos os Ecrãs
STOP_ALL_MEDIA EQU 6068H      ; termina a reprodução de todos os vídeos/sons

; Ecrãs
SEL_ECRA       EQU 6004H      ; endereço do comando para selecionar um ecrã
MOSTRA_ECRA    EQU 6006H      ; endereço do comando para mostrar o ecrã especificado
ESCONDE_ECRA   EQU 6008H      ; endereço do comando para esconder o ecrã especificado
; Ecrãs dos elementos correspondentes
ECRA_NAVE      EQU 4
ECRA_MISSIL    EQU 3
ECRA_OBJETOS   EQU 2
ECRA_EFEITOS   EQU 7
ECRA_VINGANCA  EQU 8

; Coordenadas
LINHA_NAVE     EQU 24         ; linha inicial da nave
COLUNA_NAVE    EQU 30         ; coluna inicial da nave

MEGA_X_INICIAL EQU 30
MEGA_Y_INICAL  EQU 4          ; (valor absoluto)

; Tamanhos dos objetos
Quatro_por_Quatro   EQU 4     ; 4x4
Cinco_por_Cinco     EQU 5     ; 5x5

; Teclado
TEC_PRIM       EQU 1700H      ; endereço da memória que indica se há tecla premida ou não
TEC_TECLA      EQU 1702H      ; endereço da memória que indica qual a tecla premida
TEC_C_LIN      EQU 1704H
TEC_C_COL      EQU 1706H
TEC_SALTO      EQU 1708H
LINHA          EQU 16
TEC_MUL        EQU 4          ; valor a multiplicar para converter tecla para valor (4*linha+coluna)
; Teclas
TECLA_COMECO   EQU 0CH
TECLA_PAUSA    EQU 0FH

; Energia
ENERG_ATUAL    EQU 1800H      ; endereço da memória que guarda o valor da energia
ENERG_FULL     EQU 100        ; valor da energia
ENERGIA_DELTA  EQU 5          ; valor da energia que se ganhar por cada "ponto"
ENERGIA_GAMA   EQU 10         ; valor da energia que se ganhar por cada "ponto"

; Decimal
FAT            EQU 1000       ; fator a utilizar na conversão decimal
DIVID          EQU 10         ; dividendo a utilizar na conversão decimal
FAT_16         EQU 4

; Não tentes fugir do ecrã
Barreira_Direita    EQU 59    ; caso o jogador tente fugir do ecrã
Barreira_Esquerda   EQU 0     ; estes valores não o permitirão

; Delays
DELAY_NAVE     EQU 1000H

; Random
RANDOM_BETWEEN EQU 3          ; faz variar entre 0 e 2


;-------------------------------------------;
;---------------- Tabelas ------------------;
;-------------------------------------------;
PLACE     1000H
pilha:    TABLE 200H
SP_inicial:

; Tabela das rotinas de interrupção
int_tab:
             WORD int_objetos  ; IE0
             WORD int_missil   ; IE1
             WORD int_energia  ; IE2 (contador de energia)
			 WORD int_vinganca ; IE3 (controla o movimento dos objetos vingança)

; Tabela das funcionalidades do teclado
tec_tab:
             WORD loop         ; 0           DESCRIÇÃO: Organizando as funções de cada tecla
             WORD loop         ; 1                      numa tabela, é muito mais simples
             WORD loop         ; 2                      adicionar novas funciolidades
             WORD loop         ; 3
             WORD move_left    ; 4
             WORD disparar     ; 5
             WORD move_right   ; 6
             WORD loop         ; 7
             WORD loop         ; 8
             WORD loop         ; 9
             WORD loop         ; A
             WORD loop         ; B
             WORD comeca_jogo  ; C
             WORD loop         ; D
             WORD termina_jogo ; E
             WORD pausa_jogo   ; F


;-------------------------------------------;
;---------------- Sprites ------------------;
;-------------------------------------------;
; Míssil
missil_est:  WORD 00000H             ; DESCRICÃO: Os sprites são as imagens representativas de cada objeto.
			 WORD 0FFF0H                   ; Ficam guardados em memória.
			 WORD 00000H                   ; Exemplo: missil_est (estrutura representativa ao míssil)
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 00000H

; Nave
nave_est:
             WORD 00000H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H

; Naves inimigas
inimigo_est_pequeno:
             WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0FF00H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H


inimigo_est_medio:
             WORD 00000H
		     WORD 0F800H
		     WORD 0F800H
		     WORD 00000H
		     WORD 0F800H
		     WORD 00000H
		     WORD 0F800H
		     WORD 0F800H
		     WORD 0F800H
		     WORD 00000H
		     WORD 0F800H
		     WORD 0F800H
		     WORD 00000H
		     WORD 0F800H
		     WORD 0F800H
		     WORD 00000H

inimigo_est_grande:
             WORD 00000H
			 WORD 00000H
			 WORD 0FF00H
			 WORD 0FF00H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FF00H
			 WORD 00000H
			 WORD 0FF00H
			 WORD 0FF00H
			 WORD 0FF00H
			 WORD 0FF00H
			 WORD 0FF00H
			 WORD 0FF00H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FF00H
			 WORD 00000H
			 WORD 0FF00H
			 WORD 0FF00H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FF00H
			 WORD 0FF00H
			 WORD 00000H


; Asteroides
asteroide_est_pequeno:
             WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F0F0H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H

asteroide_est_medio:
             WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 00000H
			 WORD 00000H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 00000H
			 WORD 00000H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H

asteroide_est_grande:
             WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 00000H
			 WORD 00000H
			 WORD 00000H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 00000H
			 WORD 00000H
			 WORD 00000H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H
			 WORD 0F0F0H


;;; Mega Objetos ;;;
; Os mega objetos são semelhantes aos objetos anteriores, porém:
; 1 - Não podem ser destruídos por mísseis
; 2 - Tem a direção aleatória, sendo imprevisíveis
; 3 - Os seus sprites são diferentes de modo a haver distinção para o jogador

; Mega asteroides
MEGA_AST_est_pequeno:
             WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0FFF0H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H

MEGA_AST_est_medio:
             WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H

MEGA_AST_est_grande:
             WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 0FF0FH
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 00000H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H
			 WORD 0FFF0H

; MEGA Ovnis
MEGA_OVNI_est_pequeno:
             WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0FF0FH
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H
			 WORD 0F555H

MEGA_OVNI_est_medio:
             WORD 00000H
			 WORD 0F808H
			 WORD 0F808H
			 WORD 00000H
			 WORD 0F808H
			 WORD 00000H
			 WORD 0F808H
			 WORD 0F808H
			 WORD 0F808H
			 WORD 00000H
			 WORD 0F808H
			 WORD 0F808H
			 WORD 00000H
			 WORD 0F808H
			 WORD 0F808H
			 WORD 00000H

MEGA_OVNI_est_grande:
             WORD 00000H
			 WORD 00000H
			 WORD 0FF08H
			 WORD 0FF08H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FF08H
			 WORD 00000H
			 WORD 0FF08H
			 WORD 0FF08H
			 WORD 0FF08H
			 WORD 0FF08H
			 WORD 0FF08H
			 WORD 0FF08H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FF08H
			 WORD 00000H
			 WORD 0FF08H
			 WORD 0FF08H
			 WORD 00000H
			 WORD 00000H
			 WORD 0FF08H
			 WORD 0FF08H
			 WORD 00000H

; Efeito de explosão
explosao_est:
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH
			 WORD 00000H
			 WORD 0F0FFH


;-------------------------------------------;
;-------------- Coordenadas ----------------;
;-------------------------------------------;
; A coordenada chave é utilizada na função desenho
; é a coordenada do pixel superior esquerdo do objeto
COORDENADA_CHAVE: WORD 0

; Os valores NAVE_X e Nave_Y são construídos relativamente à posição inicial da nave,
; ou seja, representam valores relativos
NAVE_X: WORD 0
NAVE_Y: WORD LINHA_NAVE

; Em certas funções são necessárias as coordenadas absolutas
; Para isso servem estas coordenadas
NAVE_X_EFETIVA: WORD 0
NAVE_Y_EFETIVA: WORD 0

; Míssil
MISSIL_X: WORD 1000   ; X do míssil   (NOTA: estes valores são elevados de modo a não provorcar nenhuma colisão impossível)
MISSIL_Y: WORD 1000   ; Y do míssil

; Objetos (OVNIS ou asteroides) - coordenadas iniciais
OBJ_1_X: WORD 27
OBJ_1_Y: WORD 3

OBJ_2_X: WORD 30
OBJ_2_Y: WORD 3

OBJ_3_X: WORD 33
OBJ_3_Y: WORD 3

; Objetos Mega - coordenadas iniciais
MEGA_X: WORD 30
MEGA_Y: WORD -4

; Objetos Vingança - coordenadas iniciais
; De modo a não sobrecarregar o ecrã, apenas é possivel
; 3 objetos do tipo vingança coexistirem
VINGANCA_1_X:  WORD 30
VINGANCA_1_Y:  WORD -4

VINGANCA_2_X:  WORD 30
VINGANCA_2_Y:  WORD -4

VINGANCA_3_X:  WORD 30
VINGANCA_3_Y:  WORD -4


;-------------------------------------------;
;------------ Valores Lógicos --------------;
;-------------------------------------------;
; Míssil
; 0 - não existe
; 1 - existe
MISSIL_EXISTE:  WORD 0H
DESTROI_MISSIL: WORD 0H

; Existência dos objetos
; 0 - prontos a nascer
; 1 - não prontos a nascer
PRONTOS_A_NASCER: WORD 0H

; Objetos vingança
VINGANCA_1_EXISTE: WORD 0  ; 0 (não existe) // 1 (existe)
VINGANCA_2_EXISTE: WORD 0  ; 0 (não existe) // 1 (existe)
VINGANCA_3_EXISTE: WORD 0  ; 0 (não existe) // 1 (existe)


;-------------------------------------------;
;------------- Aleatoriedade  --------------;
;-------------------------------------------;
; Números entre 0 e 2
RANDOM_DIR: WORD 0H
RANDOM_NUM: WORD 0H

; Tipos dos objetos
; 0 - inimigo
; 1 - asteroide
Obj_1_tipo: WORD 0H
Obj_2_tipo: WORD 0H
Obj_3_tipo: WORD 0H
MEGA_TIPO: WORD 0H

; Direção dos objetos
; 0 - esquerda
; 1 - meio
; 2 - direita
MEGA_DIR: WORD 0H

VINGANCA_DIR: WORD 0
VINGANCA_TIPO: WORD 0
VINGANCA_TIPO_1: WORD 0
VINGANCA_TIPO_2: WORD 0
VINGANCA_TIPO_3: WORD 0

; Controladores de existencia dos tipos "Vinganca"
; 0 a 34 existe, a partir de 35 deixa de existir
C_EXI_V_1: WORD 0
C_EXI_V_2: WORD 0
C_EXI_V_3: WORD 0



;-------------------------------------------;
;----------------- Código  -----------------;
;-------------------------------------------;
PLACE      0
    MOV  BTE, int_tab        ; inicializa BTE (Base da Tabela das Excessões
    MOV  SP,  SP_inicial     ; inicializa o SP

; Ecrã de começar jogo
comecar:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 1               ; caso uma tecla esteja premida
    JZ   comecar             ; impede o jogo de começar
    MOV  R1, BG_INICIO
	CALL mudar_background    ; background de início de jogo
	MOV  R1, SOM_FUNDO
	CALL play_som			 ; som de início de jogo
espera_comecar:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 1               ; se tecla estiver premida avança-se
    JNZ  espera_comecar      ; se não espera-se por tecla premida
tecla_comecar:
    CALL teclado
    MOV  R0, TEC_TECLA
    MOV  R1, [R0]
    MOV  R2, TECLA_COMECO
    CMP  R1, R2              ; se a tecla premida for a tecla de começo, começa-se o jogo
    JNZ  espera_comecar      ; senão, espera-se que esta seja premida

; Após começar o jogo
    EI                       ; permite interrupções globalmente
    EI0                      ; permite movimento dos OVNI's
    EI1                      ; permite movimento do míssil
    EI2                      ; permite interrupção do contador de energia
	EI3                      ; permite o movimento de um dos objetos especiais
    CALL init_energia
    CALL apaga_cenarios
    CALL init_missil
	CALL init_nave
	CALL spawna_objetos
    MOV  R1, BG_FUNDO
    CALL mudar_background    ; background de fundo
    MOV  R1, SOM_FUNDO
    CALL play_som            ; som de fundo
    JMP  loop

depois_pausa:                ; salta para esta rotina depois de despausar o jogo
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 1               ; se a tecla de pausa ainda estiver premida
    JZ   depois_pausa        ; espera-se que esta seja largada
    MOV  R1, SOM_PAUSA
    CALL play_som


; Ciclo principal
loop:
	CALL randomizer          ; gerador de números aleatórios
    CALL teclado_estado      ; averigua se há teclas premidas
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 1               ; se uma tecla estiver premida
    JZ   salta_tecla         ; averigua qual a tecla premida
	CALL spawna_objetos      ; trata do spawn dos objetos
    MOV  R0, ENERG_ATUAL
    MOV  R1, [R0]
    CMP  R1, 0               ; reconhece se a energia está a 0
    JZ   n_energia
	JMP  loop                ; repete loop
salta_tecla:
    CALL teclado
    MOV  R0, TEC_SALTO
    MOV  R1, [R0]
    JMP  R1                  ; salta para a rotina correspondente à tecla
n_energia:
    CALL sem_energia         ; rotina que trata do final de jogo devido à falta de energia


;--- Rotinas auxiliares ---;
;----------------- Init Energia ------------------;
; Inicia o contador de energia                    ;
;-------------------------------------------------;
init_energia:
    PUSH R0
    PUSH R11
    MOV  R0, ENERG_ATUAL     ; endereço da memória onde se guarda a energia
    MOV  R11, ENERG_FULL     ; valor da energia máxima
    MOV  [R0], R11           ; guarda o valor da energia em hexadecimal na memória
    CALL decimal             ; converte R11 para decimal
    MOV  R0, DISPLAYS
    MOV  [R0], R11           ; inicializa DISPLAYS com energia a 100
    POP  R11
    POP  R0
    RET


;------------------- Init Nave -------------------;
; Inicia a nave no ecrã                           ;
;-------------------------------------------------;
init_nave:
	PUSH R0
	PUSH R1
	MOV  R0, NAVE_X          ; tebela de estrutura da nave
	MOV  R1, 0               ; coordenadas da nave
	MOV  [R0], R1
  	MOV  R2, LINHA_NAVE      ; coordenadas iniciais da nave (X)
	MOV  R3, COLUNA_NAVE     ; coordenadas iniciais da nave (Y)
    CALL nave                ; rotina para desenhar a nave
    POP  R1
    POP  R0
    RET


;------------------ Init Míssil ------------------;
; Inicia o míssil                                 ;
;-------------------------------------------------;
init_missil:
    PUSH R0
    PUSH R1
	MOV  R0, MISSIL_EXISTE
	MOV  R1, 0
	MOV  [R0], R1            ; indicar que não está a ser disparado nenhum míssil
    POP  R1
    POP  R0
    RET


;--------------- Mudar Background ----------------;
; Recebe: R1, nº do cenário de fundo              ;
; Muda o cenário de fundo                         ;
;-------------------------------------------------;
mudar_background:
	PUSH R0
	MOV  R0, BACKGROUND
    MOV  [R0], R1            ; muda o background para o cenário com o valor de R1
    POP  R0
    RET


; ---------- Mudar Background Frontal ------------;
; Recebe: R1, nº do cenário frontal               ;
; Muda o cenário frontal                          ;
;-------------------------------------------------;
mudar_background_f:
	PUSH R0
	MOV  R0, FRONT_BG
    MOV  [R0], R1            ; muda o cenário frontal para aquele que tiver o valor de R1
    POP  R0
    RET


; --------- Apagar Background Frontal ------------;
; Recebe: R1, nº do cenário frontal               ;
; Apaga o cenário frontal                          ;
;-------------------------------------------------;
apagar_background_f:
	PUSH R0
	MOV  R0, DELET_FRONT_BG
    MOV  [R0], R1            ; apaga o cenário frontal com o valor de R1
    POP  R0
    RET


; ------------------ Play Som --------------------;
; Recebe: R1, nº do som                           ;
; Toca o som correspondente ao valor de R1        ;
;-------------------------------------------------;
play_som:
	PUSH R0
	MOV  R0, PLAY_MEDIA
    MOV  [R0], R1            ; toca o som com o valor de R1
    POP  R0
    RET


; ----------------- Pause Som --------------------;
; Recebe: R1, nº do som                           ;
; Pausa o som correspondente ao valor de R1       ;
;-------------------------------------------------;
pause_som:
	PUSH R0
	MOV  R0, PAUSE_MEDIA
    MOV  [R0], R1            ; pausa o som com o valor de R1
    POP  R0
    RET


; ---------------- Unpause Som -------------------;
; Recebe: R1, nº do som                           ;
; Continua o som correspondente ao valor de R1    ;
;-------------------------------------------------;
unpause_som:
	PUSH R0
	MOV  R0, CONTINUE_MEDIA
    MOV  [R0], R1            ; continua o som com o valor de R1
    POP  R0
    RET


; ------------------ Stop Som --------------------;
; Para a reprodução de todos os sons              ;
;-------------------------------------------------;
stop_som:
	PUSH R0
	PUSH R1
	MOV  R0, STOP_ALL_MEDIA
    MOV  R1, 1
    MOV  [R0], R1            ; para a reprodução de todos os sons
    POP  R1
    POP  R0
    RET


; --------------- Apaga Cenários -----------------;
; Apaga os píxeis de todos os ecrãs               ;
;-------------------------------------------------;
apaga_cenarios:
    PUSH R0
    PUSH R1
	MOV  R0, APAGAR_TOTAL
	MOV  R1, 0
	MOV  [R0], R1             ; apaga todos os ecrãs
    POP  R1
    POP  R0
    RET


;--------------- Teclado - Estado ----------------;
; Devolve: TEC_PRIM, 0 se nenhuma tecla premida   ;
;                    1 se tecla premida           ;
;-------------------------------------------------;
teclado_estado:
     PUSH R0
     PUSH R1
     PUSH R2
     PUSH R3
     PUSH R4
     MOV  R1, LINHA           ; o "varredor" de linhas inicia com o valor máximo
     MOV  R2, TEC_LIN         ; endereço do periférico das linhas
     MOV  R3, TEC_COL         ; endereço do periférico das colunas
reset:
     SHR  R1, 1               ; age como "varredor" de linhas
     CMP  R1, 0               ; se o "varredor" chegar a 0
     JZ   no_tecla            ; conclui-se que não há tecla premida
curto_circuito:
     MOVB [R2], R1            ; escrever no periférico de saída (linhas)
     MOVB R4, [R3]            ; ler do periférico de entrada (colunas)
     MOV  R0, TEC_C_LIN
     MOV  [R0], R1            ; escreve linha na memória
     MOV  R0, TEC_C_COL
     MOV  [R0], R4            ; escreve coluna na memória
     CMP  R4, 0               ; se não há tecla premida
     JZ   reset               ; volta-se a decrementar o "varredor" de linhas
tecla:
     MOV  R0, TEC_PRIM
     MOV  R1, 1
     MOV  [R0], R1            ; indica que há tecla premida
     JMP  sai_teclado
no_tecla:
     MOV  R0, TEC_PRIM
     MOV  R1, 0
     MOV  [R0], R1            ; indica que não há tecla premida
sai_teclado:
     POP  R4
     POP  R3
     POP  R2
     POP  R1
     POP  R0
     RET


;------------------------------- Teclado -------------------------------;
; Devolve: TEC_TECLA, valor da tecla premida (igual ao símbolo da tecla);
;          TEC_SALTO, endereço do label correspondente à tecla premida  ;
;-----------------------------------------------------------------------;
teclado:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    MOV  R2, 0              ; contador de linhas
    MOV  R3, 0              ; contador de colunas
    MOV  R0, TEC_C_LIN
    MOV  R1, [R0]           ; lê o valor da linha da tecla premida, da memória
descobrir_linha:
    ADD  R2, 1              ; adiciona 1 ao contador de linhas
	SHR  R1, 1              ; assume o valor da linha anterior
    JNZ  descobrir_linha    ; quando o valor da linha é 0, o contador tem o valor certo
    MOV  R0, TEC_C_COL
    MOV  R1, [R0]           ; lê o valor da coluna da tecla premida, da memória
descobrir_coluna:
    ADD  R3, 1              ; adiciona 1 ao contador de colunas
    SHR  R1, 1              ; assume o valor da coluna anterior
    JNZ  descobrir_coluna   ; quando o valor da coluna é 0, o contador tem o valor certo
registo_tecla:
    SUB  R2, 1              ; enquadrar a linha entre 1 e 3
    SUB  R3, 1              ; enquadrar a coluna entre 1 e 3
    MOV  R5, TEC_MUL
    MUL  R2, R5
    ADD  R2, R3             ; R2 = 4*linha+coluna
    MOV  R0, TEC_TECLA
    MOV  [R0], R2           ; guarda o valor da tecla premida na memória
    SHL  R2, 1              ; multiplica R2 por 2 de modo a indexar a tabela de funcionalidades do teclado
    MOV  R4, tec_tab
    MOV  R0, TEC_SALTO
    MOV  R1, [R4+R2]
    MOV  [R0], R1           ; guarda o endereço do label associado à tecla premida
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


;------------------ int_Energia ------------------;
; Correponde a uma interrupção (INT2)             ;
; Recebe: ENERG_ATUAL, valor da energia           ;
; Devolve: ENERG_ATUAL, valor da energia - 5      ;
;-------------------------------------------------;
int_energia:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R11
    MOV  R0, ENERG_ATUAL     ; valor da energia atual
    MOV  R1, [R0]
    MOV  R2, ENERGIA_DELTA
    SUB  R1, R2              ; subtrai 5 ao valor da energia em hexadecimal
    MOV  [R0], R1
    MOV  R11, R1
    CALL decimal             ; converte o valor da energia para decimal
    MOV  R0, DISPLAYS
    MOV  [R0], R11           ; coloca o valor da energia nos DISPLAYS
    POP  R11
    POP  R2
    POP  R1
    POP  R0
    RFE


;-------------------- Energia --------------------;
; Recebe: ENERG_ATUAL, valor da energia           ;
;         R2, valor a aumentar (admite negativos) ;
; Devolve: ENERG_ATUAL, valor da energia + R2     ;
;-------------------------------------------------;
energia:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R11
    MOV  R0, ENERG_ATUAL     ; valor da energia atual
    MOV  R1, [R0]
    ADD  R1, R2              ; adiciona o valor de R2 ao valor da energia em hexadecimal
    MOV  [R0], R1
    MOV  R11, R1
    CALL decimal
    MOV  R0, DISPLAYS
    MOV  [R0], R11           ; coloca o valor da energia nos DISPLAYS
    POP  R11
    POP  R2
    POP  R1
    POP  R0
    RET

;-------------------- Decimal --------------------;
; Recebe: R11 (com um valor hexadecimal)          ;
; Devolve: R11 (com um valor decimal)             ;
;-------------------------------------------------;
decimal:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    MOV     R0, FAT           ; fator
    MOV     R1, DIVID         ; prepara para divisão por 10
    MOV     R2, R11
    MOV     R11, 0            ; o resultado em decimal será guardado em R11
ciclo:
    MOD     R2, R0            ; resto da divisão por 1000
    MOV     R3, R2            ; copia o valor para outro registo
    DIV     R0, R1            ; fator divide por 10
    DIV     R3, R0            ; esta operação devolve o digito que se procura
    SHL     R11, FAT_16       ; multiplica por 16 (em decimal corresponde a multiplicar por 10)
    ADD     R11, R3           ; adiciona o dígito ao resultado final
    CMP     R0, 1             ; quando o fator for igual a 1 a conversão acaba
    JNZ     ciclo             ; repete até o fator ser 1
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

;-------------------------------------------;
;---------------- Desenhos  ----------------;
;-------------------------------------------;
; Cada uma das seguintes rotinas prepara o desenho
; do objeto com o nome da rotina

; Para a construção dos desenhos precisa-se de:
; 1 - Ecrã do desenho
; 2 - Largura do desenho
; 3 - Estrutura utilizada para o desenho (sprite)
; 4 - Linha da coordenada chave
; 5 - Coluna da coordenada chave

nave:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R0, ECRA_NAVE
	MOV  R1, SEL_ECRA
	MOV  [R1], R0                  ; seleção do ecrã
    MOV  R0, LARGURA_NAVE          ; largura da nave
	MOV  R1, nave_est
	MOV  R8, NAVE_X_EFETIVA
	MOV  [R8], R3                  ; coordenada x da nave
	MOV  R8, NAVE_Y_EFETIVA
	MOV  [R8], R2                  ; coordenada y da nave
	JMP  desenhar

missil:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R0, ECRA_MISSIL
	MOV  R1, SEL_ECRA
	MOV  [R1], R0                   ; seleção do ecrã
    MOV  R0, LARGURA_MISSIL         ; largura do míssil
	MOV  R1, missil_est
	JMP  desenhar

objeto_esquerdo:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R5, ECRA_OBJETOS
	MOV  R6, SEL_ECRA
	MOV  [R6], R5                   ; seleção do ecrã
	MOV  R6, OBJ_1_X
	MOV  R3, [R6]                   ; coordenada x do objeto
	MOV  R6, OBJ_1_Y
	MOV  R2, [R6]                   ; coordenada y do objeto
	JMP  desenhar

objeto_meio:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R5, ECRA_OBJETOS
	MOV  R6, SEL_ECRA
	MOV  [R6], R5                   ; seleção do ecrã
	MOV  R6, OBJ_2_X
	MOV  R3, [R6]                   ; coordenada x do objeto
	MOV  R6, OBJ_2_Y
	MOV  R2, [R6]                   ; coordenada y do objeto
	JMP  desenhar

objeto_direito:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R5, ECRA_OBJETOS
	MOV  R6, SEL_ECRA
	MOV  [R6], R5                   ; seleção do ecrã
	MOV  R6, OBJ_3_X
	MOV  R3, [R6]                   ; coordenada x do objeto
	MOV  R6, OBJ_3_Y
	MOV  R2, [R6]                   ; coordenada y do objeto
	JMP  desenhar


; Alguns dos objetos já traziam a maior parte das informações
; relevantes referidas na nota inicial deste segmento
; Então é fácil criar uma função geral que satisfaça a sua função particular

; FALHA NA OTIMIZAÇÃO:
; Todas as funções de preparações de estrutura poderiam ter sido reduzidas
; a 1. Bastaria ter passado todas as informações relevantes à função desenho
objeto_geral:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R5, ECRA_OBJETOS
	MOV  R6, SEL_ECRA
	MOV  [R6], R5                    ; ecrã do objeto geral
	JMP desenhar

; Esta função é semelhante à anterior. Porém desenha apenas efeitos (p.e explosões)
objeto_geral_aux:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R5, ECRA_EFEITOS
	MOV  R6, SEL_ECRA
	MOV  [R6], R5                    ; seleção do ecrã dos efeitos
	JMP  desenhar

MEGA_OVNI:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R5, ECRA_MISSIL             ; ecrã do MEGA OBJETO, é o mesmo que o do missil
	MOV  R6, SEL_ECRA
	MOV  [R6], R5
	JMP  desenhar

vinganca:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R5, ECRA_VINGANCA           ; ecrã do objeto vinganca
	MOV  R6, SEL_ECRA
	MOV  [R6], R5
	JMP  desenhar


;-------------------- Desenhar -------------------;
; Inicia a nave no ecrã.                          ;
; Recebe: qualquer objeto a desenhar no ecrã      ;
;         dadas as informações necessárias.       ;
;-------------------------------------------------;
desenhar:
	MOV  R6, 0                 ; R6 é o contador de pixeis
	MOV  R5, R0                ; replicar o valor da largura do objeto (evolutivo // altera)
	MOV  R8, R0                ; replicar o valor da largura (comparativo // não altera)
	MOV  R4, 0                 ; R4 é o contador das linhas
	MOV  R0, COORDENADA_CHAVE  ; a coordenada chave irá iniciar o processo
	MOV  [R0], R2

DESENHO:
	MOV  R0, DEFINE_LINHA
	MOV  [R0], R2              ; seleciona a linha
	MOV  R0, DEFINE_COLUNA
    MOV  [R0], R3              ; seleciona a coluna
	MOV  R7, [R1]
	MOV  R0, DEFINE_PIXEL
    MOV  [R0], R7              ; altera a cor do pixel na linha e coluna selecionadas

	ADD  R1, 2                 ; progredir para o próximo pixel (para prosseguir tabelas words temos que somar +2)
	ADD  R2, 1                 ; progredir para a próxima linha
	ADD  R4, 1                 ; adicionar 1 ao contador de linhas
	ADD  R6, 1                 ; adicionar 1 ao contador de pixeis
	MUL  R5, R5                ; largura*largura
	CMP  R6, R5                ; (quando a L*L=contador de pixeis o desenho já terminou)
	JZ   fim_desenho
	MOV  R5, R8
	MOD  R4, R5                ; ver quando é que é para passar à próxima coluna
	JZ   vai
volta:
	CMP  R4, R5
	JZ   fim_desenho
	JMP  DESENHO               ; continua a desenhar
vai:
	MOV  R0, COORDENADA_CHAVE
	MOV  R2, [R0]
	ADD  R3, 1                 ; adiciona 1 à coluna
	JMP  volta

fim_desenho:                   ; o desenho terminou
	POP  R8
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET


;-------------------------------------------;
;---------------- Movimento ----------------;
;-------------------------------------------;
;----------------- move_right --------------------;
; Move a nave para a direita                      ;
;-------------------------------------------------;
move_right:                      ; para ver se temos ou não que prender a nave (caso ela tente sair do ponto de vista do jogador)
	PUSH R2                      ; então devemos utilizar os valores absolutos das suas coordenadas
    MOV  R2, NAVE_X_EFETIVA
    MOV  R1, [R2]
    MOV  R2, Barreira_Direita    ; caso ele tente ir além da barreira, será impossível mover mais a nave nesta direção
    CMP  R1, R2
    JZ   prender
    JMP  n_prender               ; caso não tente, o movimento irá ocorrer como normalmente
prender:
    POP  R2
    JMP  loop
n_prender:                       ; de modo a não criar erros visuais, é importante reinicar o ecrã onde
	MOV  R0, ECRA_NAVE           ; se escrevem os novos pixeis, apagando o ecrã
	MOV  R1, SEL_ECRA
	MOV  [R1], R0
	MOV  R0, ECRA_NAVE
	MOV  R1, APAGAR_ECRA
	MOV  [R1], R0
	MOV  R2, NAVE_X
	MOV  R3, [R2]
	ADD  R3, 1                   ; adicionar 1 à coordenada x da nave (andar para a direita)
	MOV  [R2], R3
	MOV  R3, COLUNA_NAVE
	MOV  R4, [R2]
	ADD  R3, R4
	POP  R2
	CALL nave                    ; atualizar o desenho da nave com as novas coordenadas
	PUSH R0
	MOV  R0, DELAY_NAVE
delay_move_right:                ; o delay da nave atrasa o movimento da nave
	SUB  R0, 1                   ; decremento do valor inicial do delay da nave
	CMP  R0, 0                   ; até este ser 0 (quando for zero o delay foi concluido)
	JNZ  delay_move_left
	JMP  loop


;------------------ move_left --------------------;
; Move a nave para a esquerda                     ;
;-------------------------------------------------;
; O move_left é em tudo semelhante ao move right mas
; 1 - Em vez de aumentar a coordenada x, diminui
; 2 - Em vez de prender o movimento no valor máximo de x, prende-se no menor
move_left:
	PUSH R2
    MOV  R2, NAVE_X_EFETIVA
    MOV  R1, [R2]
    MOV  R2, Barreira_Esquerda   ; FALHAS NA OTIMIZAÇÃO: Poder-se-ia ter desenhado uma função de movimento
    CMP  R1, R2                  ; geral da nave que recebia dois valores, 1 ou -1 // Barreira_Direita ou Barreira_Esquerda
    JZ   prender                 ; e depois utilizava estes valores somando 1 ou -1 ao x escolhendo o trajeto da nave
    JMP  l_n_prender             ; e comparando o X com a barreira escolhida de modo a impedir o movimento caso necessário
l_n_prender:
	MOV  R0, ECRA_NAVE
	MOV  R1, SEL_ECRA
	MOV  [R1], R0
	MOV  R0, ECRA_NAVE
	MOV  R1, APAGAR_ECRA
	MOV  [R1], R0
	MOV  R2, NAVE_X
	MOV  R3, [R2]
	SUB  R3, 1
	MOV  [R2], R3
	MOV  R3, COLUNA_NAVE
	MOV  R4, [R2]
	ADD  R3, R4
	POP  R2
	CALL nave
	PUSH R0
	MOV  R0, DELAY_NAVE
delay_move_left:
	SUB  R0, 1
	CMP  R0, 0
	JNZ  delay_move_left
	POP  R0
	JMP  loop


;------------------- disparar --------------------;
; Dispara um míssil e impede a criação de mais    ;
;-------------------------------------------------;
disparar:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	MOV  R0, MISSIL_EXISTE
	MOV  R1, [R0]
	CMP  R1, 1                   ; se já existir um missil,
	JZ   fim_disparo             ; não se dispara mais
	MOV  R0, MISSIL_Y            ; se ainda não existir um missil
	MOV  R1, 0                    ; iremos reinicar as coordenadas iniciais do missil em Y
	MOV  [R0], R1                ; e iremos atribuir um novo X ao missil
	MOV  R0, NAVE_X              ; este novo X corresponde ao X absoluto da nave
	MOV  R1, [R0]                ; (o x absoluto da nave corresponde ao x relativo à coordenada inicial
	MOV  R0, COLUNA_NAVE         ; mais o valor a somar ao reltivo)
	ADD  R1, R0
	MOV  R3, R1
	ADD  R3, 1                   ; esta porção é adicionada de modo a ficar bem centrado
	MOV  R2, LINHA_NAVE
	CALL missil
	MOV  R0, MISSIL_X
	MOV  [R0], R3
	MOV  R0, MISSIL_EXISTE       ; temos que mudar o valor do missil exite para 1
	MOV  R1, 1                   ; de modo a registar que o missil agora existe
	MOV  [R0], R1
    MOV  R2, -ENERGIA_DELTA      ; quando disparamos perdemos energia
    CALL energia
    MOV  R1, SOM_DISPARO
    CALL play_som                ; e há um som de disparo
espera_disparar:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 0                   ; enquanto a tecla estiver premida,
    JNZ  espera_disparar         ; permanece-se neste ciclo de modo a não disparar de modo "contínuo"
fim_disparo:
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	JMP  loop


;------------------ Randomizer -------------------;
; Devolve: RANDOM_NUM, (randomizer)               ;
;		   RANDOM_DIR, (randomizer2)              ;
;          Ambos números entre 0 e 2              ;
; Utilizado para escolher tipos e direções de     ;
; objetos, respetivamente.                        ;
;-------------------------------------------------;
randomizer:
	PUSH R0
	PUSH R1
	PUSH R2
	MOV  R0, RANDOM_NUM
	MOV  R1, 1
	MOV  R2, [R0]
	ADD  R2, R1
	MOV  R1, RANDOM_BETWEEN
	MOD  R2, R1
	MOV  [R0], R2
	POP  R2
	POP  R1
	POP  R0
	RET

randomizer_2:
	PUSH R0
	PUSH R1
	PUSH R2
	MOV  R0, RANDOM_DIR
	MOV  R1, 1
	MOV  R2, [R0]
	ADD  R2, R1
	MOV  R1, RANDOM_BETWEEN
	MOD  R2, R1
	MOV  [R0], R2
	POP  R2
	POP  R1
	POP  R0
	RET


;-------------------------------------------;
;----------- Criação de Objetos ------------;
;-------------------------------------------;
;--------------- spawna_objetos ------------------;
; Cria os inimigos e asteroide normais            ;
; Asteroides - verdes                             ;
; Inimigos - vermelhos                            ;
; Podem ser destruídos                            ;
;-------------------------------------------------;
spawna_objetos:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	MOV  R0, PRONTOS_A_NASCER   ; 0 - prontos // 1 - não prontos
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   ja_existem             ; se não estão prontos é porque já existem
	CALL spawn_mega             ; caso estejam prontos criam um mega objeto
	MOV  R1, 1
	MOV  [R0], R1               ; impede que possam nascer mais até a próxima "onda" de objetos
	MOV  R0, Obj_1_tipo
	MOV  R1, 0
	MOV  [R0], R1
	MOV  R0, Obj_2_tipo
	MOV  R1, 0
	MOV  [R0], R1
	MOV  R0, Obj_3_tipo
	MOV  R1, 0
	MOV  [R0], R1
	MOV  R0, RANDOM_NUM         ; dependendo do valor aleatório do número os objetos serão criados
	MOV  R1, [R0]               ; de formas diferentes
	CMP  R1, 0
	JZ   spawna_ast_1           ; onda do tipo 1
	CMP  R1, 1
	JZ   spawna_ast_2           ; onda do tipo 2
	JMP  spawna_ast_3           ; onda do tipo 3
ja_existem:
	POP R3
	POP R2
	POP R1
	POP R0
	RET


;----------------- spawna_ast_1 ------------------;
; Cria o primeiro asteroide.                      ;
;-------------------------------------------------;
spawna_ast_1:
	MOV  R0, Obj_1_tipo              ; alterar o tipo do objeto 1 para 1 (1 faz alusão ao tipo asteroide)
	MOV  R1, 1
	MOV  [R0], R1
	MOV  R0, OBJ_1_X                 ; inicializar as coordenadas dos objetos
	MOV  R2, [R0]
	MOV  R0, OBJ_1_Y
	MOV  R3, [R0]
	MOV  R0, LARGURA_PEQUENO
	MOV  R1, asteroide_est_pequeno
	CALL objeto_esquerdo             ; desenhar o objetos esquerdo
	MOV  R1, inimigo_est_pequeno
	CALL objeto_meio                 ; desenhar o objeto do centro
	MOV  R1, inimigo_est_pequeno
	CALL objeto_direito              ; desenhar o objeto da direita
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET


;----------------- spawna_ast_2 ------------------;
; Cria o segundo asteroide.                       ;
;-------------------------------------------------;
spawna_ast_2:                        ; FALHAS NA OTIMIZAÇÃO: O código relativo ao spawna_ast_k poderia ter sido
	MOV  R0, Obj_2_tipo                   ; agrupado em apenas um. Bastava colocar um LEITOR_OBJ do número random afetando diretamente
	MOV  R1, 1                            ; a estrutura escolhida e não um grupo de estruturas como foi feito.
	MOV  [R0], R1
	MOV  R0, OBJ_1_X
	MOV  R2, [R0]
	MOV  R0, OBJ_1_Y
	MOV  R3, [R0]
	MOV  R0, LARGURA_PEQUENO
	MOV  R1, asteroide_est_pequeno
	CALL objeto_meio
	MOV  R1, inimigo_est_pequeno
	CALL objeto_esquerdo
	MOV  R1, inimigo_est_pequeno
	CALL objeto_direito
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET


;----------------- spawna_ast_3 ------------------;
; Cria o terceiro asteroide.                      ;
;-------------------------------------------------;
spawna_ast_3:
	MOV  R0, Obj_3_tipo
	MOV  R1, 1
	MOV  [R0], R1
	MOV  R0, OBJ_1_X
	MOV  R2, [R0]
	MOV  R0, OBJ_1_Y
	MOV  R3, [R0]
	MOV  R0, LARGURA_PEQUENO
	MOV  R1, asteroide_est_pequeno
	CALL objeto_direito
	MOV  R1, inimigo_est_pequeno
	CALL objeto_esquerdo
	MOV  R1, inimigo_est_pequeno
	CALL objeto_meio
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET


;-------------------------------------------;
;---------- Movimento de Objetos -----------;
;-------------------------------------------;
;------------------ int_objetos ------------------;
; Movimenta os objetos.                           ;
; Correpondende a uma interrupçã (INT0)           ;
;-------------------------------------------------;
int_objetos:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	MOV  R0, ECRA_EFEITOS         ; apagar o ecrã dos efeitos
	MOV  R1, APAGAR_ECRA
	MOV  [R1], R0
	CALL randomizer_2             ; alterar o valor do número random para as direções
	CALL colisoes_geral           ; reconhece se houve colisões no momento anterior
	MOV  R0, PRONTOS_A_NASCER
	MOV  R1, [R0]
	CMP  R1, 0                    ; se estiver a zero significa que estão prontos a nascer, logo não existem
	JZ   nao_existem
	MOV  R0, ECRA_OBJETOS
	MOV  R1, SEL_ECRA
	MOV  [R1], R0
	MOV  R0, ECRA_OBJETOS
	MOV  R1, APAGAR_ECRA
	MOV  [R1], R0
	CALL mega_movimento           ; movimenta o mega objeto
	MOV  R6, 0
	MOV  R0, OBJ_1_Y
	MOV  R1, [R0]
	MOV  R2, LINHA_MIN
	CMP  R1, R2                   ; se a linha for inferior ou igual a 4
	JLE  obj_tamanho_2_obj_1      ; os objetos estão afastados o suficiente para o tamanho médio
	MOV  R2, LINHA_MAX            ; se a linha for superior a 32
	CMP  R1, R2                   ; iremos destruir os objetos
	JLE  obj_tamanho_3_obj_1      ; caso contrário eles já estão no seu tamanho grande
	JMP  destroi_objetos
nao_existem:                          ; se eles não existem não faz sentido movimentá-los
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE

;---------------- destroi_objetos ----------------;
; Destrói os objetos.                             ;
;-------------------------------------------------;
destroi_objetos:                      ; se estão além da coluna 32
	MOV  R0, PRONTOS_A_NASCER     ; deixam de existir
	MOV  R1, 0                    ; desta maneira iremos colocar o PRONTOS_A_NASCER a 0
	MOV  [R0], R1                 ; significa que poderão nascer
	CALL reiniciar_objetos        ; reiniciar os objetos
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE

obj_tamanho_2_obj_1:                  ; R6 começa a 0 e simboliza o número do objeto
	ADD  R6, 1                    ; p.e se R6 = 2 refere-se ao objeto 3
	MOV  R5, OBJ_1_X              ; atribuir o X ao R3 (R3 guarda o valor da coluna)
	MOV  R3, [R5]
	SUB  R3, 1                    ; o objeto 1 anda sempre para a esquerda -> subtrair 1
	MOV  [R5], R3
	MOV  R5, OBJ_1_Y              ; atribuir Y ao R2 (R2 guarda o valor da linha)
	MOV  R2, [R5]
	ADD  R2, 1                    ; adicionar 1 ao Y
	MOV  [R5], R2
	MOV  R0, Quatro_por_Quatro    ; guardar o tamanho em R0
	MOV  R1, Obj_1_tipo           ; ver se é asteroide ou inimigo para conseguir fazer o desenho
	MOV  R4, [R1]
	CMP  R4, 1
	JZ   eh_asteroide
	JMP  eh_inimigo

obj_tamanho_3_obj_1:              ; FALHAS NA OTIMIZAÇÃO: Todas as funções objetos_tamanho_k_obj_i
	ADD  R6, 1                    ; podem ser fundidas em apenas uma função, um bocadinho maior mas mais
	MOV  R5, OBJ_1_X              ; geral. Bastaria apenas criar um valor na memória que seja capaz de
	MOV  R3, [R5]                 ; gerar os valores corretos para o objeto 1, objeto 2 e objeto 3.
	SUB  R3, 1                    ; Apesar desta correção não ter sido executada nas funções para estes objetos
	MOV  [R5], R3                 ; A solução foi executada nos objetos seguintes (mega objeto e objeto vingança).
	MOV  R5, OBJ_1_Y
	MOV  R2, [R5]
	ADD  R2, 1
	MOV  [R5], R2
	MOV  R0, Quatro_por_Quatro
	MOV  R1, Obj_1_tipo
	MOV  R4, [R1]
	CMP  R4, 1
	JZ   eh_asteroide_grande
	JMP  eh_inimigo_grande

obj_tamanho_2_obj_2:
	ADD  R6, 1
	MOV  R5, OBJ_2_X
	MOV  R3, [R5]
	MOV  R5, OBJ_2_Y
	MOV  R2, [R5]
	ADD  R2, 1
	MOV  [R5], R2
	MOV  R0, Quatro_por_Quatro
	MOV  R1, Obj_2_tipo
	MOV  R4, [R1]
	CMP  R4, 1
	JZ   eh_asteroide
	JMP  eh_inimigo

obj_tamanho_3_obj_2:
	ADD  R6, 1
	MOV  R5, OBJ_2_X
	MOV  R3, [R5]
	MOV  R5, OBJ_2_Y
	MOV  R2, [R5]
	ADD  R2, 1
	MOV  [R5], R2
	MOV  R0, Quatro_por_Quatro
	MOV  R1, Obj_2_tipo
	MOV  R4, [R1]
	CMP  R4, 1
	JZ   eh_asteroide_grande
	JMP  eh_inimigo_grande

obj_tamanho_2_obj_3:
	ADD  R6, 1
	MOV  R5, OBJ_3_X
	MOV  R3, [R5]
	ADD  R3, 1
	MOV  [R5], R3
	MOV  R5, OBJ_3_Y
	MOV  R2, [R5]
	ADD  R2, 1
	MOV  [R5], R2
	MOV  R0, Quatro_por_Quatro
	MOV  R1, Obj_3_tipo
	MOV  R4, [R1]
	CMP  R4, 1
	JZ   eh_asteroide
	JMP  eh_inimigo

obj_tamanho_3_obj_3:
	ADD  R6, 1
	MOV  R5, OBJ_3_X
	MOV  R3, [R5]
	ADD  R3, 1
	MOV  [R5], R3
	MOV  R5, OBJ_3_Y
	MOV  R2, [R5]
	ADD  R2, 1
	MOV  [R5], R2
	MOV  R0, Quatro_por_Quatro
	MOV  R1, Obj_3_tipo
	MOV  R4, [R1]
	CMP  R4, 1
	JZ   eh_asteroide_grande
	JMP  eh_inimigo_grande


;------------------ eh_asteroide -----------------;
; Reconhece se o objeto é um asteroide.           ;
;-------------------------------------------------;
eh_asteroide:                         ; se for asteroide então R1 -> estrutura do asteroide medio
	MOV  R1, asteroide_est_medio  ; (relembrar o R1 guardava o registo da estrutura para efetuar o desenho)
	CALL objeto_geral             ; estamos a trabalhar com o objeto 2?
	CMP  R6, TAMANHO_MEDIO        ; se sim vamos para o objeto 2
	JZ   obj_tamanho_2_obj_2      ; estamos a trabalhar com o objeto 3?
	CMP  R6, TAMANHO_GRANDE       ; se sim vamos para o objeto 3
	JZ   obj_tamanho_2_obj_3
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE


;-------------- eh_asteroide_grande --------------;
; Reconhece se o objeto é um asteroide grande     ;
;-------------------------------------------------;
eh_asteroide_grande:                    ; semelhante ao processo eh_asteroide
	MOV  R1, asteroide_est_grande
	MOV  R0, Cinco_por_Cinco
	CALL objeto_geral
	CMP  R6, TAMANHO_MEDIO
	JZ   obj_tamanho_3_obj_2
	CMP  R6, TAMANHO_GRANDE
	JZ   obj_tamanho_3_obj_3
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE


;------------------- eh_inimigo ------------------;
; Reconhece se o objeto é um inimigo              ;
;-------------------------------------------------;
eh_inimigo:
	MOV  R1, inimigo_est_medio
	CALL objeto_geral
	CMP  R6, TAMANHO_MEDIO
	JZ   obj_tamanho_2_obj_2
	CMP  R6, TAMANHO_GRANDE
	JZ   obj_tamanho_2_obj_3
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE


;--------------- eh_inimigo_grande ---------------;
; Reconhece se o objeto é um inimigo grande       ;
;-------------------------------------------------;
eh_inimigo_grande:
	MOV  R1, inimigo_est_grande
	MOV  R0, Cinco_por_Cinco
	CALL objeto_geral
	CMP  R6, TAMANHO_MEDIO
	JZ   obj_tamanho_3_obj_2
	CMP  R6, TAMANHO_GRANDE
	JZ   obj_tamanho_3_obj_3
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE


;--------------- reiniciar_objetos ---------------;
; Reinicia coordenadas dos objetos.               ;
; Atua quando os objetos se encontram fora do ecrã;
;-------------------------------------------------;
reiniciar_objetos:
    PUSH R0
    PUSH R1
    MOV  R0, MEGA_X
    MOV  R1, MEGA_X_INICIAL
    MOV  [R0], R1
    MOV  R0, MEGA_Y
    MOV  R1, -MEGA_Y_INICAL
    MOV  [R0], R1

    MOV  R0, OBJ_1_X
    MOV  R1, RESET_OBJ_1_X
    MOV  [R0], R1
    MOV  R0, OBJ_1_Y
    MOV  R1, RESET_OBJ_Y
    MOV  [R0], R1

    MOV  R0, OBJ_2_X
    MOV  R1, RESET_OBJ_2_X
    MOV  [R0], R1
    MOV  R0, OBJ_2_Y
    MOV  R1, RESET_OBJ_Y
    MOV  [R0], R1

    MOV  R0, OBJ_3_X
    MOV  R1, RESET_OBJ_3_X
    MOV  [R0], R1
    MOV  R0, OBJ_3_Y
    MOV  R1, RESET_OBJ_Y
    MOV  [R0], R1

    MOV  R0, Obj_1_tipo
    MOV  R1, 0
    MOV  [R0], R1
    MOV  R0, Obj_2_tipo
    MOV  R1, 0
    MOV  [R0], R1
    MOV  R0, Obj_3_tipo
    MOV  R1, 0
    MOV  [R0], R1
    POP  R1
    POP  R0
    RET


;-------------------------------------------;
;--------- Criação de Objetos Mega ---------;
;-------------------------------------------;
; As seguintes funções tratam da criação dos mega objetos
spawn_mega:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	MOV  R0, LARGURA_VING           ; largura do objeto inicial
	MOV  R4, RANDOM_NUM
	MOV  R5, [R4]
	CMP  R5, 0
	JZ   nasce_mega_ast
	JMP  nasce_mega_ovni

nasce_mega_ast:
	MOV  R5, MEGA_DIR               ; a mega direção é escolhida aleatóriamente
	MOV  R4, RANDOM_DIR
	MOV  R6, [R4]
	MOV  [R5], R6
	MOV  R5, MEGA_TIPO              ; atribuir 1 ao mega tipo - > significa que é asteroide
	MOV  R4, 1
	MOV  [R5], R4
	MOV  R1, MEGA_AST_est_pequeno   ; estrutura de asteroide pequeno
	MOV  R4, MEGA_X
	MOV  R3, [R4]
	MOV  R4, MEGA_Y
	MOV  R2, [R4]
	CALL objeto_geral               ; desenhar o objeto
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

nasce_mega_ovni:                        ; muito semelhante ao nasce mega asteroide mas:
	MOV  R5, MEGA_DIR
	MOV  R4, RANDOM_DIR
	MOV  R6, [R4]
	MOV  [R5], R6
	MOV  R5, MEGA_TIPO
	MOV  R4, 0                      ; atribui-se 0 ao mega tipo -> é inimigo
	MOV  [R5], R4
	MOV  R1, MEGA_OVNI_est_pequeno  ; a estrutura é também de inimigo
	MOV  R4, MEGA_X
	MOV  R3, [R4]
	MOV  R4, MEGA_Y
	MOV  R2, [R4]
	CALL objeto_geral              ; desenhar o objeto
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

;-------------------------------------------;
;------- Criação de Objetos Vingança -------;
;-------------------------------------------;
; As seguintes funções tratam da criação dos objetos vingança
spawna_vinganca:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV  R8, 1                    ; tipo do asteroide (1)
	MOV  R0, LARGURA_MEGA         ; largura do objeto inicial
	MOV  R4, RANDOM_NUM
	MOV  R5, [R4]
	CMP  R5, 0
	JZ   nasce_vinganca_ast
	MOV  R8, 0                    ; tipo do ovni (0)
	JMP  nasce_vinganca_ovni

nasce_vinganca_ast:
	MOV  R5, VINGANCA_DIR         ; atribuir um valor aleatório à direção do objeto random
	MOV  R4, RANDOM_DIR
	MOV  R6, [R4]
	MOV  [R5], R6
	MOV  R5, VINGANCA_TIPO        ; se é asteroide atribuir 1 ao tipo
	MOV  R4, 1
	MOV  [R5], R4
	MOV  R1, MEGA_AST_est_grande  ; atribuir a estrutura ao objeto


indeciso_vinganca:                    ; Podem estar até 3 objetos vingança a coexistir
	MOV  R7, VINGANCA_TIPO_1      ; verificar qual é o primeiro disponivel
	MOV  R4, VINGANCA_1_X         ; fazer uma pré atribuição dos valores X e Y
	MOV  R3, [R4]
	MOV  R4, VINGANCA_1_Y
	MOV  R2, [R4]
	MOV  R4, VINGANCA_1_EXISTE    ; ver se o primeiro está disponivel
	MOV  R5, [R4]
	CMP  R5, 0
	JZ   numero_vinganca          ; se tiver disponivel podemos criar um novo objeto
	MOV  R7, VINGANCA_TIPO_2      ; e fazer o mesmo para todos os 3 disponiveis
	MOV  R4, VINGANCA_2_X
	MOV  R3, [R4]
	MOV  R4, VINGANCA_2_Y
	MOV  R2, [R4]
	MOV  R4, VINGANCA_2_EXISTE
	MOV  R5, [R4]
	CMP  R5, 0
	JZ   numero_vinganca
	MOV  R7, VINGANCA_TIPO_3
	MOV  R4, VINGANCA_3_X
	MOV  R3, [R4]
	MOV  R4, VINGANCA_3_Y
	MOV  R2, [R4]
	MOV  R4, VINGANCA_3_EXISTE
	MOV  R5, [R4]
	CMP  R5, 0
	JZ   numero_vinganca
	JMP  fim_vinganca             ; se nenhum tiver disponivel então não criar mais

numero_vinganca:
	MOV  [R7], R8
	MOV  R5, 1
	MOV  [R4], R5
	CALL vinganca                 ; desenha o objeto

fim_vinganca:
	POP  R8
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

nasce_vinganca_ovni:               ; Semelhanta ao vingança asteroide mas com
	MOV  R5, VINGANCA_DIR        ; a estrutura do ovni
	MOV  R4, RANDOM_DIR
	MOV  R6, [R4]
	MOV  [R5], R6
	MOV  R5, VINGANCA_TIPO       ; ovni -> 0
	MOV  R4, 0
	MOV  [R5], R4
	MOV  R1, MEGA_OVNI_est_grande
	JMP  indeciso_vinganca


;-------------------------------------------;
;------- Movimento de Objetos Mega ---------;
;-------------------------------------------;
mega_movimento:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	MOV  R5, MEGA_TIPO
	MOV  R4, [R5]
	CMP  R4, 1                         ; se o mega tipo for 1 é asteroide caso contrario é inimigo
	JZ   mega_ast_mov_geral
	JMP  mega_ovni_mov_geral

mega_ast_mov_geral:
	MOV  R5, MEGA_Y
	MOV  R2, [R5]
	ADD  R2, 1                         ; adicionamos 1 ao mega Y
	MOV  [R5], R2
	CMP  R2, MEGA_MEDIO                ; se o Y for superior a 4 então ainda está longe e desenhamos o médio
	JZ   mega_ast_medio_estruturado
	JMP  mega_ast_grande_estruturado   ; caso contrário desenhamos o grande

mega_ovni_mov_geral:
	MOV  R5, MEGA_Y                    ; semelhante ao movimento do asteroide
	MOV  R2, [R5]                      ; mas com as estruturas de inimigo
	ADD  R2, 1
	MOV  [R5], R2
	CMP  R2, MEGA_MEDIO
	JLE  mega_onvi_medio_estruturado
	JMP  mega_onvi_grande_estruturado

mega_ast_medio_estruturado:                 ; Estruturado -> significa que as informações para se concluir o desenho estão prontas
	MOV  R0, MEGA_MEDIO               ; (largura do objeto medio)
	MOV  R1, MEGA_AST_est_medio       ; Atribuir a estrutura de médio (ainda está longe)
	MOV  R5, MEGA_X                   ; IMPORTANTE: O random direção varia entre 0 e 2
	MOV  R4, MEGA_DIR                 ; então de modo a simplificar substancialmente o código
	MOV  R6, [R4]                     ; podemos subtrair 1 ao numero random (ficaremos com numeros entre -1 e 1
	MOV  R3, [R5]                     ; Somando o numero subtraido ao mega X poderemos:
	SUB  R6, 1                                                   ; Andar para a esquerda - > -1
	ADD  R3, R6                                                  ; Andar para o centro - > 0
	MOV  [R5], R3                                                ; Andar para a direita - > 1
	CALL objeto_geral                 ; Depois já teremos todas as informações para desenhar
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

mega_onvi_medio_estruturado:            ; Análogo à função anterior mas para o inimigo médio
	MOV  R0, MEGA_MEDIO                 ; (largura do mega ovni)
	MOV  R1, MEGA_OVNI_est_medio
	MOV  R5, MEGA_X
	MOV  R4, MEGA_DIR
	MOV  R6, [R4]
	MOV  R3, [R5]
	SUB  R6, 1
	ADD  R3, R6
	MOV  [R5], R3
	CALL objeto_geral
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

mega_ast_grande_estruturado:            ; Análogo ao anterior mas com o asteroide grande
	MOV  R0, LARGURA_VING               ; (largura do objeto grande) == largura do objeto vingança
	MOV  R1, MEGA_AST_est_grande
	MOV  R5, MEGA_X
	MOV  R4, MEGA_DIR
	MOV  R6, [R4]
	MOV  R3, [R5]
	SUB  R6, 1
	ADD  R3, R6
	MOV  [R5], R3
	CALL objeto_geral
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

mega_onvi_grande_estruturado:           ; Análogo ao anterior mas com o inimigo grande
	MOV  R0, LARGURA_VING               ; (largura do mega ovni) == largura do objeto vingança
	MOV  R1, MEGA_OVNI_est_grande
	MOV  R5, MEGA_X
	MOV  R4, MEGA_DIR
	MOV  R6, [R4]
	MOV  R3, [R5]
	SUB  R6, 1
	ADD  R3, R6
	MOV  [R5], R3
	CALL objeto_geral                   ; desenha o ecrã
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

;-------------------------------------------;
;------ Movimento de Objetos Vigança -------;
;-------------------------------------------;
; Correponde a uma interrupção
int_vinganca:
	PUSH R0                     ; R5 -> Atualizar o valor do X caso haja movimento
	PUSH R1                     ; R6 -> Atualizar o valor do Y caso haja movimento
	PUSH R2                     ; R3 -> Valor efetivo do X
	PUSH R3                     ; R2 -> Valor efetivo do Y
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	MOV  R7, VOID                 ; R7 <-> Se o Y do objeto for igual ou maior que este então deixará de existir
	MOV  R0, APAGAR_ECRA
	MOV  R1, ECRA_VINGANCA
	MOV  [R0], R1

	MOV  R5, VINGANCA_1_X
	MOV  R3, [R5]
	MOV  R6, VINGANCA_1_Y
	MOV  R2, [R6]
	CALL v_mov_1
	MOV  R5, VINGANCA_2_X
	MOV  R3, [R5]
	MOV  R6, VINGANCA_2_Y
	MOV  R2, [R6]
	CALL v_mov_2
	MOV  R5, VINGANCA_3_X
	MOV  R3, [R5]
	MOV  R6, VINGANCA_3_Y
	MOV  R2, [R6]
	CALL v_mov_3

	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE


v_mov_1:
	MOV  R0, VINGANCA_1_EXISTE     ; O objeto da vingança 1 existe?
	MOV  R1, [R0]
	CMP  R1, 0
	JZ   v_terminos                ; Se não existir não vale a pena continuar
	MOV  R4, VINGANCA_1_EXISTE     ; Se existir mas estiver fora do ecrã vamos elimina-lo
	MOV  R0, C_EXI_V_1
	MOV  R1, [R0]                  ; Se estiver fora do ecrã
	CMP  R1, R7
	JZ   v_eliminar                ; Eliminar
	ADD  R1, 1                     ; Caso contrario, atualizar a variavel de controlador  para +1
	MOV  [R0], R1
	MOV  R0, VINGANCA_TIPO_1       ; Ver o tipo do objeto vingança que já estava guardado anteriormente
	MOV  R1, [R0]
	CMP  R1, 1                     ; Se for asteroide
	JZ   v_geral_ast
	MOV  R1,MEGA_OVNI_est_grande   ; Para poupar imenso código, mudar aqui o valor da estrutura (os outros objetos deveriam seguir o mesmo principio)
	JMP  v_geral_inimigo           ; Se for inimigo

v_mov_2:
	MOV  R0, VINGANCA_2_EXISTE
	MOV  R1, [R0]                  ; Processo análogo ao v_mov_1
	CMP  R1, 0
	JZ   v_terminos
	MOV  R4, VINGANCA_2_EXISTE
	MOV  R0, C_EXI_V_2
	MOV  R1, [R0]
	CMP  R1, R7
	JZ   v_eliminar
	ADD  R1, 1
	MOV  [R0], R1
	MOV  R0, VINGANCA_TIPO_2
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   v_geral_ast
	MOV  R1,MEGA_OVNI_est_grande
	JMP  v_geral_inimigo

v_mov_3:
	MOV  R0, VINGANCA_2_EXISTE
	MOV  R1, [R0]                  ; Processo análogo ao v_mov_1
	CMP  R1, 0
	JZ   v_terminos
	MOV  R4, VINGANCA_1_EXISTE
	MOV  R0, C_EXI_V_3
	MOV  R1, [R0]
	CMP  R1, R7
	JZ   v_eliminar
	ADD  R1, 1
	MOV  [R0], R1
	MOV  R0, VINGANCA_TIPO_2
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   v_geral_ast
	MOV  R1,MEGA_OVNI_est_grande
	JMP  v_geral_inimigo



; Vingança Geral
v_geral_ast:
	MOV R1,MEGA_AST_est_grande                 ; Depois de obtidas as informações necessárias
v_geral_inimigo:
	MOV  R0, LARGURA_VING   ; (largura do objeto grande)
	MOV  R4, [R6]
	ADD  R4, 1
	MOV  [R6], R4
	MOV  R4, VINGANCA_DIR                        ; De modo a fazer com que todos os objetos vingança tenham as mesmas direções
	MOV  R6, [R4]                                ; e, irem atualizando as direções ao longo do aparecimento de mais
	MOV  R3, [R5]                                ; objetos vingança, basta generalizar o movimento de um com o do ultimo a surgir
	SUB  R6, 1
	ADD  R3, R6                                  ; Ou seja, quando apareçe um novo objeto vingança, a direção dos outros sofre alterações
	MOV  [R5], R3
	CALL vinganca                              ; Desenhar
v_terminos:
	RET

v_eliminar:
	MOV  R1, 0                ; Quando apagamos os objetos vingança devemos:
	MOV  [R0], R1                                   ; 1 -> Atualizar a sua existencia para 0 (não existem mais)
	MOV  [R4], R1                                   ; 2 -> Reiniciar as suas coordenadas para os valores iniciais
	MOV  R1, RESET_X_VING
	MOV  [R5], R1
	MOV  R1, -RESET_Y_VING
	MOV  [R6], R1
	RET

reiniciar_ving:               ; Semelhante ao v_eliminar mas reinica todas as vinganças e não
	PUSH R0                ; apenas 1
	PUSH R1
	PUSH R2
	PUSH R3
	MOV  R0, RESET_X_VING
	MOV  R1, VINGANCA_1_X
	MOV  [R1], R0
	MOV  R1, VINGANCA_2_X
	MOV  [R1], R0
	MOV  R1, VINGANCA_3_X
	MOV  [R1], R0
	MOV  R0, -RESET_Y_VING
	MOV  R1, VINGANCA_1_Y
	MOV  [R1], R0
	MOV  R1, VINGANCA_2_Y
	MOV  [R1], R0
	MOV  R1, VINGANCA_3_Y
	MOV  [R1], R0
	MOV  R0, 0
	MOV  R1, VINGANCA_1_EXISTE
	MOV  [R1], R0
	MOV  R1, VINGANCA_2_EXISTE
	MOV  [R1], R0
	MOV  R1, VINGANCA_3_EXISTE
	MOV  [R1], R0
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET



; MÍSSIL INTERRUPÇÃO
int_missil:
	PUSH R0
	PUSH R1
	MOV  R0, MISSIL_EXISTE     ; O missil existe?
	MOV  R1, [R0]
	CMP  R1, 1
	JNZ  pre_loop              ; se não existir, então não vale a pena mexer o missil
	POP  R1
	POP  R0
	JMP  mexe_missil           ; se existir então vamos mexer o missil
pre_loop:
	POP  R1
	POP  R0
	RFE
; se existir missil , mexer o missil
mexe_missil:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	MOV  R5, DESTROI_MISSIL
	MOV  R6, [R5]
	ADD  R6, 1
	MOV  [R5], R6
	MOV  R5, COMPARAR_MISSIL
	CMP  R6, R5
	JZ   destruir_missil
	MOV  R0, ECRA_MISSIL
	MOV  R1, SEL_ECRA
	MOV  [R1], R0
	MOV  R0, ECRA_MISSIL
	MOV  R1, APAGAR_ECRA
	MOV  [R1], R0
	MOV  R0, MISSIL_X
	MOV  R3, [R0]
	MOV  R0, MISSIL_Y
	MOV  R1, [R0]
	SUB  R1, 1
	MOV  [R0], R1
	MOV  R4, LINHA_NAVE
	ADD  R1, R4
	MOV  R2, R1
	CALL missil                ; Desenhar o missil
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE

; Quando o contador para destruir o missil estiver ativo o missisl é eliminado
destruir_missil:
	MOV  R5, MISSIL_X           ; Quando se destroi o missil é importante
	MOV  R6, EXPULSAR_MISSIL2    ; apagar os valores do missil_x e missil_y
	MOV  [R5], R6               ; de modo a que não se provoquem colisões inexistentes
	MOV  R5, MISSIL_Y           ; (apagar => envia-los para uma coordenada onde essa colisão nunca seja possivel)
	MOV  [R5], R6
	MOV  R5, DESTROI_MISSIL
	MOV  R6, 0
	MOV  [R5], R6
	MOV  R1, MISSIL_EXISTE
	MOV  R2, 0
	MOV  [R1], R2
	MOV  R0, ECRA_MISSIL
	MOV  R1, SEL_ECRA
	MOV  [R1], R0
	MOV  R0, ECRA_MISSIL
	MOV  R1, APAGAR_ECRA
	MOV  [R1], R0
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE

;------------------ comeca_jogo ------------------;
; Rotina correspondente à tecla C                 ;
; Recomeça o jogo                                 ;
; Funciona de modo "descontínuo"                  ;
;-------------------------------------------------;
comeca_jogo:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    CALL reiniciar_objetos
	CALL reiniciar_ving
    CALL apaga_cenarios
    CALL init_energia
	CALL init_missil
	CALL init_nave
	CALL spawna_objetos
    MOV  R1, BG_FUNDO
    CALL mudar_background
    MOV  R1, SOM_FUNDO
    CALL play_som
espera_c:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 0               ; enquanto a tecla estiver premida,
    JNZ  espera_c            ; permanece-se neste ciclo de modo a não executar de modo "contínuo"
    PUSH R3
    PUSH R2
    PUSH R1
    PUSH R0
    JMP  loop                ; quando a tecla deixa de ser premida, volta-se ao ciclo principal


;------------------- pausa_jogo ------------------;
; Rotina correspondente à tecla F                 ;
; Suspende/Continua o jogo                        ;
; Funciona de modo "descontínuo"                  ;
;-------------------------------------------------;
pausa_jogo:
	PUSH R0
	PUSH R1
	PUSH R2
    DI                       ; pausa interrupções para manter o PEPE nesta rotina
    MOV  R1, BG_PAUSA        ; background de pausa
    CALL mudar_background_f
    MOV  R1, SOM_FUNDO
    CALL pause_som           ; pausar som de fundo
    MOV  R1, SOM_PAUSA
    CALL play_som            ; tocar som de pausa
espera_d:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 0               ; espera-se que não haja tecla premida
    JNZ  espera_d
espera_tecla:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 1
    JNZ  espera_tecla
    CALL teclado
    MOV  R0, TEC_TECLA
    MOV  R1, [R0]
    MOV  R2, TECLA_PAUSA
    CMP  R1, R2              ; espera-se que a tecla primida seja tecla de pausa
    JNZ  espera_tecla
unpausa_jogo:                ; depois, retoma-se o jogo
    EI                       ; volta a ativar as interrupções
    MOV  R1, BG_PAUSA
    CALL apagar_background_f
    MOV  R1, SOM_FUNDO
    CALL unpause_som
    POP  R2
    POP  R1
    POP  R0
    JMP  depois_pausa

;----------------- termina_jogo ------------------;
; Rotina correspondente à tecla E                 ;
; Termina o jogo                                  ;
; Funciona de modo "descontínuo"                  ;
;-------------------------------------------------;
termina_jogo:
	PUSH R0
    PUSH R1
    PUSH R2
    DI                       ; pausa interrupções para manter o PEPE nesta rotina
    CALL apaga_cenarios      ; apaga todos os cenários
    MOV  R1, BG_FIM_JOGO
    CALL mudar_background    ; background de fim de jogo
    CALL stop_som            ; para todos os sons
    MOV  R1, SOM_FIM_JOGO
    CALL play_som            ; som de fim de jogo
espera_terminar:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 0               ; espera-se que a tecla seja largada
    JNZ  espera_terminar
espera_tecla_t:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 1               ; espera-se que uma tecla seja primida
    JNZ  espera_tecla_t
    CALL teclado
    MOV  R0, TEC_TECLA
    MOV  R1, [R0]
    MOV  R2, TECLA_COMECO    ; espera-se que a tecla primida seja a de começo
    CMP  R1, R2
    JNZ  espera_tecla_t
recomeca_jogo:               ; se a tecla primida for a correta, recomeça-se o jogo
    POP  R2
    POP  R1
    POP  R0
    JMP  comecar

;------------- sem_energia/game_over -------------;
; Rotina que atua quando a energia chega a 0 ou   ;
; se a nave colidir com uma nave inimiga          ;
;-------------------------------------------------;
sem_energia:
    PUSH R0
    PUSH R1
    PUSH R2
    DI                       ; para todas as interrupções
    CALL apaga_cenarios      ; apaga todos os cenários
    MOV  R1, BG_SEM_ENERG
    CALL mudar_background    ; fundo de "sem energia"
    JMP  espera_game_over
game_over:
    PUSH R0
    PUSH R1
    PUSH R2
    DI
    CALL apaga_cenarios
    MOV  R1, BG_COLISAO
    CALL mudar_background    ; fundo de colisão
    CALL stop_som            ; para todos os sons
    MOV  R1, SOM_COLISAO
    CALL play_som            ; som de colisão
espera_game_over:
    CALL teclado_estado
    MOV  R0, TEC_PRIM
    MOV  R1, [R0]
    CMP  R1, 1               ; espera-se que a tecla deixe de ser premida
    JNZ  espera_game_over
    CALL teclado
    MOV  R0, TEC_TECLA
    MOV  R1, [R0]
    MOV  R2, TECLA_COMECO
    CMP  R2, R1              ; espera-se que a tecla de começo seja premida outra vez
    JNZ  espera_game_over
    EI
    POP  R2
    POP  R1
    POP  R0
    JMP  comeca_jogo


;-------------------------------------------;
;---------------- Colisões -----------------;
;-------------------------------------------;
; Verifica se houve alguma colisão
colisoes_geral:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	CALL colisoes_obj_1
	CALL colisoes_obj_2
	CALL colisoes_obj_3
	CALL colisoes_mega_obj
	CALL colisoes_vinganca_1
	CALL colisoes_vinganca_2
	CALL colisoes_vinganca_3
	CALL colisao_missil_obj
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET


colisoes_obj_1:
	MOV  R6, OBJ_1_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, OBJ_1_Y     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R1, NAVE_X_EFETIVA
	MOV  R2, [R1]
	MOV  R1, NAVE_Y_EFETIVA
	MOV  R3, [R1]
	MOV  R4, OBJ_1_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, OBJ_1_Y
	MOV  R1, [R5]
	MOV  R5, R1
	MOV  R0, Obj_1_tipo
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   colisao_asteroide_nave
	JMP  colisao_ovni_nave

colisoes_obj_2:
	MOV  R6, OBJ_2_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, OBJ_2_Y     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R1, NAVE_X_EFETIVA
	MOV  R2, [R1]
	MOV  R1, NAVE_Y_EFETIVA
	MOV  R3, [R1]
	MOV  R4, OBJ_2_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, OBJ_2_Y
	MOV  R1, [R5]
	MOV  R5, R1
	MOV  R0, Obj_2_tipo
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   colisao_asteroide_nave
	JMP  colisao_ovni_nave

colisoes_obj_3:
	MOV  R6, OBJ_3_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, OBJ_3_Y     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R1, NAVE_X_EFETIVA
	MOV  R2, [R1]
	MOV  R1, NAVE_Y_EFETIVA
	MOV  R3, [R1]
	MOV  R4, OBJ_3_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, OBJ_3_Y
	MOV  R1, [R5]
	MOV  R5, R1
	MOV  R0, Obj_3_tipo
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   colisao_asteroide_nave
	JMP  colisao_ovni_nave


colisoes_mega_obj:
	MOV  R6, MEGA_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, MEGA_Y    ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R1, NAVE_X_EFETIVA
	MOV  R2, [R1]
	MOV  R1, NAVE_Y_EFETIVA
	MOV  R3, [R1]
	MOV  R4, MEGA_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, MEGA_Y
	MOV  R1, [R5]
	MOV  R5, R1
	MOV  R0, MEGA_TIPO
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   colisao_asteroide_nave
	JMP  colisao_ovni_nave


colisao_asteroide_nave:
	ADD  R4, LEITOR_OBJ          ;comparar com a boundry esquerda
	CMP  R4, R2
	JLT  nao_ha_colisao
	SUB  R4, LEITOR_OBJ          ;comparar com a boundry direita
	ADD  R2, LEITOR_OBJ
	CMP  R2, R4
	JLT  nao_ha_colisao
	ADD  R5, LEITOR_OBJ
	CMP  R5, R3
	JLT  nao_ha_colisao
	SUB  R5, LEITOR_OBJ
	ADD  R3, LEITOR_OBJ
	CMP  R3, R5
	JLT  nao_ha_colisao
	JMP  ha_colisao_asteroide

colisao_ovni_nave:
	ADD  R4, LEITOR_OBJ          ;comparar com a boundry esquerda
	CMP  R4, R2
	JLT  nao_ha_colisao
	SUB  R4, LEITOR_OBJ          ;comparar com a boundry direita
	ADD  R2, LEITOR_OBJ
	CMP  R2, R4
	JLT  nao_ha_colisao
	ADD  R5, LEITOR_OBJ
	CMP  R5, R3
	JLT  nao_ha_colisao
	SUB  R5, LEITOR_OBJ
	ADD  R3, LEITOR_OBJ
	CMP  R3, R5
	JLT  nao_ha_colisao
	JMP  ha_colisao_ovni


colisao_missil_obj:
	MOV  R6, OBJ_1_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, OBJ_1_Y     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R4, OBJ_1_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, OBJ_1_Y
	MOV  R1, [R5]
	MOV  R5, R1

	MOV  R1, MISSIL_X
	MOV  R2, [R1]
	MOV  R6, LINHA_NAVE
	MOV  R1, MISSIL_Y
	MOV  R3, [R1]
	ADD  R3, R6      ;O missil_y está definido em funcao da linha da nave (ver código anterior caso precise de confirmar)
	CALL colisao_missil_qualquer ;ve se o obj 1 colidiu com missil

	MOV  R6, OBJ_2_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, OBJ_2_Y     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R4, OBJ_2_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, OBJ_2_Y
	MOV  R1, [R5]
	MOV  R5, R1
	CALL colisao_missil_qualquer ;ve se o obj 1 colidiu com missil
	MOV  R6, OBJ_3_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, OBJ_3_Y     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R4, OBJ_3_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, OBJ_3_Y
	MOV  R1, [R5]
	MOV  R5, R1
	CALL colisao_missil_qualquer
	RET

colisao_missil_qualquer:
	ADD  R4, LEITOR_OBJ               ; comparar com a boundry esquerda
	CMP  R4, R2
	JLT  nao_ha_colisao
	SUB  R4, LEITOR_OBJ               ; comparar com a boundry direita
	ADD  R2, LEITOR_MISSIL
	CMP  R2, R4
	JLT  nao_ha_colisao
	ADD  R5, LEITOR_OBJ
	CMP  R5, R3
	JLT  nao_ha_colisao
	SUB  R5, LEITOR_OBJ
	ADD  R3, LEITOR_MISSIL
	CMP  R3, R5
	JLT  nao_ha_colisao
	JMP  ha_colisao_asteroide_missil     ; a função ha colisao asteroide ira alterar as coordenadas do
		                                 ; objeto que colidiu com o missil (reaproveitamento de funcoes)

nao_ha_colisao:
		RET

ha_colisao_asteroide:
	MOV  R0, EXPULSAR_OBJ   ; remover do ecrã
	MOV  [R6], R0           ; MUDAR COORDENADAS X DO ASTEROIDE
	PUSH R1
    PUSH R2
    MOV  R2, ENERGIA_GAMA   ; energia a ganhar
	CALL energia            ; aumenta a energia
    MOV  R1, SOM_ENERGIA
    CALL play_som           ; som de ganhar energia
	POP  R2
    POP  R1
	RET

ha_colisao_asteroide_missil:
	CALL spawna_vinganca
	MOV  R1, SOM_NAVE_EXP
	CALL play_som
	MOV  R4, LINHA_NAVE
	MOV  R1, MISSIL_X
	MOV  R3, [R1]
	MOV  R1, MISSIL_Y
	MOV  R2, [R1]
	ADD  R2, R4
	MOV  R0, LARGURA_EXPLOSAO
	MOV  R1, explosao_est
	CALL objeto_geral_aux
	MOV  R5, MISSIL_X
	MOV  R4, EXPULSAR_OBJ
	MOV  [R5], R4
	MOV  R5, MISSIL_Y
	MOV  [R5], R4
	MOV  R0, EXPULSAR_MISSIL  ; remover do ecrã
	MOV  [R6], R0             ; MUDAR COORDENADAS X DO ASTEROIDE
	MOV  [R7], R0             ; MUDAR COORDENADAS Y DO ASTEROIDE
	RET

ha_colisao_ovni:
	JMP game_over

; APOIOS PARA JZ (deviamos ter utilizado call mas como já tinhamos construido estas funcoes com jmp era complidado estar a refazer as anteriores)
vinganca_col_ast_nave:  JMP colisao_asteroide_nave
vinganca_col_ovni_nave: JMP colisao_ovni_nave


; COLISOES VINGANCA
colisoes_vinganca_1:
	MOV  R6, VINGANCA_1_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, VINGANCA_1_Y    ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R1, NAVE_X_EFETIVA
	MOV  R2, [R1]
	MOV  R1, NAVE_Y_EFETIVA
	MOV  R3, [R1]
	MOV  R4, VINGANCA_1_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, VINGANCA_1_Y
	MOV  R1, [R5]
	MOV  R5, R1
	MOV  R0, VINGANCA_TIPO_1
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   vinganca_col_ast_nave
	JMP  vinganca_col_ovni_nave

colisoes_vinganca_2:
	MOV  R6, VINGANCA_2_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, VINGANCA_2_Y    ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R1, NAVE_X_EFETIVA
	MOV  R2, [R1]
	MOV  R1, NAVE_Y_EFETIVA
	MOV  R3, [R1]
	MOV  R4, VINGANCA_2_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, VINGANCA_2_Y
	MOV  R1, [R5]
	MOV  R5, R1
	MOV  R0, VINGANCA_TIPO_2
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   vinganca_col_ast_nave
	JMP  vinganca_col_ovni_nave

colisoes_vinganca_3:
	MOV  R6, VINGANCA_3_X     ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R7, VINGANCA_3_Y    ;CASO HAJA UMA COLISÃO, estas coordenadas sofrem alterações
	MOV  R1, NAVE_X_EFETIVA
	MOV  R2, [R1]
	MOV  R1, NAVE_Y_EFETIVA
	MOV  R3, [R1]
	MOV  R4, VINGANCA_3_X
	MOV  R1, [R4]
	MOV  R4, R1
	MOV  R5, VINGANCA_3_Y
	MOV  R1, [R5]
	MOV  R5, R1
	MOV  R0, VINGANCA_TIPO_3
	MOV  R1, [R0]
	CMP  R1, 1
	JZ   vinganca_col_ast_nave
	JMP  vinganca_col_ovni_nave
