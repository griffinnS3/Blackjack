extern hitLoop:PROC


.data
playerHand DWORD ?
dealerHand DWORD ?
deck DWORD 52 (?)

.data

; ----- String Tables -----
nameTable LABEL BYTE
    db "Ace",0
    db "2",0
    db "3",0
    db "4",0
    db "5",0
    db "6",0
    db "7",0
    db "8",0
    db "9",0
    db "10",0
    db "Jack",0
    db "Queen",0
    db "King",0

nameOffsets DWORD OFFSET nameTable, \
             OFFSET nameTable+4, \
             OFFSET nameTable+6, \
             OFFSET nameTable+8, \
             OFFSET nameTable+10, \
             OFFSET nameTable+12, \
             OFFSET nameTable+14, \
             OFFSET nameTable+16, \
             OFFSET nameTable+18, \
             OFFSET nameTable+20, \
             OFFSET nameTable+24, \
             OFFSET nameTable+29, \
             OFFSET nameTable+35

suitTable LABEL BYTE
    db "Diamonds",0
    db "Hearts",0
    db "Clubs",0
    db "Spades",0

suitOffsets DWORD OFFSET suitTable, \
             OFFSET suitTable+9, \
             OFFSET suitTable+16, \
             OFFSET suitTable+22


; ----- STRUCT Definition -----
Card STRUCT
    name    BYTE 32 DUP(?)     ; space for "10 of Diamonds", etc.
    suit    BYTE 16 DUP(?)     ; optional
    value   DWORD ?
Card ENDS

deck Card 52 DUP(<>)           ; 52-card deck


.code
FillDeck PROC

    mov ecx, 4                  ; suits
    xor esi, esi                ; suit index i
    xor edi, edi                ; card index in deck

OuterLoop:
    mov ebx, suitOffsets[esi*4] ; EBX = suit string ptr

    push ecx                    ; save ECX for outer-loop
    mov ecx, 13                 ; names J=0..12
    xor edx, edx                ; edx = name index j

InnerLoop:
    ; ------------------------------
    ; Build card name:
    ;   "<rank> of <suit>"
    ; ------------------------------

    ; j is in EDX
    mov eax, edx          ; EAX = j

    cmp eax, 0            ; Ace?
    jne NotAce
    mov eax, 1            ; Ace = 1
    jmp StoreValue

    NotAce:
    cmp eax, 10           ; Face card?
    jl NumericValue       ; j < 10 -> numeric ranks (2–10)
    mov eax, 10           ; Jack, Queen, King = 10
    jmp StoreValue

    NumericValue:
    inc eax               ; convert j=1->2, j=2->3, ..., j=9->10

    StoreValue:
    mov dword ptr [ebp + (32+16)], eax

CopyRank:
    mov al, [eax]
    mov [edi], al
    inc eax
    inc edi
    cmp al, 0
    jne CopyRank
    ; write space, 'o','f', space
    mov byte ptr [edi], ' '
    inc edi
    mov byte ptr [edi], 'o'
    inc edi
    mov byte ptr [edi], 'f'
    inc edi
    mov byte ptr [edi], ' '
    inc edi

    ; copy suit string
    mov eax, suitOffsets[esi*4]
CopySuit:
    mov al, [eax]
    mov [edi], al
    inc eax
    inc edi
    cmp al, 0
    jne CopySuit

    ; ------------------------------
    ; Assign value
    ; ------------------------------
    mov eax, edx               ; eax = j
    cmp eax, 9                 ; j > 8
    jle NormalValue
    mov eax, 10
    jmp StoreValue

NormalValue:
    ; j (0..12) -> value (0..12)
StoreValue:
    mov dword ptr [ebp + (32+16)] , eax   ; card.value

    pop esi
    pop ecx

    inc edx                 ; j++
    add edi, SIZEOF Card    ; next card in deck
    loop InnerLoop

    pop ecx
    inc esi                 ; suit++
    jecxz EndFill
    jmp OuterLoop

EndFill:
    ret
FillDeck ENDP

END



.code
asmMain PROC
;call hitLoop player dealer


asmMain endp
END