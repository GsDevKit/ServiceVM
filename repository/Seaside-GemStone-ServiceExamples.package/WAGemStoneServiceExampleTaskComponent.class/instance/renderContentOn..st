rendering
renderContentOn: html
  | autoLabel manualLabel createNewTask |
  createNewTask := false.
  task hasError
    ifTrue: [ 
      html heading: 'Error'.
      html text: task exception description ]
    ifFalse: [ 
      task hasValue
        ifTrue: [ 
          html heading: 'The time in London is: ' , task value , '.'.
          autoLabel := 'Try again and wait for result?'.
          manualLabel := 'Try again and manually poll for result (refresh page)?'.
          createNewTask := true ]
        ifFalse: [ 
          html heading: 'The time in London is not available, yet. '.
          autoLabel := 'Get time in London and wait for result?'.
          manualLabel := 'Get time in London and manually poll for result (refresh page)?' ].
      html anchor
        callback: [ 
              createNewTask
                ifTrue: [ task := self newTask ].
              self automaticPoll ];
        with: autoLabel.
      html
        break;
        text: ' or ';
        break.
      html anchor
        callback: [ 
              createNewTask
                ifTrue: [ task := self newTask ].
              self addTaskToQueue ];
        with: manualLabel ]