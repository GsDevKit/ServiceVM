tests
testTimeInLondon
  | gemServer |
  gemServer := self gemServer.
  [ 
  | task |
  gemServer restartGems.
  (Delay forSeconds: 3) wait.
  task := WAGemStoneServiceExampleTask
    valuable:
      (WAGemStoneServiceExampleTimeInLondon
        url: 'http://www.time.org/zones/Europe/London.php').
  task addToQueue.
  System commitTransaction.
  [ 
  System abortTransaction.
  Transcript
    cr;
    show: task printString.
  System commitTransaction.
  task hasValue ]
    whileFalse: [ (Delay forSeconds: 2) wait ].
  self deny: task hasError.
  self assert: task value ~~ nil ]
    ensure: [ 
      gemServer stopGems.
      (Delay forSeconds: 3) wait ]