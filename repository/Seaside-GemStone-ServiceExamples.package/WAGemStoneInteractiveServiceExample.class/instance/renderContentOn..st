rendering
renderContentOn: html
  workUnit hasError
    ifTrue: [ 
      html heading: 'Error'.
      html text: workUnit errorFlag ]
    ifFalse: [ 
      workUnit ready
        ifTrue: [ 
          html heading: 'Ready.'.
          html anchor
            callback: [ self blockingStep ];
            with: 'Blocking ' , workUnit label.
          html text: ', or '.
          html anchor
            callback: [ self nonBlockingStep ];
            with: 'Non-blocking ' , workUnit label ]
        ifFalse: [ 
          html heading: 'Not Ready '.
          html text: workUnit label , '. Refresh to check status, or '.
          html anchor
            callback: [ self blockingStep ];
            with: 'block until step is complete' ] ]