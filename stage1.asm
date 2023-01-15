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
      HALT
//
//
      .Align 128
codemaker: .BLOCK 128
codebreaker: .BLOCK 128
codeMakerPrompt: .ASCIZ "Enter Codemaker's Name:\n"
codeBreakerPrompt: .ASCIZ "Enter Codebreaker's Name:\n"
maxGuessPrompt: .ASCIZ "Enter number of guesses codebreaker gets:\n"
repeatCodeBreaker: .ASCIZ "\nCodebreaker is "
repeatCodeMaker: .ASCIZ "\nCodemaker is "
repeatMaxGuess: .ASCIZ "\nMaximum number of guesses: "
