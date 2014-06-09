accessing
queue
  queue == nil
    ifTrue: [ queue := RcQueue new: 100 ].
  ^ queue