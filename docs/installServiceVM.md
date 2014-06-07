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

* **[demo steps}**

* shut down the service vms:

  ```Smalltalk
 "start the web server"
  WAGemStoneRunSmalltalkServer 
    stopGems: (WAGemStoneRunSmalltalkServer serverNamed:  'ServiceVM-WebServer').
 "start the web server"
  WAGemStoneRunSmalltalkServer
    stopGems: (WAGemStoneRunSmalltalkServer serverNamed:  'ServiceVM-ServiceVM').
  ```



