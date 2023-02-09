
[org 0x0100]
jmp start


oldisr : dd 0
oldisr1 : dd 0
count : dw  0
incTime: dw 0 
min: dw 0
sec: dw 0
balls_count : dw  0
index : dw 0
score : dw  0
temp : dw  0
msg : db "Score: 0000 "
msg2 : db " Time: 0:00"
on_screen_alpha : dw 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0
on_screen_loc : db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
location: db 155 , 181 , 60 , 181 , 115 , 181 , 196 , 181 , 83 , 181 , 147  , 181 , 211 , 181 , 235 , 181 , 59 , 181 , 195 , 181 , 83 , 181 
loc_alpha: db 20  , 23 , 8 , 23 ,15 , 23 , 25, 23 , 11 , 23 , 19 , 23 , 27 , 23 , 30 , 23 ,8 ,23 , 25 , 23  , 11 , 23
alphabtes1: dw 'A' , 'C' , 'E' , 'G' , 'I' , 'K' , 'M' , 'O' , 'Q' , 'S' , 'U'
BallsPopped : db "Balls Popped: 000"
Score_msg : db "You Scored: 0000"
BallsMissed : db "Missed Balls : 000"

result:
  push ax
  push dx
  push cx
  push es
  push bx
  push bp

  ; storing the count as a string in scoremsg string for its printing  purposes
  push 15
  mov ax , Score_msg
  push ax
  push word[score]
  call num_display
  
  ; counting balls popped by the player and storing its count in dx 
  mov dx , 0
  mov bx  ,10
  mov ax , [score]
  div bx
  mov dx , ax


  ; then storing the popped balls count in ballspopped string for its printing purposes
  push 16
  mov ax , BallsPopped
  push ax
  push dx
  call num_display

  ; counting balls missed by the player and storing its count in dx 
  

  mov  ax ,[balls_count]
  sub ax , dx
  push 17
  mov dx , BallsMissed
  push dx
  push ax
  call num_display



  mov  ah, 0x13
  mov  al, 1
  mov  bh, 0
  mov  bl, 0x0E
  mov  dx, 0x090C
  mov  cx, 16
  push cs
  pop  es
  mov  bp, Score_msg
  int  0x10
  
  mov  dx, 0x0B0C
  mov cx , 17
  mov bp , BallsPopped
  int  0x10

  mov  dx, 0x0D0C
  mov cx , 18
  mov bp , BallsMissed
  int  0x10
 

  pop bp
  pop bx
  pop es
  pop cx
  pop dx
  pop ax

  ret
  
box_pop:
  ; getting coordinates of box to be removed
  push bp
  mov bp ,sp
  push ax
  push dx
  push cx
  push si

  mov  ax, 0x0C06       
  mov bx , 0             ; page 0
  mov dx , [bp + 4]      ; y coordinate
  mov cx , [bp + 6]      ; x coordinate
  mov si , 16

  o_loop:
    push cx
    push si
    mov si , cx
    add si , 16

    ; printing the horizontal line of blue pixels
    i_loop:
      int  0x10             ; printing pixel
      add cx , 1            ; inc x coordinate
      cmp cx , si           ; untill we have traversed the whole box length i.e 14
      jne i_loop 
    
    pop si
    pop cx
    inc dx                 ; inc y coordinate 
    dec si
    jnz o_loop

  pop si
  pop cx
  pop dx
  pop ax
  pop bp
  ret 4

decrementer:
  ; one paramter of how many entries are to be processed 1-11
  
  push bp
  mov bp ,sp
  push cx
  push si

  mov cx, [bp + 4]
  mov si , 0
  l8:
    sub byte[on_screen_loc + si + 1] , 8
    add si , 2
    loop l8

  pop si
  pop cx
  pop bp

  ret 2

; getting two paramters 1- array address 2- alphabet to be pushed or coordinates to be pushed
pushing:
  push bp
  mov bp  , sp
  push si
  push ax
  push cx
   
  mov bx , [bp + 6] ; address where shifting would be occured

  mov si, [index]

  mov ax , [bp + 4]

  mov [bx + si + 1] , ah   ; 0 in case of alphabet and y coordinate in case of points
  mov [bx + si + 0] , al   ; alphabet asci in case of alphabet and x coordinate in case of points
  
  end1:
  
   pop cx
   pop ax
   pop si
   pop bp

   ret 4
  
   
  
    


