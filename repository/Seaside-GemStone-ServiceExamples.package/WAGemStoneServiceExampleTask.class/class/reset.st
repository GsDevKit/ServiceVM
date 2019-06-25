accessing
reset
  inProcess := queue := nil.
  System sharedCounter: self sharedCounterIndex setValue: 1.
  System persistentCounterAt: self idIndex put: 0