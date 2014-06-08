ServiceVM
=========

The Service VM is intended to provide example code for creating and using a separate "Service VM" for offloading 
work that in a Squeak/Pharo Seaside application, you would have forked of a thread to do the work. 
See [Porting Application-Specific Seaside Threads to GemStone][6] and [threads within a request (a conversation between
Ni/ck Ager and I)][5] for more information.

The prototypical example would be to obtain a token from an external web-service (i.e., sending an HTTP request to obtain a token or other data). You would not want to defer the response to the user in this case, especially if the request can take several minutes to complete (or fail as the case may be).

## Futures work by Nick Ager
A Future implementation for Pharo with a package containing two Seaside examples to demonstrate a typical usage scenario.
Designed to be compatible with a GemStone future implementation.

The implementation is based on: http://onsmalltalk.com/smalltalk-concurrency-playing-with-futures:

* Pharo-Future-NickAger.3.mcz
* Future-Seaside-Examples-NickAger.9.mcz

## ServiceVM
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

Start serviceVM gem:

  ```Shell
  cd /home/serviceVM
  ./serviceVM --register # only done once
  ./serviceVM --start
  ```

_**_*[`serviceVM --register`][11]
[`serviceVM --start`][14] for non-tode users*

####Service VM loop

Every 200 ms the [service VM main thread wakes up][2] and [checks the queue for taks to process][1].
A thread is forked and each [task][3] is [scheduled to begin processing it's work][4]. When all of the oustanding tasks have been processed, the service VM main thread goes back to sleep.

You can view the state of service vm with the `serviceExample` script. The following:

```Shell
./serviceExample --status
```

_**_*[`serviceExample --status`][12] for non-tode users*

produces an inspector on the key state of the service vm:

```
.        -> aDictionary( 'instances'->anArray( task: #1 (not queued)), 'high water'->1, 'queue'->aRcQueue( ), 'inProcess'->anArray( ), 'errors'->anArray...
(class)@ -> Dictionary
(oop)@   -> 439999489
1@       -> 'errors'->anArray( )
2@       -> 'high water'->1
3@       -> 'inProcess'->anArray( )
4@       -> 'instances'->anArray( task: #1 (not queued))
5@       -> 'queue'->aRcQueue( )
```

`errors` is a list of service vm tasks that have produced errors while processing. `inProcess` is a list of service vm tasks that have not completed processing. `instances` is a list of all service vm tasks that have been created. `queue` is a list of the service vm tasks that are stacked up waiting to be processed.

####Example Task Life Cycle
In this example the [task][3] has three separate processing steps. 
Each step is performed separately by the [service vm][9]. 

Reset the example vm, then create and view a task:

```Shell
./serviceExample --task; edit
```

_**_*[`./serviceExample --task`][16] for non-tode users*

and here's the state of the freshly created task instance:

```
.            -> task: #1 (not queued)
(class)@     -> WAGemStoneServiceExampleTask
(oop)@       -> 424536577
currentStep@ -> nil
errorFlag@   -> nil
id@          -> 1
log@         -> anOrderedCollection( 'id'->2014-06-07T11:20:11.2864038944244-07:00)
step1@       -> nil
step2@       -> nil
step3@       -> nil
```

Now cycle through two of the three steps and view new state:

```Shell
./serviceExample --task=1 --addToQueue --poll=10
./serviceExample --task=1 --addToQueue --poll=10; edit
```

_**_*[`./serviceExample --task=1`][16]
[`./serviceExample --addToQueue`][17]
[`./serviceExample --poll=10`][18] for non-tode users*

and view the new state:

```
.            -> task: #1 (step 1: [anArray( )] step 2: [anArray( )] in step 3)
(class)@     -> WAGemStoneServiceExampleTask
(oop)@       -> 193992193
currentStep@ -> #'step2'
errorFlag@   -> nil
id@          -> 1
log@         -> anOrderedCollection( 'id'->2014-06-07T17:50:25.2372469902038-07:00, 'step1'->2014-06-07T17:50:41.896595954895-07:00, 'step2'->2014-06-07T17:...
step1@       -> anArray( )
step2@       -> anArray( )
step3@       -> nil
```

peek at the service vm state:

```Shell
./serviceExample --status
```

_**_*[`serviceExample --status`][12] for non-tode users*

which will look something like the following:

```
.        -> aDictionary( 'instances'->anArray( task: #1 (step 1: [anArray( )] step 2: [anArray( )] in step 3)), 'high water'->1, 'queue'->aRcQueue( ), '...
(class)@ -> Dictionary
(oop)@   -> 194661377
1@       -> 'errors'->anArray( )
2@       -> 'high water'->1
3@       -> 'inProcess'->anArray( )
4@       -> 'instances'->anArray( task: #1 (step 1: [anArray( )] step 2: [anArray( )] in step 3))
5@       -> 'queue'->aRcQueue( )
```

Cycle through the last step and view final state:

```Shell
./serviceExample --task=1 --addToQueue --poll=10; edit
```

_**_*[`./serviceExample --task=1`][16]
[`./serviceExample --addToQueue`][17]
[`./serviceExample --poll=10`][18] for non-tode users*

and view the new state:

```
.            -> task: #1 (step 1: [anArray( )] step 2: [anArray( )] finished: [anArray( )])
(class)@     -> WAGemStoneServiceExampleTask
(oop)@       -> 193992193
currentStep@ -> #'step3'
errorFlag@   -> nil
id@          -> 1
log@         -> anOrderedCollection( 'id'->2014-06-07T17:50:25.2372469902038-07:00, 'step1'->2014-06-07T17:50:41.896595954895-07:00, 'step2'->2014-06-07T17:...
step1@       -> anArray( )
step2@       -> anArray( )
step3@       -> anArray( )
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
[`webServer --start`][22] for non-tode users*

Hit the service vm example page:

```
http://localhost:8383/examples/serviceInteractive
```

which should look something like this:

![seaside service example browser picture][21]


####Shut down the Service gems

  ```Shell
  # stop gems
  ./webServer --stop
  ./serviceVM --stop
  ```

_**_*[`webServer ----stop`][23]
[`serviceVM --stop`][24] for non-tode users*

[1]: repository/Seaside-GemStone-ServiceTask.package/WAGemStoneServiceVMTask.class/class/serviceVMTaskServiceExample.st#L18
[2]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceVMTask.class/class/serviceLoop.st#L10
[3]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceExampleTask.class
[4]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceVMTask.class/class/serviceVMTaskServiceExample.st#L22
[5]: http://forum.world.st/threads-within-a-request-td2335295.html#a2335295
[6]: http://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
[7]: https://github.com/dalehenrich/tode#tode-the-object-centric-development-environment-
[8]: docs/readme/serviceExample_todeScript.st
[9]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceVM.class
[10]: docs/readme/projectLoad.st#L2-14
[11]: docs/readme/serviceVM.st#L1-8
[12]: docs/readme/serviceExample.st#L1-11
[13]: docs/readme/serviceVM_todeScript.st
[14]: docs/readme/serviceVM.st#L10-14
[15]: docs/readme/serviceExample.st#L13-16
[16]: docs/readme/serviceExample.st#L18-27
[17]: docs/readme/serviceExample.st#L29-36
[18]: docs/readme/serviceExample.st#L38-55
[19]: docs/readme/webServer_todeScript.st
[20]: docs/readme/seasideServiceVMPage.png
[21]: docs/readme/webServer.st#L1-9
[22]: docs/readme/webServer.st#L11-15
[23]: docs/readme/webServer.st#L17-21
[24]: docs/readme/serviceVM.st#L16-20