Time_display :
    push ax
    push bx
    push cx
    push si
   ;----it is taking the number stored in sec variable and place it at the end of msg 2 in seconds place ----------
    mov ax , [cs:sec]
    mov bl ,10
    mov si , 10
   nextDigit:
      mov ah ,0
      div bl
     
      add ah , 0x30
      mov [msg2 + si] , ah
      dec si
      cmp si , 8
      jnz nextDigit
    
    ;-----placing the minutes stored in min memory address at at the minutes location of msg 2 ==============
    mov al , [cs:min]
    add al , 0x30
    mov byte[msg2 + 7]  , al
    pop si
    pop cx

    pop bx
    pop ax
    ret



Big_Sleep:
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  call sleep
  
  
    
   

  ret
temp_func:
    push bp
    mov bp , sp
    push ax
    push dx
    push bx
    push cx


    mov AH , 2h ; Set cursor position
    mov dl, [bp + 6] ; Column
    mov dh, [bp + 4]; Row
    mov bx, 0 ; Page number, 0 for graphics modes
    int 10h
   
    mov bx , [bp + 8]  ; moving character in bx


    mov ah, 09h        ; service to print character
    mov al, bl         ; storing character in al

    mov Bh , 0         ; page number
     mov  bl, 0x1E     ; color of character
    mov cx , 1         ; number of times to print
    int 10h             ;int call

    pop cx
    pop bx
    pop dx
    pop ax
    pop bp

    ret 6


print_msg_time :
    push ax
    push bx
    push dx
    push cx
    push es


    mov  ah, 0x13
    mov  al, 1
    mov  bh, 0
     mov  bl, 0x6F
    mov  dx, 0x0000
    mov  cx, 12
    push cs
    pop  es
    mov  bp, msg
    int  0x10

    mov  dx, 0x001D
    mov  cx, 11
    push cs
    pop  es
    mov  bp, msg2
    int  0x10

    pop es
    pop cx
    pop dx
    pop bx
    pop ax
   
    ret

drawRec:


 push bp
 mov bp , sp
 push ax
 push bx
 push cx
 push dx
 push si

 mov  ax, 0x0C07    ; put pixel in white color
 mov bx , 0         ; printing on page 0
 mov dx , [bp + 4]  ; y coordinate of box
 mov cx , [bp + 6]  ;  x coordinate of box
 mov si ,cx
 add cx , 15 ; 15 is the size of the box

 ;----------------------- printing box -----------------------------
  l1: 
    int  0x10       ; interrupt for ptinting (pixel of upper line of box)
    push dx         ; storing the value of dx i.e y coordinate 
    add dx , 15      ; moving to the coordinate of bottom line
    int  0x10        ; printing the pixel of bottom line
    pop dx           ; pop dx
    
    dec cx          ; decrementing cx i.e xcoordinate as we are moving from right to left
    cmp cx , si
    jnz l1
 
   mov cx , [bp + 6]
   mov dx , [bp +4]
   mov si , dx
   add si , 15

    l2: 
    int  0x10 ; interrupt for ptinting (pixel of left line of box)
    push cx
    add cx , 15  
    int  0x10; interrupt for ptinting (pixel of right line of box)
    pop cx
   
    inc dx
    cmp dx , si
    jnz l2
    
    ;uptill now we have drawn a simpe hollow box with white boundaries -----------------
    ; --------------- now turn for coloring it with blue ----------------------------


    ;-------------------- ending printing box --------------------------------
    mov  ax, 0x0C01        ; Blue pixel in blue color 
    mov bx , 0             ; page 0
    mov dx , [bp + 4]      ; y coordinate
    mov cx , [bp + 6]      ; x coordinate

    mov si , 14             ; size 14 as we want after coloring the white border should be visible
    add cx , 1              ; same purpose to show the borders visible
    add dx , 1              ; same purpose
    


   ;---------filing the box with blue color --------------------
    l5:
        push cx
        push si
        mov si , cx
        add si , 15
        sub si , 1

        ; printing the horizontal line of blue pixels
        l6:
        int  0x10             ; printing pixel
        add cx , 1            ; inc x coordinate
        cmp cx , si           ; untill we have traversed the whole box length i.e 14
        jne l6 
        
        pop si
        pop cx
        inc dx                 ; inc y coordinate 
        dec si
        jnz l5

  pop si
  pop dx
  pop cx
  pop bx 
  pop ax

  pop bp
  ret 4
   

