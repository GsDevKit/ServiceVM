##Installation

* clone the https://github.com/glassdb/ServiceVM repository to your local disk and 
  install the scripts needed by the service vm in the $GEMSTONE product tree (make 
  sure you have $GEMSTONE defined before running the installScripts.sh step):

  ```shell
  cd /opt/git                                     # root dir for git repository
  git clone git@github.com:glassdb/ServiceVM.git  # clone service vm
  cd ServiceVM
  bin/installScripts.sh                           # $GEMSTONE must be defined
  ```

* Install the service vm artifacts in tODE and load the example code (at the tODE 
  command prompt):

  ```Shell
  mount /opt/git/ServiceVM/tode /home serviceVM  # mount tODE dir at /home/serviceVM
  edit README.md                                 # edit README (this file) in tODE
  project load @/home/serviceVM                  # load the project into the image
  ```

##Service VM Example

Overview of tODE commands used in example:
  ```Shell
  ./webServer --register=zinc   # register zinc as web server (done once)
  ./webServer --start           # start web server gem
  ./webServer --stop            # stop web server gem

  ./serviceVM --register        # register the service vm (done once)
  ./serviceVM --start           # start the service vm gem
  ./serviceVM --stop            # stop the service vm gem

  ./serviceTask --reset         # service task queues and counters cleared
  ./serviceTask --status        # inspect dictionary of service task state

  ol view                       # tOde object log window 
  ```

Get server started:

  ```Shell
  cd /home/serviceVM
  # open object log window
  ol view --reverse --age=`5 minutes`
  #
  ##### Register and start servers
  #
  # register servers
  ./webServer --register=zinc --port=8383 # use port 8383 for web server
  ./serviceVM --register 
  # start gems
  ./webServer --start
  ./serviceVM --start
  # refresh window in object log window (CMD-l)
  ```

###Service VM loop

Every 200 ms the [service VM main thread wakes up][2] and [checks the queue for tasks][1].
Each [task][3] is [removed from the queue and a thread is forked in which the **processStep** method is sent to the task][4]. When all of the oustanding tasks have been processed, the service VM main thread goes back to sleep.

You can view the state of service vm with the `serviceTask` script. The following:

```Shell
./serviceTask --status
```

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
###Scheduling a Service VM Task 
###Service VM Task `processStep`

In the **processStep**

  ```Shell
  # stop gems
  ./webServer --stop
  ./serviceVM --stop

[1]: ../repository/Seaside-GemStone-ServiceTask.package/WAGemStoneServiceVMTask.class/class/serviceVMTaskServiceExample.st#L18
[2]: ../repository/Seaside-GemStone-ServiceExamples.package/WAServiceVMGem.class/class/startOn..st#L12
[3]: ../repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceTask.class
[4]: ../repository/Seaside-GemStone-ServiceExamples.package/WAGemStoneServiceVMTask.class/class/serviceVMTaskServiceExample.st#L22