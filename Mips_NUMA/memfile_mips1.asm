  addi $t1, $zero, 1
  addi $s1, $zero, 0x25C
  addi $t3, $zero, 0x7fff
  addi $t6, $zero, 1
  addi $t7, $zero, 32

main:
delay:
  addi $t3, $t3, -1 
  bne  $t3, $zero, delay
  addi $t3, $zero, 0x7fff
  addi $t3, $t3, 0x7fff
  
  addi $s0, $zero, 0x204
  addi $t1, $zero, 2
  bne  $t6, $t7, mult_frame
  addi $t6, $zero, 1
  addi $t1, $zero, 1
  j zera
   
mult_frame:
  lw   $t0, 0($s0)
  lw   $t4, 96($s0)
  lw   $t5, 192($s0)

  xor $t0,$t0,$t1	#ROR
  xor $t4,$t4,$t1	#ROR
  xor $t5,$t5,$t1	#ROR
  
  sw   $t0, 0($s0)
  #sw   $t4, 96($s0)
  #sw   $t5, 192($s0)
  
  addi $s0, $s0, 4
  bne  $s0, $s1, mult_frame
  addi $t6, $t6, 1
j main
  
zera:
  lw   $t0, 0($s0)
  lw   $t4, 96($s0)
  lw   $t5, 192($s0)

  srlv $t0,$t0,$t1	#ROL
  srlv $t4,$t4,$t1	#ROL
  srlv $t5,$t5,$t1	#ROL
  
  sw   $t0, 0($s0)
  sw   $t4, 96($s0)
  sw   $t5, 192($s0)
  
  addi $s0, $s0, 4
  beq  $s0, $s1, main
j zera
  
#  sllv $t0,$t0,$t1	#ROR
#  sllv $t4,$t4,$t1	#ROR
#  sllv $t5,$t5,$t1	#ROR

#  srlv $t0,$t0,$t1	#ROL
#  srlv $t4,$t4,$t1	#ROL
#  srlv $t5,$t5,$t1	#ROL

#  nor $t0,$t0,$t1	#MUL
#  nor $t4,$t4,$t1	#MUL
#  nor $t5,$t5,$t1	#MUL
