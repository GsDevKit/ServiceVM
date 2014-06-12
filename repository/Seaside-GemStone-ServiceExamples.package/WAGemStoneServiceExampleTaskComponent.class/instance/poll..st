actions
poll: cycle
  self
    call:
      (WAComponent new
        addMessage: 'waiting  for time in London...(' , cycle printString , ')';
        addDecoration: (WADelayedAnswerDecoration new delay: 2);
        yourself)
    onAnswer: [ 
      task hasValue
        ifFalse: [ self poll: cycle + 1 ] ]