sleep: 
    push cx
    mov cx, 0xFFFF
    delay: 
    loop delay
    pop cx
    ret



maintainer:
  push si
  mov si  ,0
  l3:
   cmp word[alphabtes1 + si] , 'Z'
   jne proceed
   mov word[alphabtes1 + si] , 'A'
   sub  word[alphabtes1 + si] , 1
   proceed:
    add word[alphabtes1 + si] , 1;
    add si , 2
    cmp si , 22
    jne l3

    pop si

    ret
   
   
Clock:
   push ax
   
   ; --------- Here we have used the fact the 18 clock ticks  = 1 second , so we have a counter invTime when 
   ;it gets equal to 18 then we jump to Reset and update the seconds otherwise end the intterupt------------------------------------
   
   inc word [cs:incTime]
   cmp word [cs:incTime] , 18
   jz Reset
   jmp end

   proceedToCall:
      
      call Time_display
      

    end:
      mov al , 0x20 
      out 0x20 , al

      pop ax
      iret

   Reset:
      mov word [cs:incTime] , 0
      inc word [cs:sec]
      ; ------------if seconds are not 60 then keep on calling TIme display func ie updating msg2
      ; otherwise increment the minutes ---------------------------------------------------------
      

      cmp word [cs:sec] , 60
      jnz proceedToCall
      mov word [cs:sec] , 0
      inc word [cs:min]
      ;-----------if minutes are less then or equal to 2 then keep on calling Time_display func -------------
      cmp word [cs:min] , 2
      jnz proceedToCall

      jmp proceedToCall
      
key_stroke:
  push dx
  push ax
  push si
  push cx

  in al , 0x60
  mov ah , 0

  ; function returning asci code of corresponding scans code ,generated when a key pressed , in dl 
  ;if the key pressed is ither than A-Z alphabets then it return 0 in dl
  push ax
  call toAsci_converter   
  cmp dl , 0
  jz exit3
  
  
  mov cx, [count]   ; array length
  mov si , 0        ; starting index
  ; searching the array with pressed key using its asci code , if it present in array then jmp to end2 l
  ; label and pop the corresponding box
  mainloop: 
    mov al , dl
    cmp [on_screen_alpha + si] , ax
    je end2
    add si , 2
    loop mainloop
  jmp exit3
    end2:
     mov ah ,0
     mov al , [on_screen_loc + si]
     push ax
     mov al , [on_screen_loc + si + 1]
     push ax
     call box_pop
     add word[score] , 10      ; balls now popped , inc score by 10
    
     mov word[on_screen_loc + si] , 0    ; place 0, 0 on that balls x,y location in the array 
     mov word[on_screen_alpha + si] , 0  ; place 0 in its corresponding  alphabet array index i.e si
     ;----------------------
     push 10
     mov ax , msg
     push ax
     push word[score]
     call num_display       ; display the score in the string msg
     jmp exit3              ; exit

  

  exit3:
   mov  al, 0x20
  out  0x20, al
   pop cx
   pop si
   pop ax
   pop dx
   iret

  

clScr:
  push bp
  mov bp ,sp
  push ax
  push cx

  mov  ax, [bp + 4]    ; put pixel in white color
 mov bx , 0         ; printing on page 0
 mov dx , 0  ; y coordinate of box
 mov cx , 0  ;  x coordinate of box
 
 lupy1:
   push cx
   lupy2:
     int 0x10
     add cx , 1
     cmp cx , 320
     jnz lupy2
    pop cx  
    add dx  ,1
    cmp dx , 200
    jne lupy1 
  pop cx
  pop ax
  pop bp
  ret 2
num_display:
 push bp 
 mov bp , sp
 push ax
 push bx
 push si
 push dx
 push cx

 mov ax , [bp + 4]  ; number to print
 mov bx , [bp + 6]  ; address of number variable
 mov cx  , 10
 cmp ax , 0
 je exit2
 mov si , [bp + 8] ; index 
 lupy3:
  mov dx  , 0
  div cx
  add dl ,0x30
  mov [bx + si] , dl
  dec si
  cmp ax, 0
  jne lupy3



  exit2:
   pop cx
   pop dx
   pop si
   pop bx
   pop ax
   pop bp

   ret 6
   


   
