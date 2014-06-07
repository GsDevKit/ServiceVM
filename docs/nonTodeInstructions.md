## ServiceVM
For GLASS the solution is to create a separate Service gem that services performs stashed in an RCQueue. RCQueues are conflict free with multiple producers and a single consumer - exactly our case.

###The Service gem

1. polls for tasks in the queue
2. pulls tasks out of the queue
3. forks a thread to perform each individual task
4. when the task is complete, the ending state is committed and the thread terminates

###Installation

* clone the https://github.com/glassdb/ServiceVM repository to your local disk and install the
  scripts needed by the service vm in the $GEMSTONE product tree (make sure you have $GEMSTONE
  defined before running the installScripts.sh step):

  ```shell
  cd /opt/git                                     # root directory for git repository
  git clone git@github.com:glassdb/ServiceVM.git  # clone service vm
  cd ServiceVM
  bin/installScripts.sh                           # $GEMSTONE should be set ahead of time
  ```

* load the example code:

  ```Smalltalk
  Metacello new
    baseline: 'ServiceVM';
    repository: 'filtree:///opt/git/ServiceVM/repository';
    get.
  Metacello new
    baseline: 'ServiceVM';
    repository: 'filtree:///opt/git/ServiceVM/repository';
    load.
  ```
##Service VM Example

* register the web server:

  ```Smalltalk
  "register web server"
  WAGemStoneRunSmalltalkServer
    addServerOfClass: WAGsZincAdaptor   "WAFastCGIAdaptor or WAGsSwazooAdaptor"
    withName: 'ServiceVM-WebServer'     
    on: #(8383).
  "register service vm"
  WAGemStoneRunSmalltalkServer
    addServerOfClass: WA_yet_to_be-named_class
    withName: 'ServiceVM-ServiceVM'     
    on: #(80).
  ```

* start service vms: 

  ```Smalltalk
 "start the web server"
  WAGemStoneRunSmalltalkServer 
    startGems: (WAGemStoneRunSmalltalkServer serverNamed:  'ServiceVM-WebServer').
 "start the web server"
  WAGemStoneRunSmalltalkServer 
    startGems: (WAGemStoneRunSmalltalkServer serverNamed:  'ServiceVM-ServiceVM').
  ```

###Running the Example
####Component Based
With the Component Based example, you can interactively step through the three states of the service task.

```
http://example.com/examples/serviceInteractive
```

####REST API
The RESTful API is intended to make it easy to use siege to initiate the various steps and thus load up the Service VM (yeah 
I am using a GET to initiate work ... so sue me:):

```
http://example.com/examples/service/step1
http://example.com/examples/service/step2
http://example.com/examples/service/step3
```

The other two urls give you a page with three anchors that you can hit yourself and an url that allows you to get the status of a service task by id:

```
http://example.com/examples/service
http://example.com/examples/service/{taskid}
```

* shut down the service vms:

  ```Smalltalk
 "start the web server"
  WAGemStoneRunSmalltalkServer 
    stopGems: (WAGemStoneRunSmalltalkServer serverNamed:  'ServiceVM-WebServer').
 "start the web server"
  WAGemStoneRunSmalltalkServer
    stopGems: (WAGemStoneRunSmalltalkServer serverNamed:  'ServiceVM-ServiceVM').
  ```

[1]: http://forum.world.st/threads-within-a-request-td2335295.html#a2335295
[2]: http://gemstonesoup.wordpress.com/2007/05/10/porting-application-specific-seaside-threads-to-gemstone/
[3]: http://forum.world.st/threads-within-a-request-td2335295.html#a2335295
[4]: tode#installation
[5]: docs/installServiceVM.md#installation

