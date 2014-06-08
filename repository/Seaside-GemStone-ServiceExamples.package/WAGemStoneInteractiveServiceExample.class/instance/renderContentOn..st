rendering
renderContentOn: html
  workUnit hasError
    ifTrue: [ 
      html heading: 'Error'.
      html text: workUnit errorFlag ]
    ifFalse: [ 
      workUnit ready
        ifTrue: [ 
          "task READY to start next step ==================="
          html heading: 'Ready.'.
          html anchor
            callback: [ 
                  "BLOCKING addToQueue  ====================
                     Control not returned to user until
                     the task is finished"
                  self blockingStep ];
            with: 'Blocking ' , workUnit label.
          html text: ', or '.
          html anchor
            callback: [ 
                  "NON-BLOCKING addToQueue  ================
                     Control is immediately returned to user
                     and the user must manually poll by
                     refreshing the page, until the task is
                     finished"
                  self nonBlockingStep ];
            with: 'Non-blocking ' , workUnit label ]
        ifFalse: [ 
          "task NOT READY to start next step ===============
             part of manual poll by user"
          html heading: 'Not Ready '.
          html text: workUnit label , '. Refresh to check status, or '.
          html anchor
            callback: [ self blockingStep ];
            with: 'block until step is complete' ] ]