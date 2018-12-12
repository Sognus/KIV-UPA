        .data						# Datovy blok
fix:	.asciiz "Pozadovany pocet clenu by zpusobil preteceni, nastavuji pocet clenu na 47!\n"
msg:   	.asciiz "Zadejte pozadovany pocet clenu fibonnaciho posloupnosti: "
lim:	.asciiz "Minimalni pozadovany pocet clenu fibonnaciho posloupnosti musi byt 2 a vice!\n" 
									# Text pro vypis
nl:		.asciiz "\n"				# Text pro odradkovani
c0:		.byte 0						# ASCII hodnota pro cisla
buffer: .space 9					# prevedeny text

        .text

crlf:	nop							# Vypise znak nove radky									
		li $v0,4					# syscall 4 (print_str)
		la $a0,nl					# argument: string
		syscall						# zavolani syscall
		jr $ra						# navrat z procedury
		
vypis:	nop							# Vypise text urceny labelem msg
		li $v0,4					# syscall 4 (print_str)
		la $a0,msg					# argument: string
		syscall						# zavolani syscall
		jr $ra						# navrat z procedury
		
fib:	nop							# vypise X clenu fibonnaciho posloupnosti 
		li $v0,5					# sluzba nacti cislo
		syscall						# syscall
		move $t0,$v0				# ulozeni nacteneho cisla do $t0
		
		li $s4,2
		slt $s3,$t0,$s4
		beq $s3,$0,skip
		
		li $v0,4					# syscall 4 (print_str)
		la $a0,lim					# argument: string
		syscall						# zavolani syscall
		jr $ra						# navrat z procedury - ukonceni podprogramu
		
skip:	nop

		add $t0,-2					# Prvni dva cleny uz jsou vypsany
		
		li $s4,45					# nastaveni horniho stropu na 45
		slt $s3,$s4,$t0				# $s3 = 1 if $s4,$t0 else $s3 = 0
		beq $s3,$0,tskip			# pokud je vstup mensi jak 45 preskoc na tskip
		
		li $t0,45					# oprava vstupu, pokud je vetsi nez 45 nastavi se na 45
		li $v0,4					# syscall 4 (print_str)
		la $a0,fix					# argument: string
		syscall						# zavolani syscall
				
tskip:	nop							# navesti preskoceni automaticke opravy vstupu (preteceni)		
		
		li $t1,0					# Nastaveni promenne a na vychozi hodnotu 0
		li $t2,1					# Nastaveni promenne b na vychozi hodnotu 1					
		
		li $v0,1					# sluzba vypis cislo
		move $a0,$t1				# vypis vychoziho stavu promenne A
		syscall						# syscall
		jal crlf					# zavolej prodprogram na radkovani
		
		li $v0,1					# sluzba vypis cislo
		move $a0,$t2				# vypis vychoziho stavu promenne B
		syscall						# syscall
		jal crlf					# zavolej prodprogram na radkovani
		
		beqz $t0,fib_end
		
fib_if:	nop							# Navesti pro cyklus
		addi $t0,-1					# dekrementace pocitace cyklu o 1
		move $t3,$t2				# presun promenne B do pomocne promenne
		add $t2,$t2,$t1				# vypocet TEMP2 = B + A
		move $t1,$t3				# presun pomocne promenne do A
		
		li $v0,1					# sluzba vypis cisla
		move $a0,$t2				# vypis obsah promenne B
		syscall						# syscall
		jal crlf					# zavolej podpogram na radkovani
		
		bgtz $t0,fib_if				# pokud je pocitac cyklu vyssi jak 0, skoc na fibb_iff
fib_end:
		jr $ra						# navrat z procedury

iprnt:	nop							# Integer print: prevede cislo na ASCII hodnotu pro vypis
		li $s0,5					# Limitace delicky na 5 mist
		li $s1,10000				# Delitel
		li $s2,10					# Delitel se vzdy deli 10 (zmenseni mist)
		nop							# konec inicializacniho bloku	
		jr $ra						# navrat z procedury

		.globl main
main: 	nop							# hlavni procedura programu
		jal vypis					# zavolani procedury vypis
		jal fib						# zavolani procedury fib
        
        li $v0,10          			# ukonceni programu
		syscall						# syscall
