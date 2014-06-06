rendering
renderContentOn: html

	workUnit finishedStep 
		ifTrue: [
			html heading: 'Status'.
			html text: workUnit label, ' (', workUnit id asString, ')'.
			workUnit errorFlag ~~ nil
				ifTrue: [ html break; text: 'ERROR: ', workUnit errorFlag ].
			workUnit step1 ~~ nil
				ifTrue: [ html break; text: 'step1: ', workUnit step1 asString ].
			workUnit step2 ~~ nil
				ifTrue: [ html break; text: 'delay: ', workUnit step2 asString ].
			workUnit step3 ~~ nil
				ifTrue: [ html break; text: 'delay: ', workUnit step3 asString ].
				]
		ifFalse: [  html heading: 'waiting to ', workUnit label, ' (', workUnit id asString, ')' ]