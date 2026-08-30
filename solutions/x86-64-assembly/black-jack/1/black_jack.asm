; Everything that comes after a semicolon (;) is a comment

C2 equ 2
C3 equ 3
C4 equ 4
C5 equ 5
C6 equ 6
C7 equ 7
C8 equ 8
C9 equ 9
C10 equ 10
CJ equ 11
CQ equ 12
CK equ 13
CA equ 14

TRUE equ 1
FALSE equ 0

section .text

; You should implement functions in the .text section

; the global directive makes a function visible to the test files
global value_of_card
value_of_card:
    ; This function takes as parameter a number representing a card
    ; The function should return the numerical value of the passed-in card
    cmp rdi, CA
    jne .not_ace
    mov rax, 1
    ret
.not_ace:
    cmp rdi, C10
    ja .face
    mov rax, rdi
    ret
.face:
    mov rax, 10
    ret

global higher_card
higher_card:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return which card has the higher value
    ; If both have the same value, both should be returned
    ; If one is higher, the second one should be 0
    call value_of_card
    mov r10, rax ; r10 = value_of_card($0)
    mov r11, rdi ; r11 = $0
    mov rdi, rsi ; $0 = $1
    call value_of_card ; rax = value_of_card($0)
    cmp r10, rax ; value_of_card(arg[0]) - value_of_card(arg[1])
    jne .ne
    mov rax, r11
    mov rdx, rsi
    ret
.ne:
    mov rdx, 0
    ja .a
    mov rax, rsi
    ret
.a:
    mov rax, r11
    ret

global value_of_ace
value_of_ace:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return the value of an upcoming ace
    cmp rdi, CA
    jne .ne_CA_0
    mov rax, 1
    ret
.ne_CA_0:
    cmp rsi, CA
    jne .ne_CA_1
    mov rax, 1
    ret
.ne_CA_1:
    call value_of_card
    mov r10, rax
    mov rdi, rsi
    call value_of_card
    add rax, r10
    cmp rax, 11
    jb .b_11
    mov rax, 1
    ret
.b_11:
    mov rax, 11
    ret

global is_blackjack
is_blackjack:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a blackjack, and FALSE otherwise
    cmp rdi, CA
    je .first_is_ace
    cmp rsi, CA
    je .second_is_ace
    mov rax, FALSE
    ret
.first_is_ace:
    mov rdi, rsi
.second_is_ace:
    call value_of_card
    cmp rax, 10
    je .other_is_10
    mov rax, FALSE
    ret
.other_is_10:
    mov rax, TRUE
    ret

global can_split_pairs
can_split_pairs:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards can be split into two pairs, and FALSE otherwise
    call value_of_card
    mov r10, rax
    mov rdi, rsi
    call value_of_card
    cmp rax, r10
    je .e
    mov rax, FALSE
    ret
.e:
    mov rax, TRUE
    ret

global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise
    call value_of_card
    mov r10, rax
    mov rdi, rsi
    call value_of_card
    add rax, r10
    cmp rax, 9
    jb .fail
    cmp rax, 11
    ja .fail
    mov rax, TRUE
    ret
.fail:
    mov rax, FALSE
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
