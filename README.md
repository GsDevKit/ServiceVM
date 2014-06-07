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

_**_*[`project load @/home/serviceVM` for non-tode users][10]*

###Service VM Example

Overview of tODE commands used in example:
  ```Shell
  ./webServer --register=zinc   # register zinc as web server (done once)
  ./webServer --start           # start web server gem
  ./webServer --stop            # stop web server gem

  ./serviceVM --register        # register the service vm (done once)
  ./serviceVM --start           # start the service vm gem
  ./serviceVM --stop            # stop the service vm gem

  ol view                       # tOde object log window 

  ./serviceExample --reset                # clear service task queues and counters
  ./serviceExample --status               # state of service task engine
  ./serviceExample --task                 # create a new task
  ./serviceExample --task=3               # access task #3
  ./serviceExample --task=3 --addToQueue  # schedule task #3 to process next step
  ./serviceExample --task=3 --poll=10     # poll for completion of task #3 (wait 10 seconds)
  ```

Start serviceVM gem:

  ```Shell
  cd /home/serviceVM
  ./serviceVM --register # only done once
  ./serviceVM --start
  ```

_**_*[`serviceVM --register` & `serviceVM --start` for non-tode users][11]*

####Service VM loop

Every 200 ms the [service VM main thread wakes up][2] and [checks the queue for taks to process][1].
A thread is forked and each [task][3] is [scheduled to begin processing it's work][4]. When all of the oustanding tasks have been processed, the service VM main thread goes back to sleep.

You can view the state of service vm with the `serviceExample` script. The following:

```Shell
./serviceExample --status
```

_**_*[`serviceExample --status` for non-tode users][12]*

produces an inspector on the key state of the service vm:

```
.        -> aDictionary( 'instances'->anArray( ), 'high water'->1, 'queue'->aRcQueue( ), 'inProcess'->anArray( ), 'errors'->anArra...
(class)@ -> Dictionary
(oop)@   -> 333894657
1@       -> 'errors'->anArray( )
2@       -> 'high water'->1
3@       -> 'inProcess'->anArray( )
4@       -> 'instances'->anArray( )
5@       -> 'queue'->aRcQueue( )
```

`errors` is a list of service vm tasks that have produced errors while processing. `inProcess` is a list of service vm tasks that have not completed processing. `instances` is a list of all service vm tasks that have been created. `queue` is a list of the service vm tasks that are stacked up waiting to be processed.

####Example Task
In this example the [task][3] has three separate processing steps. 
Each step is performed separately by the [service vm][9]. 

Reset the example vm, then create and view a task:

```Shell
./serviceExample --reset 
./serviceExample --task; edit
```

_**_*[`./serviceExample --reset` & `./serviceExample --task` for non-tode users][12]*

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

_**_*[`./serviceExample --task=1 --addToQueue --poll=10` for non-tode users][12]*

and view the new state:

```
.            -> task: #1 (step 1: [anArray( )] in step 2)
(class)@     -> WAGemStoneServiceExampleTask
(oop)@       -> 425026561
currentStep@ -> #'step2'
errorFlag@   -> nil
id@          -> 1
log@         -> anOrderedCollection( 'id'->2014-06-07T12:26:49.1534569263458-07:00, 'step1'->2014-06-07T12:27:02.7745549678802-07:00, 'step1'->2014-06-07T12...
step1@       -> anArray( )
step2@       -> nil
step3@       -> nil
```

peek at the service vm state:

```Shell
./serviceExample --status
```

_**_*[`serviceExample --status` for non-tode users][12]*

which will look something like the following:

```
```

####Shut down the Service gems

  ```Shell
  # stop gems
  ./webServer --stop
  ./serviceVM --stop
  ```

[1]: repository/Seaside-GemStone-ServiceTask.package/WAGemStoneServiceVMTask.class/class/serviceVMTaskServiceExample.st#L18
[2]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceVMTask.class/class/serviceLoop.st#L10
[3]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceExampleTask.class
[4]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceVMTask.class/class/serviceVMTaskServiceExample.st#L22
[5]: http://forum.world.st/threads-within-a-request-td2335295.html#a2335295
[6]: http://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
[7]: https://github.com/dalehenrich/tode#tode-the-object-centric-development-environment-
[8]: 
[9]: repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceVM.class
[10]: docs/readme/projectLoad.st
[11]: docs/readme/serviceVM.st
[12]: docs/readme/serviceExample.st
