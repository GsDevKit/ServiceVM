serviceVM tasks
serviceVMTaskServiceExample
  "WAGemStoneServiceExampleTask initialize"

  ^ self
    name: 'Service VM Example'
    frequency: 1
    valuable: [ :vmTask | 
      | persistentCounterValue |
      (self outstandingRequests < 100
        and: [ 
          (persistentCounterValue := WAGemStoneServiceExampleTask sharedCounterValue)
            > vmTask state ])
        ifTrue: [ 
          | tasks repeat |
          repeat := true.
          [ repeat and: [ self outstandingRequests < 100 ] ]
            whileTrue: [ 
              repeat := false.
              tasks := #().
              GRPlatform current
                doTransaction: [ 
                  WAGemStoneServiceExampleTask queue size > 0
                    ifTrue: [ 
                      vmTask state: persistentCounterValue.
                      tasks := WAGemStoneServiceExampleTask queue
                        removeCount: 10.
                      WAGemStoneServiceExampleTask inProcess addAll: tasks ] ].
              tasks do: [ :task | [ task processStep ] fork ].
              repeat := tasks size > 0
                ifTrue: [ 
                  (GRPlatform current
                    doTransaction: [ WAGemStoneServiceExampleTask queue size > 0 ])
                    and: [ self outstandingRequests < 100 ] ]
                ifFalse: [ false ] ] ] ]
    reset: [ :vmTask | vmTask state: 0 ]	" run once per 200ms"