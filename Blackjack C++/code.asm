extern hitLoop:PROC


.data
playerHand DWORD ?
dealerHand DWORD ?
deck DWORD 52 (?)


.code
asmMain PROC
;call hitLoop player dealer


asmMain endp
END