toAsci_converter:
  ; recieve scans code and convert it into is asci
   push bp
   mov bp , sp
   push ax
   mov  ax , [bp + 4]
   
   

   mov dx , 0    ; returning asci in dl
   A: 
    cmp al , 0x1E
    jne B
    mov dl , 0x41
    jmp exit

   B:
    cmp al , 0x30
    jne C
    mov dl , 0x42
    jmp exit
   C:
    cmp al , 0x2E
    jne D
    mov dl , 0x43
    jmp exit 
   D:
    cmp al , 0x20
    jne E
    mov dl , 0x44
    jmp exit  
   E:
    cmp al , 0x12
    jne F
    mov dl , 0x45
    jmp exit 
   F:
    cmp al , 0x21
    jne G
    mov dl , 0x46
    jmp exit  
   G:
    cmp al , 0x22
    jne H
    mov dl , 0x47
    jmp exit  
   H:
    cmp al , 0x23
    jne I
    mov dl , 0x48
    jmp exit
   I:
    cmp al , 0x17
    jne J
    mov dl , 0x49
    jmp exit   
   J:
    cmp al , 0x24
    jne K
    mov dl , 0x4A
    jmp exit
   K:
    cmp al , 0x25
    jne L
    mov dl , 0x4B
    jmp exit     
   L:
    cmp al , 0x26
    jne M
    mov dl , 0x4C
    jmp exit
   M:
    cmp al , 0x32
    jne N
    mov dl , 0x4D
    jmp exit  
   N:
    cmp al , 0x31
    jne O
    mov dl , 0x4E
    jmp exit
   O:
    cmp al , 0x18
    jne P
    mov dl , 0x4F
    jmp exit
   P:
    cmp al , 0x19
    jne Q
    mov dl , 0x50
    jmp exit 
   Q:
    cmp al , 0x10
    jne R
    mov dl , 0x51
    jmp exit 
   R:
    cmp al , 0x13
    jne S
    mov dl , 0x52
    jmp exit

   S:
    cmp al , 0x1F
    jne T
    mov dl , 0x53
    jmp exit

   
   T:
    cmp al , 0x14
    jne U
    mov dl , 0x54
    jmp exit
   U:
    cmp al , 0x16
    jne V
    mov dl , 0x55
    jmp exit  
   V:
    cmp al , 0x2F
    jne W
    mov dl , 0x56
    jmp exit 
    W:
    cmp al , 0x11
    jne X
    mov dl , 0x57
    jmp exit 
   X:
    cmp al , 0x2D
    jne Y
    mov dl , 0x58
    jmp exit

    Y:
    cmp al , 0x15
    jne Z
    mov dl , 0x59
    jmp exit
   Z:
    cmp al , 0x2C
    jne finish
    mov dl , 0x5A
    jmp exit
    
    finish:
     mov dl  , 0
    exit:
     pop ax
     pop bp
     ret 2

