accessing
reset
  inProcess := queue := nil.
  System _sharedCounter: self sharedCounterIndex setValue: 1.
  System persistentCounterAt: self idIndex put: 0