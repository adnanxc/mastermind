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
      BL getcode
      HALT
//
//
      .Align 128
codemaker: .BLOCK 128
codebreaker: .BLOCK 128
code: .BLOCK 128
codeMakerPrompt: .ASCIZ "Enter Codemaker's Name:\n"
codeBreakerPrompt: .ASCIZ "Enter Codebreaker's Name:\n"
maxGuessPrompt: .ASCIZ "Enter number of guesses codebreaker gets:\n"
repeatCodeBreaker: .ASCIZ "\nCodebreaker is "
repeatCodeMaker: .ASCIZ "\nCodemaker is "
repeatMaxGuess: .ASCIZ "\nMaximum number of guesses: "
codePrompt: .ASCIZ "\nEnter a code: "
invalidCode: .ASCIZ "\nInvalid code. You can only use 4 from r g b y p c"
codeSuccess: .ASCIZ "\nCode successful"
//
//
//FUNCTIONS:
getcode: 
      MOV R0, #codePrompt
      STR R0, .WriteString
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
continue:
      CMP R1, #5
      BNE error
      MOV R1, #codeSuccess
      STR R1, .WriteString
      RET
error:
      MOV R0, #invalidCode //invalid code
      STR R0, .WriteString
      B getcode
