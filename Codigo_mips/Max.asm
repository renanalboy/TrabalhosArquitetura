# Codigo em C:
# int vetor[10] = {13, 22, 93, 84, 15, 36, 7, 18, 91, 10};
# int i, t1 = vetor[0];
# for (i=1; i<N; i++) 
#   if (vetor[i]>t1)
#     t1 = vetor[i];
# printf("t1=%i\n", t1);

.data

vetor: .word 13, 22, 93, 84, 15, 36, 7, 18, 91, 10

.text

	la $s0, vetor	# carrega vetor
	li $t0, 0	# inicializa i com 0
	li $t1, 10	# inicializa n�mero de repeti��es
	
	#Inicializa��io do primeiro elemento para compara��o
	sll $t2, $t0, 2		# multiplica por 4
	add $t2, $t2, $s0	# calcula endere�o do vetor, primeiro elemento para compara��o
	lw $t2, 0($t2)		# carrega posi��o do vetor

loop:	
	sll $t3, $t0, 2		# multiplica por 4
	add $t3, $t3, $s0	# calcula segundo elemento para compara��o
	lw $t3, 0($t3)		# carrega segundo elemento para compara��o
	
	slt $t4, $t3, $t2
	bgtz $t4, inc		# caso n�o seja maior, pula para o 
	add $t2, $t3, 0		# realiza a substitui��o para armazenar o maior	
	
inc:	addi $t0, $t0, 1	# incrmento de i
	addi $t1, $t1, -1	# decremento para condi��od e parada
	bgtz $t1, loop		# enqdo maior que 0 executa loop 
	
	# Mostra resultados
	move $a0, $t2 	# carrega resultado aculuda em $a0 para impress�o
	li $v0, 1	# chamada para imprimir inteiro
	syscall	
	li $v0, 10	# chamada para exitt()
	syscall	
