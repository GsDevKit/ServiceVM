actions
go: cycle
	"poll until step is completed"

	self 
		call: (WAComponent new
			addMessage: 'waiting to ', workUnit label, '...(', cycle printString, ')';
			addDecoration: (WADelayedAnswerDecoration new delay: 2);
			yourself)
		onAnswer: [	
			workUnit ~~ nil 
				ifTrue: [ workUnit finishedStep ifFalse: [ self go: cycle + 1 ]]]