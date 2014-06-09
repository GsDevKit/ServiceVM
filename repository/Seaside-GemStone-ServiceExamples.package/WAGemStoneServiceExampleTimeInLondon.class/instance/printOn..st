printing
printOn: aStream
  aStream nextPutAll: 'The time in London is '.
  self timeInLondon isNil
    ifTrue: [ aStream nextPutAll: 'not available, yet.' ]
    ifFalse: [ aStream nextPutAll: self timeInLondon printString ]