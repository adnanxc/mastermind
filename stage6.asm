//R11 dedicated register for max guesses
//
//INPUT NAMES AND ATTEMPTS
//
//codemaker
      MOV R0, #codeMakerPrompt 
      STR R0, .WriteString
      MOV R0, #codemaker 
      STR R0, .ReadString
//
//codebreaker
      MOV R0, #codeBreakerPrompt 
      STR R0, .WriteString
      MOV R0, #codebreaker 
      STR R0, .ReadString
//
//attempts
      MOV R0, #maxGuessPrompt 
      STR R0, .WriteString //asking for max number of guesses
      LDR R11, .InputNum //storing max guesses in dedicated reg R11
//
//OUTPUT NAMES AND ATTEMPTS
//
//codemaker
      MOV R0, #repeatCodeBreaker 
      STR R0, .WriteString
      MOV R0, #codebreaker 
      STR R0, .WriteString
//
//codebreaker
      MOV R0, #repeatCodeMaker 
      STR R0, .WriteString
      MOV R0, #codemaker 
      STR R0, .WriteString
//
//attempts
      MOV R0, #repeatMaxGuess 
      STR R0, .WriteString
      STR R11, .WriteUnsignedNum
      MOV R0, #lineBreak
//
//ENTER SECRET CODE
//
      STR R0, .WriteString
      MOV R0, #codemaker
      STR R0, .WriteString
      MOV R0, #secretCodePrompt
      STR R0, .WriteString
      MOV R0, #secretcode
      BL getcode
//
//QUERY CODE LOOP
//
      MOV R10, #0       //Dedicated register to increment pixel number to next line
queryloop:
//display no. of remaining attempts
      MOV R1, #lineBreak
      STR R1, .WriteString
      MOV R1, #codebreaker
      STR R1, .WriteString
      MOV R1, #guessNumber 
      STR R1, .WriteString
      STR R11, .WriteUnsignedNum
//input query code
      MOV R0, #querycode
      BL getcode
      STR R0, .WriteString
      MOV R1, R10
      BL displaycode
      MOV R10, R1
//compare query code and secret code
      MOV R2, #secretcode
      MOV R3, #querycode
      BL comparecodes
//print matches
      MOV R2, #positionMatch
      STR R2, .WriteString
      STR R0, .WriteUnsignedNum
      MOV R2, #colourMatch
      STR R2, .WriteString
      STR R1, .WriteUnsignedNum
//check if 4 exact matches, if not then skip over the win messages
      CMP R0, #4
      BLT jump
//win messages
      MOV R0, #lineBreak
      STR R0, .WriteString
      MOV R0, #codebreaker
      STR R0, .WriteString
      MOV R0, #winMessage
      STR R0, .WriteString
      B gameover
//check if there are attempts remaining, if not then print lose messages
jump:
      SUB R11, R11, #1
      CMP R11, #0
      BGT queryloop
      MOV R0, #lineBreak
      STR R0, .WriteString
      MOV R0, #codebreaker
      STR R0, .WriteString
      MOV R0, #loseMessage
      STR R0, .WriteString
//game over messages
gameover:
      MOV R0, #gameOver
      STR R0, .WriteString
      HALT
//
//
      .Align 128
