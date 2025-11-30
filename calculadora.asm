# Atividade: Calculadora Programador Didatica em MIPS
# Autor:       Gabriel Miranda Mucarbel de Lima
# Email:       gmml@cesar.school
# Git Repo:    https://github.com/GMiranda21ML/calculadora-ASM
# Data Inicio: 30/11/2025
# Historico de Revisoes:
# 30/11/2025 - 16:15 - Criacao da estrutura, menu principal e conversao Binaria.
# 30/11/2025 - 17:23 - Adicao das conversoes Octal (Base 8) e Hexadecimal (Base 16).

.data
    menu_msg:       .asciiz "\n\n--- CALCULADORA DIDATICA MIPS ---\n1 - Base 10 para Base 2\n2 - Base 10 para Base 8\n3 - Base 10 para Base 16\n4 - Base 10 para BCD\n5 - Base 10 para Compl. de 2 (16 bits)\n6 - Real para Float/Double\n0 - Sair\nEscolha uma opcao: "
    input_msg:      .asciiz "\nDigite o valor em Decimal (Inteiro): "
    step_msg:       .asciiz "\n[Passo] "
    div_msg:        .asciiz " / 2 = "
    rem_msg:        .asciiz " [Resto: "
    close_bracket:  .asciiz "]"
    final_res_msg:  .asciiz "\nResultado Final (Binario): "
    bye_msg:        .asciiz "\nEncerrando o programa..."
    error_msg:      .asciiz "\nOpcao invalida!\n"

.text
.globl main

main:
while_menu:
li $v0, 4
la $a0, menu_msg
syscall

li $v0, 5
syscall
move $t0, $v0         

beq $t0, 0, exit_prog
beq $t0, 1, call_binario
beq $t0, 1, call_binario
beq $t0, 2, call_octal
beq $t0, 3, call_hex
        
li $v0, 4
la $a0, error_msg
syscall
j while_menu

# FUNCIONALIDADE 1B: DECIMAL PARA BINARIO (BASE 2)
call_binario:
    li $v0, 4
    la $a0, input_msg
    syscall

    li $v0, 5
    syscall
    move $s0, $v0           
    
    move $t1, $s0  
    li $t2, 2 
    li $t3, 0           
loop_div_bin:
    li $v0, 4
    la $a0, step_msg
    syscall
    
    li $v0, 1
    move $a0, $t1         
    syscall

    div $t1, $t2    
    mflo $t4       
    mfhi $t5      

    li $v0, 4
    la $a0, div_msg
    syscall

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, rem_msg
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, close_bracket
    syscall

    sub $sp, $sp, 4     
    sw $t5, 0($sp)    
    addi $t3, $t3, 1  

    move $t1, $t4

    bgt $t1, 0, loop_div_bin

    li $v0, 4
    la $a0, final_res_msg
    syscall

print_stack_bin:
    blez $t3, end_binario

    lw $a0, 0($sp) 
    add $sp, $sp, 4 
    
    li $v0, 1
    syscall

    sub $t3, $t3, 1       
    j print_stack_bin

end_binario:
    j while_menu           
    
# FUNCIONALIDADE 1B: DECIMAL PARA OCTAL (BASE 8)
call_octal:
    li $v0, 4
    la $a0, input_msg
    syscall

    li $v0, 5
    syscall
    move $s0, $v0 

    move $t1, $s0  
    li $t2, 8  
    li $t3, 0            

loop_div_octal:
    li $v0, 4
    la $a0, step_msg
    syscall
    
    li $v0, 1
    move $a0, $t1
    syscall

    div $t1, $t2            
    mflo $t4        
    mfhi $t5           

    li $v0, 4
    la $a0, div_msg
    
    li $v0, 4
    la $a0, rem_msg
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, close_bracket
    syscall

    sub $sp, $sp, 4
    sw $t5, 0($sp)
    addi $t3, $t3, 1

    move $t1, $t4
    bgt $t1, 0, loop_div_octal

    li $v0, 4
    la $a0, final_res_msg
    syscall

print_stack_octal:
    blez $t3, end_convert
    lw $a0, 0($sp)
    add $sp, $sp, 4
    li $v0, 1
    syscall
    sub $t3, $t3, 1
    j print_stack_octal

# FUNCIONALIDADE 1C: DECIMAL PARA HEXADECIMAL (BASE 16)
call_hex:
    li $v0, 4
    la $a0, input_msg
    syscall

    li $v0, 5
    syscall
    move $s0, $v0

    move $t1, $s0
    li $t2, 16            
    li $t3, 0

loop_div_hex:
    li $v0, 4
    la $a0, step_msg
    syscall
    
    li $v0, 1
    move $a0, $t1
    syscall

    div $t1, $t2
    mflo $t4
    mfhi $t5       

    li $v0, 4
    la $a0, rem_msg
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, close_bracket
    syscall

    sub $sp, $sp, 4
    sw $t5, 0($sp)
    addi $t3, $t3, 1

    move $t1, $t4
    bgt $t1, 0, loop_div_hex

    li $v0, 4
    la $a0, final_res_msg
    syscall

print_stack_hex:
    blez $t3, end_convert
    lw $t5, 0($sp)        
    add $sp, $sp, 4
    
    blt $t5, 10, print_hex_num
    
    addi $a0, $t5, 55  
    li $v0, 11   
    syscall
    j decr_count_hex

print_hex_num:
    move $a0, $t5
    li $v0, 1
    syscall

decr_count_hex:
    sub $t3, $t3, 1
    j print_stack_hex

end_convert:
    j while_menu


exit_prog:
    li $v0, 4
    la $a0, bye_msg
    syscall
    
    li $v0, 10            
    syscall