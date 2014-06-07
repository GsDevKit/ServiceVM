"serviceExample --status"
| dict taskClass |
taskClass := WAGemStoneServiceExampleTask.
dict := Dictionary new
  at: 'queue' put: taskClass queue;
  at: 'inProcess' put: taskClass inProcessCollection;
  at: 'errors' put: taskClass instanceErrors;
  at: 'instances' put: taskClass instanceCollection;
  at: 'high water' put: taskClass idHighWater;
yourself.
dict explore.

"serviceExample --reset"
| taskClass |
taskClass := WAGemStoneServiceExampleTask.
taskClass reset.

"serviceExample --task[=<task-id>]"
| taskClass task taskId |
taskClass := WAGemStoneServiceExampleTask.
taskId := nil. "or integer task id"
taskId 
  ifNil: [ task := taskClass new ]
  ifNotNil: [
    System commit.
    task := taskClass instanceWithId: taskId ].
task explore.

"serviceExample --task=<task-id> --addToQueue"
| taskClass task taskId |
taskClass := WAGemStoneServiceExampleTask.
taskId := 1.
System commit.
task := taskClass instanceWithId: taskId.
task addToQueue.
System commit.

"serviceExample --task=<task-id> --poll=limit"
| taskClass task taskId limit count |
taskClass := WAGemStoneServiceExampleTask.
taskId := 1.
System commit.
task := taskClass instanceWithId: taskId.
task addToQueue.
limit := 10.
count := 0.
[ task finishedStep not and: [ count <= limit ] ]
  whileTrue: [ 
    (Delay forSeconds: 1) wait.
    System abort.	"so that service vm can see new queue entry"
    count := count + 1 ].
System abort.
task finishedStep
  ifTrue: [ task ]
  ifFalse: [ task -> ('not finished after ' , count printString , ' seconds') ]

