# Codigo em C:
# int x[10] = {13, 22, 93, 84, 15, 36, 7, 18, 91, 10};
# int y[10] = {31, 22, 39, 48, 51, 63, 70, 81, 19, 1};
# int i, sum = 0;
# for (i=1; i<N; i++) 
#   sum += x[i] * y[i]
# printf("sum=%i\n", sum); // 13*31+22*22+93*39+84*48+15*51+36*63+7*70+18*81+19*91+10*1 = 15266

.data

x: .word 13, 22, 93, 84, 15, 36, 7, 18, 91, 10
y: .word 31, 22, 39, 48, 51, 63, 70, 81, 19, 1

.text
	la $s0, x	#carrega vetor x em $s0
	la $s1, y 	#carrega vetor y em $1
	li $t0, 0	# inicializa i com 0
	li $t1, 0	# inicializa sum com 0
	li $t4, 10	# inicializa N como 10 para condição de parada
	
loop:
	sll $t2, $t0, 2		# multilica i por 4
	add $t5, $t2, $s0	# calcula posição vetor x
	lw $t5, 0($t5)		# carrega posição vetor x
	#sll $t3, $t0, 2	# multilica i por 4
	add $t3, $t2, $s1	# calcula posição vetor y
	lw $t3, 0($t3)		# carrega posição vetor y
	mul $t3, $t3, $t5	# multiplica valortes carregados dos vetores
	add $t1, $t1, $t3 	# adiciona o valor da multiplicação $t1
	addi $t0, $t0, 1	# incremento de $t0 (i)
	addi $t4, $t4, -1	# decremento de $t4
	bgtz $t4, loop		# Executa enquanto é menor que zero
	
	# Imoprime resultado
	move $a0, $t1 	# carrega resultado aculuda em $a0 para impressão
	li $v0, 1	# chamada para imprimir inteiro
	syscall	
	li $v0, 10	# chamada para exitt()
	syscall		
	
	
	
	
	
	
