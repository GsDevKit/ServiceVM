printing
printOn: aStream
  aStream nextPutAll: 'The time in London is '.
  self timeInLondon isNil
    ifTrue: [ aStream nextPutAll: 'not calculated yet.' ]
    ifFalse: [ aStream nextPutAll: self timeInLondon printString ]