codemaker: .BLOCK 128
codebreaker: .BLOCK 128
code: .BLOCK 128
secretcode: .BLOCK 128
querycode: .BLOCK 128
codeMakerPrompt: .ASCIZ "Enter Codemaker's Name:\n"
codeBreakerPrompt: .ASCIZ "Enter Codebreaker's Name:\n"
maxGuessPrompt: .ASCIZ "Enter number of guesses codebreaker gets:\n"
repeatCodeBreaker: .ASCIZ "\nCodebreaker is "
repeatCodeMaker: .ASCIZ "\nCodemaker is "
repeatMaxGuess: .ASCIZ "\nMaximum number of guesses: "
codePrompt: .ASCIZ "\nEnter a code: "
invalidCode: .ASCIZ "\nInvalid code. You can only use 4 from r g b y p c"
codeSuccess: .ASCIZ "\nCode successful"
lineBreak: .ASCIZ "\n"
secretCodePrompt: .ASCIZ ", please enter a 4-character secret code"
guessNumber: .ASCIZ ", this is guess number: "
positionMatch: .ASCIZ "\nPosition matches: "
colourMatch: .ASCIZ ", Colour matches: "
winMessage: .ASCIZ ", you WIN!"
loseMessage: .ASCIZ ", you LOSE!"
gameOver: .ASCIZ "\n\nGame Over!"
//
//
//FUNCTIONS:
//
//function to get code
//
getcode:                //paramter R0 to store code
      MOV R1, #codePrompt
      STR R1, .WriteString
      STR R0, .ReadString
      MOV R1, #0        //count of characters
validate:
      LDRB R2, [R0+R1]
      ADD R1, R1, #1
      CMP R2, #0        //check if char is null (end)
      BEQ continue
      CMP R2, #114      //check if char is r
      BEQ validate
      CMP R2, #103      //check if char is g
      BEQ validate
      CMP R2, #98       //check if char is b
      BEQ validate
      CMP R2, #121      //check if char is y
      BEQ validate
      CMP R2, #112      //check if char is p
      BEQ validate
      CMP R2, #99       //check if char is c
      BEQ validate
      B error
error:
      MOV R1, #invalidCode //invalid code
      STR R1, .WriteString
      B getcode
continue:
      CMP R1, #5
      BNE error
      RET
//
//funtion to compare secretcode and querycode
//
comparecodes:           //parameter r2 secretcode and r3 querycode
      PUSH {R4, R5, R6, R7, R8}
      MOV R0, #0        //Case 1 exact match
      MOV R1, #0        //Case 2 colour match
      MOV R4, #0        //querycode index
//FIRST LOOP
loop1:                  //for each character in the querycode
      LDRB R6, [R3+R4]  //storing character from querycode
      MOV R7, #0
//SECOND LOOP
loop2:                  //secretcode index 
      LDRB R8, [R2+R7]  //storing character from secretcode
      CMP R8, R6
      PUSH {LR}
      MOV LR, PC
      BEQ checkindex
      POP {LR}
      ADD R7, R7, #1
      CMP R7, #4
      BLT loop2
      ADD R4, R4, #1
      CMP R4, #4
      BLT loop1
      POP {R4, R5, R6, R7, R8}
      RET
checkindex:
      CMP R4, R7
      BEQ case1
      ADD R1, R1, #1
      RET
case1:
      ADD R0, R0, #1
      RET
//
//function to graphically display query code
//
displaycode:            //parameter r0 querycode r1 increment to next line
      PUSH {R4}
      MOV R2, #.PixelScreen //load first pixel
      ADD R2, R1, R2    //jump to correct line
      MOV R4, #0        //index
pixelloop:
      LDRB R3, [R0+R4]  //store char in R3
      CMP R3, #114      //check if char is r
      BEQ red
      CMP R3, #103      //check if char is g
      BEQ green
      CMP R3, #98       //check if char is b
      BEQ blue
      CMP R3, #121      //check if char is y
      BEQ yellow
      CMP R3, #112      //check if char is p
      BEQ purple
      CMP R3, #99       //check if char is c
      BEQ cyan
      CMP R3, #0        //check if char is null (end)
      ADD R1, R1, #256
      POP {R4}
      RET
red:
      MOV R3, #.red
      B draw
//
green:
      MOV R3, #.green
      B draw
//
blue:
      MOV R3, #.blue
      B draw
//
yellow:
      MOV R3, #.yellow
      B draw
//
purple:
      MOV R3, #.purple
      B draw
//
cyan:
      MOV R3, #.cyan
      B draw
//
draw:
      STR R3, [R2]
      ADD R2, R2, #4
      ADD R4, R4, #1
      B pixelloop
