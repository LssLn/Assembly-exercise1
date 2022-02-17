.data 
ST: .space 16 ;# ST[16]
stack: .space 32

msg1: .asciiz "Inserisci una str di num\n"
msg2: .asciiz "Valore : %d\n" ;# cnt 1° arg msg2

p1sys5: .space 8
cnt: .space 8 ;# 1° arg msg2

p1sys3: .word 0 ;#fd null
ind: .space 8
dim: .word 16 ;# numbyte da leggere <= ST

.code
;# init stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s0,$0,0 ;#i=0
for:
    slti $t0,$s0,2 ;# $t0=0 quando $s0(i) >= 2
    beq $t0,$0,exit ;# quando $t=0, exit 

    ;# printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# scanf %s ST
    daddi $t0,$0,ST
    sd $t0,ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    ;# passaggio parametri : somma pari
    daddi $a0,$0,ST     ;#$a0 = ST
    move $a1,r1         ;# $a1 = strlen

    jal somma_pari

    sd r1,cnt($0) ;# cnt = return somma_pari
    
    ;#printf msg2
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5

    ;#incremento for e salto
    daddi $s0,$s0,1 ;# i++
    j for

somma_pari: ;# $a0=ST   $a1=strlen
    daddi $sp,$sp,-16 ;#8x2, i e somm
    sd $s1,0($sp) ;# i
    sd $s2,8($sp) ;# somma
    daddi $s1,$0,0 ;# i=0
    daddi $s2,$0,0 ;# somma=0
for_f:
    slt $t0,$s1,$a1 ;# $t0=0 quando $s1 (i) >= $a1 (strlen)
    beq $t0,$0, return ;#return quando for finisce aka $t0=0

    ;# if (st[i] %2 == 0)
        ;# carico st[i]
    dadd $t0,$a0,$s1 ;# $t0 = & st [i] = $a0 (st) + $s1 (i)
    lbu $t1,0($t0) ;# ora ho st[i]
        ;# %2 
    daddi $t2,$0,2 ;# $t2 = 2
    ddiv $t1,$t2 ;# $t1/$t2 = st[i]/2. Hi : resto, Lo : quoziente
            ;# vedo quindi se il resto è 0, se lo è allora %2==0.
    mfhi $t0 ;# ora il resto è su $t0.
    bne $t0,$0,falso    ;# Se non è pari ($t0!=0, c'è resto) allora vado a falso (scorro for) senza passare per somma++
    daddi $s2,$s2,1     ;# somma++ e poi dopo passo comunque a falso:, per scorrere il ciclo
falso:
    daddi $s1,$s1,1 ;# i++
    j for_f

return:
    move r1,$s2 ;# r1 = somma
    ld $s1,0($sp)
    ld $s2,8($sp)
    daddi $sp,$sp,-16
    jr $ra
exit:
    syscall 0

;#                  Approfindimento su %2==0 :
;# quando effettui una divisione il processore MIPS presenta i risultati nei registri HI e LO.
;# in particolare in LO il quoziente mentre in HI il resto.
;# quindi un numero è pari se la sua divisione per 2 porta il registro HI a 0, altrimenti è dispari.
;#  ddiv $t1,$t2 : $t1/$t2 con quoziente in lo e resto in hi.       mflo/hi $t0 spostano lo/hi in $t0.
