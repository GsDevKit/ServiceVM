printing
printOn: aStream
  aStream nextPutAll: 'task: #' , self id printString , ' ('.
  currentStep == nil
    ifTrue: [ aStream nextPutAll: 'not queued' ]
    ifFalse: [ 
      step1 == nil
        ifTrue: [ aStream nextPutAll: 'in step 1' ]
        ifFalse: [ 
          aStream nextPutAll: 'step 1: [' , self step1 printString , '] '.
          step2 == nil
            ifTrue: [ aStream nextPutAll: 'in step 2' ]
            ifFalse: [ 
              aStream nextPutAll: 'step 2: [' , self step2 printString , '] '.
              step3 == nil
                ifTrue: [ aStream nextPutAll: 'in step 3' ]
                ifFalse: [ aStream nextPutAll: 'finished: [' , self step3 printString , ']' ] ] ] ].
  errorFlag ~~ nil
    ifTrue: [ aStream nextPutAll: ' - ' , errorFlag ].
  aStream nextPutAll: ')'