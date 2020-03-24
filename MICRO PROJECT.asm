                                           .model small
.stack 100
.data
            balance dw 2000
            welcome db '            ******WELCOME TO ATM SERVICE****** $'          
            msg db 'Enter your pincode: $'
            msg1 db 'your code is correct $'
            msg2 db 'your code is incorrect so enter code again $'
            password db 1,2,3,4
            arr2 db 4 dup(?)
            arr3 dw 4 dup(?) 
            withdraw db '1.Withdraw $'
            depositCash db '2.deposit Cash $'
            quit db        '4.Quit $' 
            choice db 'Enter your choice: $' 
            withdrawamount db 'Enter the amount to withdraw in the form of 4 digit (0000) $' 
            great db 'Insufficient balance $'
            WithAmount dw 00                     
            depositMsg db 'Enter the deposite amount in the form of 4 digit (0000) $'
            depositMoney dw 00
            chngePassMsg db '3.Change password $'
            oldPassMsg db 'Enter the old password $'
            newPassMsg db 'Enter the new password $'
            WithSuccess db 'Your Withdraw transation is done succesfully  $'
            depoSuccess db 'Your deposit transation is done succesfully $'
            continueMsgs db 'Do you wants to continue ' 
                         db 'press 1 to continue else press any button $'  
            right db 'please choose between given choices $' 
            count db 00
            block db "Your ATM is block $"
            thnksMsg db 'Thanks for using our ATM $'               
.code               
main proc 
    mov ax,@data
    mov ds,ax 
    call print
    
    mov ah,9h
    lea dx,welcome
    int 21h  
    
    begin:
    call print
    
    mov ah,9h
    lea dx,msg
    int 21h  
    
    mov si,0
    mov cx,4 
    
    loop1:           ;Password input
        mov ah,1h
        int 21h
        and al,0fh
        mov [arr2+si],al
        inc si
    loop loop1  
    
    mov si,0        ;Password checking
    mov cx,4 
    
    loop2:
        mov bl,[password+si]
        mov bh,[arr2+si]
        cmp bl,bh
        jne incorrect
        inc si
    loop loop2
    
    call print  
          
    mov ah,9h
    lea dx,msg1
    int 21h
  
    
    call print
    
    continueAgain:  ;continue again  or use again again
    
    call print
    
    mov ah,9h
    lea dx,withdraw
    int 21h
    
    call print
    
    mov ah,9h
    lea dx,depositCash
    int 21h   
    
    call print
    
    mov ah,9h
    lea dx,chngePassMsg
    int 21h
    
    call print
    
    mov ah,9h
    lea dx,quit
    int 21h
    
    call print
    
    mov ah,9h
    lea dx,choice
    int 21h  
      
    
    mov ah,1h
    int 21h
    and al,0fh
    
    cmp al,1h
    je withdrawFunction
        
    cmp al,2h
    je depositFunction
    
    cmp al,3h
    je passChangeFunction  
       
    cmp al,4h
    je exit 
    jg rightchoose
    jmp exit  
    
    withdrawFunction:   ;withdraw funtion
        call print 
        mov ah,9h
        lea dx,withdrawamount
        int 21h
    
        mov si,0
        mov cx,4 
        l1:
            mov ah,1h
            int 21h
            and al,0fh
            mov ah,00
            mov [arr3+si],ax
            add si,02
        loop l1 
     
        call combine
        mov bx,WithAmount
        cmp bx,balance
        jg greator
        
        sub balance,bx
        
        call print 
        mov ah,9h
        lea dx,withSuccess
        int 21h
        
        call continueFunction
               
     
    jmp exit
    
    
    depositFunction:   ; deposite function
        call print
        mov ah,09
        lea dx,depositMsg
        int 21h   
        
        call print
    
        mov si,0
        mov cx,4 
        l2:
            mov ah,1h
            int 21h
            and al,0fh
            mov ah,00
            mov [arr3+si],ax
            add si,02
        loop l2 
               
        mov si,00
   
        mov ax,[arr3+si]
        mov dx,1000
        mul dx
        add depositMoney,ax
        add si,02
   
        mov ax,[arr3+si]
        mov dx,0100
        mul dx
        add depositMoney,ax
        add si,02
   
        mov ax,[arr3+si]
        mov dx,0010
        mul dx
        add depositMoney,ax
        add si,02
 
        mov ax,[arr3+si]
        add depositMoney,ax
        
        mov ax,depositMoney
        add balance,ax
        
        mov ax, balance

        
        call continueFunction
    
    jmp exit
    
    passChangeFunction:  ; password change function
        call print
        mov ah,9h
        lea dx,oldPassMsg
        int 21h  
    
        mov si,0
        mov cx,4 
    
        loop3:           ;old password input
            mov ah,1h
            int 21h
            and al,0fh  
            mov [arr2+si],al
            inc si
        loop loop3  
        
    
        mov si,0        ;Password checking
        mov cx,4 
    
        loop4:
            mov bl,[password+si]
            mov bh,[arr2+si]
            cmp bl,bh
            jne exit
            inc si
        loop loop4
        
        call print
        mov ah,9h
        lea dx,newPassMsg
        int 21h
        
        mov si,0
        mov cx,4
        
        loop5:           ;new password input
            mov ah,1h
            int 21h
            and al,0fh
            mov [password+si],al
            inc si
        loop loop5 
        
        jmp begin  
           
    jmp exit
    
     greator:
        call print
        mov ah,9h
        lea dx,great
        int 21h         
    jmp exit    
    
   
    incorrect:
        call print
      
        mov ah,9h
        lea dx,msg2
        int 21h
        call print
        inc count
        cmp count,3h
        je systemblock 
       
        jmp begin     
        
    systemblock:
    mov ah,9h
    lea dx,block
    int 21h
    jmp exit    
 
     
    print:
        mov ah,2h
        mov dl,0Ah
        int 21h 
        mov ah,2h
        mov dl,0dh
        int 21h
    ret
    
    continueFunction:
         
        call print
        mov ah,9h
        lea dx,continueMsgs
        int 21h         
    
        mov ah,01
        int 21h
        and al,0fh
        
        cmp al,1
        je continueAgain
    
    ret
    
    combine:   ;set withdraw money in money
        mov si,00
   
        mov ax,[arr3+si]
        mov dx,1000
        mul dx
        add WithAmount,ax
        add si,02
   
        mov ax,[arr3+si]
        mov dx,0100
        mul dx
        add WithAmount,ax
        add si,02
   
        mov ax,[arr3+si]
        mov dx,0010
        mul dx
        add WithAmount,ax
        add si,02
   
        mov ax,[arr3+si]
        add WithAmount,ax     
    ret 
    
    rightchoose:
    call print
    mov ah,9h
    lea dx,right
    int 21h 
    jmp continueAgain
    
    
    exit:
        call print
    
        mov ah,09h
        lea dx,thnksMsg
        int 21h 
                  

    
endp    
end main