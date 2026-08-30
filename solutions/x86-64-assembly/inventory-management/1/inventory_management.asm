; Everything that comes after a semicolon (;) is a comment

WEIGHT_OF_EMPTY_BOX equ 500
TRUCK_HEIGHT equ 300
PAY_PER_BOX equ 5
PAY_PER_TRUCK_TRIP equ 220

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global get_box_weight
get_box_weight:
    ; This function takes the following parameters:
    
    ; - The number of items for the first product in the box, as a 16-bit non-negative integer
    movzx rdi, di ; cFstProduct
    
    ; - The weight of each item of the first product, in grams, as a 16-bit non-negative integer
    movzx rsi, si ; gFstProduct
    
    ; - The number of items for the second product in the box, as a 16-bit non-negative integer
    movzx rdx, dx ; cSndProduct
    
    ; - The weight of each item of the second product, in grams, as a 16-bit non-negative integer
    movzx rcx, cx ; gSngProduct
    
    ; The function must return the total weight of a box, in grams, as a 32-bit non-negative integer

    ; Consider that an empty box weighs 500 g
    mov rax, WEIGHT_OF_EMPTY_BOX

    ; r8 = cFstProduct * gFstProduct
    mov r8, rdi
    imul r8, rsi

    ; rax += r8
    add rax, r8

    ; r8 = cSndProduct * gSngProduct
    mov r8, rdx
    imul r8, rcx

    ; rax += r8
    add rax, r8
    
    ret

global max_number_of_boxes
max_number_of_boxes:
    ; This function takes the following parameter:
    ; - The height of the box, in centimeters, as a 8-bit non-negative integer
    ; The function must return how many boxes can be stacked vertically, as a 8-bit non-negative integer
    mov ax, TRUCK_HEIGHT
    div dil
    movzx rax, al
    ret

global items_to_be_moved
items_to_be_moved:
    ; This function takes the following parameters:
    ; - The number of items still unaccounted for a product, as a 32-bit non-negative integer - rdi
    ; - The number of items for the product in a box, as a 32-bit non-negative integer - rsi
    ; The function must return how many items remain to be moved, after counting those in the box, as a 32-bit integer
    movzx rax, edi
    movzx rsi, esi
    sub rax, rsi
    ret

global calculate_payment
calculate_payment:
    ; TODO: define the 'calculate_payment' function
    ; This function takes the following parameters:
    ; - The upfront payment, as a 64-bit non-negative integer - rdi
    ; - The total number of boxes moved, as a 32-bit non-negative integer - esi
    ; - The number of truck trips made, as a 32-bit non-negative integer - edx
    ; - The number of lost items, as a 32-bit non-negative integer - ecx
    ; - The value of each lost item, as a 64-bit non-negative integer - r8
    ; - The number of other workers to split the payment/debt with you, as a 8-bit positive integer - r9b
    
    ; The function must return how much you should be paid, or pay, at the end, as a 64-bit integer (possibly negative)
    ; Remember that you get your share and also the remainder of the division

    ; net 
    ;   = boxes * PAY_PER_BOX 
    ;   + trips * PAY_PER_TRUCK_TRIP 
    ;   - up_front 
    ;   - broken_items * item_value

    ; u32 boxes := esi
    ; const PAY_PER_BOX := 5
    ; u32 trips := edx
    ; const PAY_PER_TRUCK_TRIP : 220
    ; u64 up_front := rdi
    ; u32 broken_items := ecx
    ; u64 item_value := r8

    ; ret = net / (workers + 1) ... then deal with remainder
    ; u8 workers := r9b

    ; r10, r11 as scratch

    movzx rsi, esi
    imul r10, rsi, PAY_PER_BOX ; r10 = boxes * PAY_PER_BOX

    movzx rdx, edx
    imul r11, rdx, PAY_PER_TRUCK_TRIP ; r11 = trips * PAY_PER_TRUCK_TRIP 

    add r10, r11 ; r10 = (boxes * PAY_PER_BOX) + (trips * PAY_PER_TRUCK_TRIP)

    sub r10, rdi ; r10 = (boxes * PAY_PER_BOX) + (trips * PAY_PER_TRUCK_TRIP) - up_front

    movzx r11, ecx
    imul r11, r8 ; r11 = broken_items * item_value

    sub r10, r11 ; r10 = net

    movzx r9, r9b
    inc r9 ; ++workers ; include yourself

    mov rax, r10
    cqo
    idiv r9 ; rax = net/(workers + 1), rdx = net%(workers + 1)

    add rax, rdx ; keep the remainder
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
