.386
.model flat, stdcall
.stack 4096

extern hitLoop:PROC
extern getSeed:PROC


.data
playerHand DWORD ?
dealerHand DWORD ?
seed DWORD ?


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
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx

    xor esi, esi                ; suit index (0-3)


OuterLoop:
    cmp esi, 4      ; Done with all 4 suits
    jge EndFill
    
    xor edx, edx    ; Rank index (0-12) 

InnerLoop:
    cmp edx, 13     ; done all 13 ranks ?
    jge NextSuit
    
    ;Calculate card index: cardIndex = (suit * 13) + rank 
    mov eax, esi
    imul eax, 13
    add eax, edx
    imul eax, SIZEOF card
    lea edi, deck[eax]      ;EDI points to current card
    ;--------------
    ;COPY RANK NAME
    ;--------------

    push edi        ; Save card address
    mov eax, nameOffsets[edx*4] ;get pointer to rank string 

    CopyRank:
    mov al, [eax]
    mov [edi], al
    inc eax
    inc edi
    cmp al, 0
    jne CopyRank

    dec edi

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

 ;---------------------------
; CALCULATE AND STORE VALUE
;---------------------------
    pop edi         ;restore card address
  
    mov eax, edx          ; EAX = rank (0-12)

    cmp eax, 0            ; Ace?
    jne NotAce
    mov eax, 1            ; Ace = 1
    jmp StoreValue

    NotAce:
    cmp eax, 10           ; Face card?
    jle NumericValue       ; j <= 10 -> numeric ranks (2–10)
    mov eax, 10           ; Jack, Queen, King = 10
    jmp StoreValue

    NumericValue:
    inc eax               ; convert j=1->2, j=2->3, ..., j=9->10
    
    StoreValue:
    mov dword ptr [edi + 32 + 16], eax ; stores in card.value

    inc edx         ; next rank
    jmp InnerLoop

    NextSuit:
    inc esi         ; Next suit
    jmp OuterLoop 

    
EndFill:
pop ebx
pop edi
pop esi
pop ebp
    ret
FillDeck ENDP

Random PROC
push ebx 
push edx

 ; Linear congruential generator: seed = (seed * 1103515245 + 12345)
    mov eax, seed
    imul eax, 1103515245
    add eax, 12345
    mov seed, eax           ; Update seed for next call
    
    pop edx
    pop ebx
    ret
Random ENDP

; Get random number in range [0, n)
RandomRange PROC
push ebx
push edx
mov ebx, edx    ; save n as upper bound
call Random 
xor edx, edx
div ebx         ; EDX = Random # % n
mov eax, edx    ; Store result in eax
pop edx
pop ebx
ret 
RandomRange ENDP

;Shuffle Deck
ShuffleDeck PROC
push esi
push edi
push ecx
push ebx

mov ecx, 51     ; Start from last card

ShuffleLoop:
mov eax, ecx
inc eax     ; Range [0, ecx + 1)
call RandomRange

mov esi, ecx
imul esi, SIZEOF Card
lea esi, deck[esi]      ; ESI = address of deck [ecx]

mov edi, eax
imul edi, SIZEOF Card
lea edi, deck[edi] ; EDI = address of deck[eax]

; Swap the two card structures
mov ebx, SIZEOF Card
SwapBytes:
mov al, [esi]
mov dl, [edi]
mov [esi], dl
mov [edi], al
inc esi
inc edi
dec ebx
jnz SwapBytes

dec ecx 
jnz ShuffleLoop

pop ebx
pop ecx
pop edi
pop esi
ret
ShuffleDeck ENDP


asmMain PROC
call getSeed
mov seed, eax
call FillDeck       ; Create and fill deck with cards
call ShuffleDeck    ; Shuffle deck 
;call hitLoop player dealer

ret
asmMain endp
END