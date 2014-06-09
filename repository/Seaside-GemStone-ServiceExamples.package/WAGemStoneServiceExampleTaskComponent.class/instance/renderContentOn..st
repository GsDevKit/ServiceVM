rendering
renderContentOn: html
  | autoLabel manualLabel |
  task hasError
    ifTrue: [ 
      html heading: 'Error'.
      html text: task exception description ]
    ifFalse: [ 
      task hasValue
        ifTrue: [ 
          html heading: 'The time in London is: ' , task value , '.'.
          autoLabel := 'Try again and wait for result?'.
          manualLabel := 'Try again and manually poll for result (refresh page)?' ]
        ifFalse: [ 
          html heading: 'The time in London is not available, yet. '.
          autoLabel := 'Get time in London and wait for result?'.
          manualLabel := 'Get time in London and manually poll for result (refresh page)?' ].
      html anchor
        callback: [ self automaticPoll ];
        with: autoLabel.
      html text: ', or '.
      html anchor
        callback: [ self addTaskToQueue ];
        with: manualLabel ]