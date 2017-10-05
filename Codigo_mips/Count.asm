# Codigo em C:
# int bar = 18;
# int foo[] = {13, 22, 93, 18, 15, 36, 7, 18, 91, 10};
# int foobar = 0;
# for (int i=0; i<10; i++)
#   if (bar == foo[i])
#     foobar++; 

.data

bar: .word 18
foo: .word 13, 22, 93, 18, 15, 36, 7, 18, 91, 10
foobar: .word 

.text
	#la $s0, 18	# carrega valor inicial de bar	
	la $s0, bar	# carrega valor inicial de bar	
	la $s1, foo 	# carrega vetor foo em $s1
	li $t2, 0 	# inicializa acumulador foobar 	
	li $t0, 0 	# inicializa int i=0
	li $t1, 10	# atribui 10 a i, como valor de parada do for
	
loop:
	sll $t3, $t0, 2		# multiplica i por 4
	add $t3, $t3, $s1	# calcula endereço no vetor foo
	lw $t3, 0($t3)		# carrega a posição do vetor
	lw $t4, 0($s0)		# carrega bar
	bne $t4, $t3, salto	# verifica se o conteudo de vetor é igual a 18(arqmazenado em $s0)
	addi $t2, $t2, 1	# incrementa acumulador acumulador, caso if seja verdadeiro
salto:	addi $t0, $t0, 1	# incrementa i
	addi $t1, $t1, -1	# decrementa contado de repetição
	bgtz $t1, loop		# olta ao loop enquuanto contador maior que 0
	
	# Mostra resultados
	move $a0, $t2 	# carrega resultado aculuda em $a0 para impressão
	li $v0, 1	# chamada para imprimir inteiro
	syscall	
	li $v0, 10	# chamada para exitt()
	syscall	
	

		
