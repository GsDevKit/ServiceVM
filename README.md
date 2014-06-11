ServiceVM
=========

This project provides example code for creating and using a 
separate GemStone vm for processing long running operations from a Seaside HTTP request.

As described in [Porting Application-Specific Seaside Threads to GemStone][6], it is not 
advisable to fork a thread to handle a long running operation in a GemStone vm. 
Several years ago, [Nick Ager asked the question (in essense)][5]:

> So what do you expect us to do instead?

to which I replied:

> The basic idea is that you create a separate gem that services tasks 
> that are put into an RCQueue (multiple producers and a single consumer). 
> The gem polls for tasks in the queue, performs the task, then  finishes 
> the task, storing the results in the task....On the Seaside side you 
> would use HTML redirect (WADelayedAnswerDecoration) while waiting for 
> the task to be completed. 

That is quite a mouthful, so let's break it down:

1. [ServiceVM gem](#servicevm-gem)
2. [Service task](#service-taks) 
4. [Seaside integration](#seaside-integration)

## ServiceVM gem
For a service gem, we havetwo problems:

* [How do we start and stop a service vm?](#gem-control)
* [How do we define the service vm service loop?](#service-loop)	

###Gem control
Fortunately, Paul DeBruicker solved both of these problems
Back in 2011. He created a [couple of classes (WAGemStoneRunSmalltalkServer &   
WAGemStoneSmalltalkServer)][33] and wrote two bash scripts 
([runSmalltalkServer][34] and [startSmalltalkServer][35]) that
make it possible to start and run a ServiceVM gem for the purpose of executing long
running operations. The idea is similar the one used to 
[control Seaside web server gems][36], but generalized
to allow for starting gems that run an arbitrary service loop.

You can register a server class (in this case **WAGemStoneServiceExampleVM**) with
the class **WAGemStoneRunSmalltalkServer**:

```Smalltalk
WAGemStoneRunSmalltalkServer
   addServerOfClass: WAGemStoneServiceExampleVM
   withName: 'ServiceVM-ServiceVM'
   on: #().
```

and control the gem with these expressions:

```Smalltalk
"serviceVM --start"
| server serviceName |
serviceName := 'ServiceVM-ServiceVM'.
server := WAGemStoneRunSmalltalkServer serverNamed: serviceName.
WAGemStoneRunSmalltalkServer startGems: server.

"serviceVM --stop"
| server serviceName |
serviceName := 'ServiceVM-ServiceVM'.
server := WAGemStoneRunSmalltalkServer serverNamed: serviceName.
WAGemStoneRunSmalltalkServer stopGems: server.
```

### Service Loop
The service vm's service loop is responsible for keeping
an eye on the queue of service tasks, pluck tasks from the 
queue when they become available then fork a thread in which the task will perform it's work.

The main loop wakes up every 200ms and services the task queue:

```Smalltalk
serviceLoop
  | count |
  count := 0.
  [ true ]
    whileTrue: [ 
     self performTasks: count.             "service the task queue"
      (Delay forMilliseconds: 200) wait.   "Sleep for a 200ms"
      count := count + 1 ] 
```

In the **WAGemStoneMaintenanceTask** infrastructure, the *performTask:* message above ends up
evaluating the block defined below:

```Smalltalk
serviceVMServiceTaskQueue
  ^ self
    name: 'Service VM Loop'
    frequency: 1
    valuable: [ :vmTask | 
"1. CHECK FOR TASKS IN QUEUE (non-transactional)"
      (self serviceVMTasksAvailable: vmTask)
        ifTrue: [ 
          | tasks repeat |
          repeat := true.
"2. PULL TASKS FROM QUEUE UNTIL QUEUE IS EMPTY OR 100 TASKS IN PROGRESS"
          [ repeat and: [ self serviceVMTasksInProcess < 100 ] ]
            whileTrue: [ 
              repeat := false.
              GRPlatform current
                doTransaction: [ 
"3. REMOVE TASKS FROM QUEUE..."
                  tasks := self serviceVMTasks: vmTask ].
              tasks do: [ :task |
"4. ...FORK BLOCK AND PROCESS TASK" 
                [ task processTask ] fork ].
              repeat := tasks notEmpty ] ] ]
    reset: [ :vmTask | vmTask state: 0 ]
```

From a GemStone perspective, it is important to note that only the **serviceVMTasks:** method
is performed from within the transaction mutex ([GRGemStonePlatform>>doTransaction:][37]). 
There are many concurrent threads running within the service vm, so all threads running 
must take care to hold the transaction mutex for as short a time as possible. Also when 
running "outside of transaction" one must be aware that any persistent state may change
at transaction boundaries initiated by threads other than your own so one must use discipline
within your application to either:

* avoid changing the state of persistent objects used in service vm
* or, copy any state from *unsafe* persistent objects into temporary variables
  or *private* persistent objects.

Speaking of **serviceVMTasks:**, here's the implementation:

```Smalltalk
serviceVMTasks: vmTask
  | tasks persistentCounterValue |
  tasks := #().
  persistentCounterValue := WAGemStoneServiceExampleTask sharedCounterValue.
  WAGemStoneServiceExampleTask queue size > 0
    ifTrue: [ 
      vmTask state: persistentCounterValue.
      tasks := WAGemStoneServiceExampleTask queue removeCount: 10.
      WAGemStoneServiceExampleTask inProcess addAll: tasks ].
  ^ tasks
```

## Service task
The service task is an instance of **WAGemStoneServiceExampleTask** and takes a *valuable* 
(e.g., a block or any object that responds to *value*):

```Smalltalk
WAGemStoneServiceExampleTask valuable: [ 
  (HTTPSocket
    httpGet: 'http://www.time.org/zones/Europe/London.php')
    throughAll: 'Europe/London - ';
    upTo: Character space ].
```

or:

```Smalltalk
WAGemStoneServiceExampleTask 
  valuable: (WAGemStoneServiceExampleTimeInLondon 
           url: 'http://www.time.org/zones/Europe/London.php').
```


The *processTask* method in **WAGemStoneServiceExampleTask** is implemented as follows: 

```Smalltalk
processTask
  | value |
  self performSafely: [ value := taskValuable value ].
  GRPlatform current
    doTransaction: [ 
      taskValue := value.
      hasValue := true.
      self class inProcess remove: self ]
```


## Seaside integration


## ServiceVM Example

Recently I've brought the original example code over to github, simplified it a bit, 
made sure it works with [GemStone 3.2][28], [Seaside 3.1][29], [Zinc][30], and created a 
collection of [tODE][27] support scripts.


For GLASS the solution is to create a separate Service gem that services performs stashed in an RCQueue. RCQueues are conflict free with multiple producers and a single consumer - exactly our case.

###Installation

Clone the https://github.com/glassdb/ServiceVM repository to your local disk and 
install the scripts needed by the service vm in the $GEMSTONE product tree (make 
sure you have $GEMSTONE defined before running the installScripts.sh step):

```shell
cd /opt/git                                     # root dir for git repository
git clone git@github.com:glassdb/ServiceVM.git  # clone service vm
cd ServiceVM
bin/installScripts.sh                           # $GEMSTONE must be defined
```

Install the service vm artifacts in tODE and load the example code (at the tODE 
command prompt):

```Shell
mount /opt/git/ServiceVM/tode /home serviceVM  # mount tODE dir at /home/serviceVM
edit README.md                                 # edit README (this file) in tODE
project load @/home/serviceVM                  # load the project into the image
```

_**_*[`project load @/home/serviceVM`][10] for non-tode users*

###Service VM Example

Overview of tODE commands used in example:
  ```Shell
  ./webServer --register=zinc   # register zinc as web server (done once)
  ./webServer --start           # start web server gem
  ./webServer --stop            # stop web server gem

  ./serviceVM --register        # register the service vm (done once)
  ./serviceVM --start           # start the service vm gem
  ./serviceVM --stop            # stop the service vm gem

  ./serviceExample --reset                # clear service task queues and counters
  ./serviceExample --status               # state of service task engine
  ./serviceExample --task                 # create a new task
  ./serviceExample --task=3               # access task #3
  ./serviceExample --task=3 --addToQueue  # schedule task #3 to process next step
  ./serviceExample --task=3 --poll=10     # poll for completion of task #3 (wait 10 seconds)
  ```

See [webServer][19], [serviceVM][13], or [serviceExample][8] 
for the Smalltalk source for each of the tODE scripts.

Start serviceVM gem (at tODE command line):

  ```Shell
  cd /home/serviceVM
  ./serviceVM --register # only done once
  ./serviceVM --start
  ```

_**_*[`serviceVM --register`][11]
[`serviceVM --start`][14]*

**NOTE**: *If you are using tODE and you have opened this README.md file
in tode, you can use the `tode it` menu item to run the tODE commands form the README.md
file. If you
are not using tODE, the link following the tODE commands
takes you to the script source and highlights the code that is executed by
the command.*

####Service VM loop
XXXXXXXXX
You can view the state of service example with the `serviceExample` script. The following:

```Shell
./serviceExample --status
```

_**_*[`serviceExample --status`][12]*

produces an inspector on the key state of the service vm:

```
.        -> aDictionary( 'instances'->aDictionary( ), 'high water'->0, 'queue'->anArray( ), 'inProcess'->anArray( ), 'service loop'->Service VM Loop)
(class)@ -> Dictionary
(oop)@   -> 329195777
1@       -> 'high water'->0
2@       -> 'inProcess'->anArray( )
3@       -> 'instances'->aDictionary( )
4@       -> 'queue'->anArray( )
5@       -> 'service loop'->Service VM Loop
```

`high water` is the count of service vm tasks created. 

`inProcess` is a list of service vm tasks that have been removed from queue and are being serviced, but 
have not completed processing, yet. 

'instances' is a dictionary in UserGlobals that keeps track of all of the tasks created by the serviceVM script. 

`queue` is a list of the service vm tasks that 
are stacked ubrp waiting to be processed. 

`service loop` is the vm task instance.

####Example Task Life Cycle
In this example the [task][3] is going to get the time in London using the url: 
*http://www.time.org/zones/Europe/London.php*:


```Smalltalk
WAGemStoneServiceExampleTask 
  valuable: (WAGemStoneServiceExampleTimeInLondon 
           url: 'http://www.time.org/zones/Europe/London.php').
```

Since the task is hitting the web, you aren't able to predict how quickly the time server
will respond, so we will schedule the task to be executed in the [service vm][9]. 

Let's start by creating and viewing a task:

```Shell
./serviceExample --task; edit
```

_**_*[`./serviceExample --task`][16]*


and here's the state of the freshly created task instance:

```
.             -> task: #1 (not finished)
(class)@      -> WAGemStoneServiceExampleTask
(oop)@        -> 329145089
exception@    -> nil
hasValue@     -> nil
id@           -> 1
taskValuable@ -> The time in London is not available, yet.
taskValue@    -> nil
```

Shows that the *task #1* does not have a taskValue and the **taskValuable**
prints as `The time in London is not available, yet.`. 
Here's a peek at the **taskValuable** itself:

```
.             -> The time in London is not available, yet.
..            -> task: #1 (not finished)
(class)@      -> WAGemStoneServiceExampleTimeInLondon
(oop)@        -> 329139457
timeInLondon@ -> nil
url@          -> 'http://www.time.org/zones/Europe/London.php'
```

Now add the task to the serviceVM queue and wait for the task to be completed

```Shell
./serviceExample --task=1 --addToQueue --poll; edit
```

_**_*[`./serviceExample --task=1`][16]
[`./serviceExample --addToQueue`][17]
[`./serviceExample --poll`][18]*

and view the new state:

```
.             -> task: #1 (hasValue: '4:21')
(class)@      -> WAGemStoneServiceExampleTask
(oop)@        -> 329145089
exception@    -> nil
hasValue@     -> true
id@           -> 1
taskValuable@ -> The time in London is '4:21'
taskValue@    -> '4:21'
```

peek at the service vm state:

```Shell
./serviceExample --status
```

_**_*[`serviceExample --status`][12]*

which will look something like the following:

```
.        -> aDictionary( 'instances'->aDictionary( 1->task: #1 (hasValue: '4:21')), 'high water'->1, 'queue'->anArray( ), 'inProcess'->anArray( ), 'serv...
(class)@ -> Dictionary
(oop)@   -> 329536513
1@       -> 'high water'->1
2@       -> 'inProcess'->anArray( )
3@       -> 'instances'->aDictionary( 1->task: #1 (hasValue: '4:21'))
4@       -> 'queue'->anArray( )
5@       -> 'service loop'->Service VM Loop
```

####Seaside Example

Here's the render method (*WAGemStoneInteractiveServiceExample>>renderContentOn:*)
for the ServiceVm example Seaside component:

```Smalltalk
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
                        ./serviceExample --task=1 --addToQueue --poll=10
                                        ====================
                     Control not returned to user until
                     the task is finished"
                  self blockingStep ];
            with: 'Blocking ' , workUnit label.
          html text: ', or '.
          html anchor
            callback: [ 
                  "NON-BLOCKING addToQueue  ================
                        ./serviceExample --task=1 --addToQueue
                                            ================
                     Control is immediately returned to user
                     and the user must manually poll by
                     refreshing the page, until the task is
                     finished"
                  self nonBlockingStep ];
            with: 'Non-blocking ' , workUnit label ]
        ifFalse: [ 
          "task NOT READY to start next step ===============
                        ./serviceExample --task=1 --poll=10
                                             ===============
             part of manual poll by user"
          html heading: 'Not Ready '.
          html text: workUnit label , '. Refresh to check status, or '.
          html anchor
            callback: [ self blockingStep ];
            with: 'block until step is complete' ] ]
```

Start webServer gem:

  ```Shell
  ./webServer --register=zinc --port=8383 # only done once
  ./webServer --start
  ```

_**_*[`webServer --register=zinc`][21]
[`webServer --start`][22]*

Hit the service vm example page:

```
http://localhost:8383/examples/serviceInteractive
```

which should look something like this:

![seaside service example browser picture][20]


####Shut down the Service gems

  ```Shell
  # stop gems
  ./webServer --stop
  ./serviceVM --stop
  ```

_**_*[`webServer ----stop`][23]
[`serviceVM --stop`][24]*

## Futures work by Nick Ager
Nick went on to create 
[his Future implementation][25] based on Ramon Leon's article 
[Smalltalk Concurrency, Playing With Futures][26]:

* Pharo-Future-NickAger.3.mcz
* Future-Seaside-Examples-NickAger.9.mcz

[1]: repository/Seaside-GemStone-ServiceTask.package/WAGemStoneServiceExampleVMTask.class/class/serviceVMTaskServiceExample.st#L18
[2]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceExampleVMTask.class/class/serviceLoop.st#L10
[3]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceExampleTask.class
[4]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceExampleVMTask.class/class/serviceVMTaskServiceExample.st#L22
[5]: http://forum.world.st/threads-within-a-request-td2335295.html#a2335295
[6]: http://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
[7]: https://github.com/dalehenrich/tode#tode-the-object-centric-development-environment-
[8]: docs/readme/serviceExample_todeScript.st
[9]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceExampleVM.class
[10]: docs/readme/projectLoad.st#L2-14
[11]: docs/readme/serviceVM_todeScript.st#L32-43                
<!--[11] serviceVM --register -->
[12]: docs/readme/serviceExample_todeScript.st#L69-81
<!--[12] serviceExample --status --> 
[13]: docs/readme/serviceVM_todeScript.st
[14]: docs/readme/serviceVM_todeScript.st#L45-47                
<!--[14] serviceVM --start -->
[16]: docs/readme/serviceExample_todeScript.st#L23-36
<!--[16] serviceExample --task -->
[17]: docs/readme/serviceExample_todeScript.st#L37-41
<!--[17] serviceExample --addToQueue -->
[18]: docs/readme/serviceExample_todeScript.st#L42-58
<!--[18] serviceExample --poll -->
[19]: docs/readme/webServer_todeScript.st
[20]: docs/readme/seasideServiceVMPage.png
[21]: docs/readme/webServer_todeScript.st#L32-49
<!--[21] /webServer --register -->
[22]: docs/readme/webServer_todeScript.st#L51-53
<!--[22] /webServer --start -->
[23]: docs/readme/webServer_todeScript.st#L59-61
<!--[22] /webServer --stop -->
[24]: docs/readme/serviceVM_todeScript.st#L53-55
<!--[24] serviceVM --stop -->
[25]: http://www.squeaksource.com/Futures/
[26]: http://onsmalltalk.com/smalltalk-concurrency-playing-with-futures
[27]: https://github.com/dalehenrich/tode#tode-the-object-centric-development-environment-
[28]: http://gemtalksystems.com/index.php/news/version3-2/
[29]: https://github.com/glassdb/Seaside31
[30]: https://github.com/glassdb/zinc
[31]: http://gemstonesoup.wordpress.com/2008/03/09/glass-101-simple-persistence/
[32]: https://github.com/glassdb/ServiceVM/issues/3
[33]: http://forum.world.st/Issue-320-in-glassdb-Clean-up-WAGemStoneRunSmalltalkServer-amp-WAGemStoneSmalltalkServer-scripts-td4120578.html
[34]: bin/runSmalltalkServer
[35]: bin/startSmalltalkServer
[36]: https://code.google.com/p/glassdb/wiki/ControllingSeaside30Gems
[37]: https://github.com/glassdb/Grease/blob/master/repository/Grease-GemStone-Core.package/GRGemStonePlatform.class/instance/doTransaction..st
