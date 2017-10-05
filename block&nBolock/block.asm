# Código não blocado
#for(i = 0; i < BLK; i++){
#   for(i = 0; i<   n, i++){
#    for(j = 0; jk < (jk+BLK); j++){
#      A[i][j] = B[j][i];
#    }
#  }
#}

.eqv LINHAS 128
.eqv COLUNAS 128
.eqv MATRIZ 16384
.eqv DATA 65536 
.eqv BLOCK 4

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
add $t4, $zero, 0 # inicializa jk com 0
add $t5, $t4, BLOCK # temporária jk+ BLK

forj:
#calculo endereço origem
mul $t2, $t0, COLUNAS
add $t2, $t2, $t1
mul $t2, $t2, 4
lw  $t3, origem($t2)

#calculo endereço des
mul $t2, $t1, LINHAS
add $t2, $t2, $t0
mul $t2, $t2, 4
sw  $t3, destino($t2)

#atualiza J
add $t1, $t1, 1  
beq $t1, $t5, incrementai
j forj

#atualiza I
incrementai:
add $t1, $zero, 0 
add $t0, $t0, 1 
beq $t0, LINHAS, incrementajk
j forj

incrementajk:
add $t0, $zero, 0
add $t4, $t4, BLOCK
add $t5, $t4, BLOCK
add $t1, $zero, $t4
beq $t4, LINHAS, saida
j forj


#Condição para finalizar
saida:
add $zero, $zero, 0