start:
    mov  ax, 0x000D   ; 320 cols , 200 rows
    int  0x10
    
    push 0x0C06
    call clScr
  
    mov  ah, 0
    int  0x16     ; interrupt for getting input from keyboard

    ;=================== overriding isr 8 for time diaplying purpose  ===================
    
    mov ax , 0
    mov es , ax

    mov ax, [es:8*4]
    mov [cs:oldisr], ax
    mov ax, [es:8*4+2]
    mov [cs:oldisr+2], ax
    cli
        mov word [es:8*4] , Clock
        mov  [es:8*4+2] , cs
    sti
   ;========================================================================================
   

   ;=================== overriding isr 9 for ballon pop purpose  ===========================
    xor ax , ax
    mov es ,ax
    mov ax , [es:9*4 ]
    mov word[cs:oldisr1] , ax
    mov ax , [es:9*4 + 2 ]
    mov word[cs:oldisr1 + 2] , ax

    cli
        mov word [es:9*4] , key_stroke
        mov  [es:9*4+2] , cs
    sti
    
    ;========================================================================================


    ;==============================================loop started===============================================

  mov si , 0
  mov di ,0
   

 looop1:

  ;-------------------------placing the tile on its starting position ---------------------
  mov ah , 0
  
  
  mov bx  , si
  shr bx , 1
  ; run only at even si index as we are processing in word array 
  ;and this is done to add delay in bubbles appearaing from the bottom

  jc no_run  
  ;drawing box     
  mov al , byte[location + si]
  push ax
  mov al , byte[location + si + 1]
  push ax
  call drawRec
  ; placing alphabet in that box
  mov al , byte[alphabtes1 + si]
  push ax
  mov al , byte[loc_alpha + si]
  push ax
  mov al , byte[loc_alpha + si + 1]
  push ax
  call temp_func
  add word[balls_count] , 1  ; keeping track of  total balls appeared from screen below
  

  ;---------------------------------------------------------
  ; pushing that box location in 'on_screen_loc' array for its popping purposes
  mov bl , [location + si]

  mov bh , [location + si + 1]

  mov ax , on_screen_loc
  push ax
  push bx
  call pushing

  ; pushing corresponding alphabet in 'on_screen_alpha' array for searching purposes i.e searching 
  ; the alphabet presed in order to pop that ballon

  mov ax , on_screen_alpha
  push ax
  push word[alphabtes1 + si]
  call pushing

  ; as we are using the concept of queue in pushing function using arrays on_screen_loc and 
  ;on_screen_alpha , so if index reaches to end of array then we have to reset it 

  add word[index] ,2
  cmp word[index] , 22
  jne carry_on
  mov word[index] , 0

  carry_on:
  ; mainting the count so that we could keep track the number of boxes on the screen . normally 11 but at start varying
  cmp byte[count] , 11
  je no_run
  add byte[count] , 1  
  ;-----------------------------------------------------------------------------------
 
  no_run:
  ; scrolling the screen for floating purposes
  
  mov Ah , 06h   ; subservice to scroll up
  mov AL , 1     ; pages to scroll
  mov bh ,0x06
  mov  cx ,0     ; starting coordinate of screen
  mov dh , 199   ; ending x coordinate
  mov dl , 255   ; ending y coordinate
  int  0x10

  ; decrementing the locations pushed in array after every scroll as
  ; by scrolling each box y pos will be decremented by 8

  push word[count]
  call decrementer 


  ; printing at every scroll so tha we could get 
  ;theillusion that our score and time srtings are not moving they are in sem place
  call print_msg_time 

  
  
  add si , 1
  
  ;--- when we have traversed all our array then change the alhpabets
  ; and made si to point to the start of the array
  cmp si , 22
  jne continue
  
  mov si ,0
  call maintainer   ; changing the alphabet resdingin in alphabets array in order to produce some random effect
  call print_msg_time

 continue:
  call Big_Sleep     ;sleep function to decrease the speed
  call print_msg_time 


  cmp byte[min] , 1
  
  jnz looop1

  

  ;==========================================loop ended ===========================================

  call print_msg_time
  
  ;----------------- not working code -----------------------------------------------
   call Big_Sleep
   call Big_Sleep
   call Big_Sleep
   call Big_Sleep
   call Big_Sleep
   call Big_Sleep

  ;reseting the screen mode and again moving to graphics mode 
   mov  ax, 0x0003
   int  0x10
   mov  ax, 0x000D
   int  0x10
  
  ; displaying the result
  call result

  ;-----------------------------------------------------------------------------------------
  ;====================================== Unhooking isr 8 =========================================
  mov ax , 0
  mov es , ax
  mov ax, [oldisr]
  mov bx, [oldisr+2]
  cli
  mov [es:8*4], ax
  mov [es:8*4+2], bx
  sti

  ;====================================== Unhooking isr 9 =============================
  xor ax , ax
  mov es, ax
  mov ax, [oldisr1]
  mov bx, [oldisr1+2]
  cli
      mov [es:9*4], ax
      mov [es:9*4+2], bx
  sti
  
  ; waiting to end the game
  mov  ah, 0
  int  0x16
  ; resset the screen mode
  mov  ax, 0x0003
  int  0x10
  ;================================ ------------------------------- ======================
  ; finish
  mov  ax, 0x4c00
  int  0x21