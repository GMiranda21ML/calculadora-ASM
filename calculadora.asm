# -----------------------------------------------------------------------------
# # Atividade: Calculadora Programador Didatica em MIPS
#
# Autor:       Gabriel Miranda Mucarbel de Lima
# Email:       gmml@cesar.school
# Git Repo:    
# Data Inicio: 30/11/2025
#
# Historico de Revisoes:
# 30/11/2025 - 16:15 - Criacao da estrutura, menu principal e conversao Binaria.
# -----------------------------------------------------------------------------

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
        

        li $v0, 4
        la $a0, error_msg
        syscall
        j while_menu


# FUNCIONALIDADE 1A: DECIMAL PARA BINARIO
call_binario:
    li $v0, 4
    la $a0, input_msg
    syscall

    li $v0, 5
    syscall
    move $s0, $v0           # $s0 guarda o numero decimal original (dividendo)
    
    # Prepara para o loop de divisao
    move $t1, $s0           # $t1 sera o quociente atual
    li $t2, 2               # Divisor
    li $t3, 0               # Contador de digitos (para desempilhar depois)

loop_div_bin:
    # Mostra passo a passo: "N / 2 = Q [Resto R]"
    
    # Imprime "[Passo] N"
    li $v0, 4
    la $a0, step_msg
    syscall
    
    li $v0, 1
    move $a0, $t1           # Imprime o numero atual antes de dividir
    syscall

    # Realiza a divisao
    div $t1, $t2            # HI = Resto, LO = Quociente
    mflo $t4                # $t4 = Quociente
    mfhi $t5                # $t5 = Resto

    # Imprime " / 2 = Q"
    li $v0, 4
    la $a0, div_msg
    syscall

    li $v0, 1
    move $a0, $t4
    syscall

    # Imprime " [Resto: R]"
    li $v0, 4
    la $a0, rem_msg
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, close_bracket
    syscall

    # Salva o resto na pilha (STACK) para imprimir invertido depois
    sub $sp, $sp, 4         # Abre espaco na pilha
    sw $t5, 0($sp)          # Salva o resto
    addi $t3, $t3, 1        # Incrementa contador de bits

    # Atualiza o quociente para a proxima iteracao
    move $t1, $t4

    # Se quociente > 0, continua. Se 0, acabou.
    bgt $t1, 0, loop_div_bin

    # --- FIM DA DIVISAO, AGORA IMPRIME O RESULTADO ---
    li $v0, 4
    la $a0, final_res_msg
    syscall

print_stack_bin:
    # Verifica se o contador zerou
    blez $t3, end_binario

    # Recupera da pilha
    lw $a0, 0($sp)          # Carrega o bit
    add $sp, $sp, 4         # Fecha espaco na pilha
    
    # Imprime o bit
    li $v0, 1
    syscall

    sub $t3, $t3, 1         # Decrementa contador
    j print_stack_bin

end_binario:
    j while_menu            # Volta para o menu principal

# -----------------------------------------------------------------------------
# ROTINA DE SAIDA
# -----------------------------------------------------------------------------
exit_prog:
    li $v0, 4
    la $a0, bye_msg
    syscall
    
    li $v0, 10              # Syscall code for exit
    syscall