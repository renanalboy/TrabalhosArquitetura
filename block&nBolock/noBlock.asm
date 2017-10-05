# Código não blocado
#for(i = 0; i < n; i++){
#  for(j = 0; j < n; j++){
#    A[i][j] = B[j][i];
#  }
#}

.eqv LINHAS 128
.eqv COLUNAS 128
.eqv MATRIZ 16384 #SIZE_MATRIZ (NUM_LINES * NUM_COLS)
.eqv DATA 65536 #SIZE_MATRIZ * tamanho do tipo do dado

 .data
origem: .word 0 : MATRIZ
destino: .word 0 : MATRIZ

.text
.globl main

main:
add $t0, $zero, 0 # inicializa i com 0
add $t1, $zero, 0 # inicializa i com 0
add $t2, $zero, 0 # temporário para armazenar o endereço da matriz
add $t3, $zero, 0 # temporário para armazenar dado
forj:
#calculo endereço origem na matriz origem
mul $t2, $t0, COLUNAS
add $t2, $t2, $t1
mul $t2, $t2, 4
lw  $t3, origem($t2)
#calculo endereço na matriz destino
mul $t2, $t1, LINHAS
add $t2, $t2, $t0
mul $t2, $t2, 4
sw  $t3, destino($t2)
#atualiza J
add $t1, $t1, 1  
beq $t1, COLUNAS, incrementai
j forj
#atualiza I
incrementai:
add $t1, $zero, 0 
add $t0, $t0, 1 
beq $t0, LINHAS, saida
j forj
#termina
saida:
add $zero, $zero, 0
