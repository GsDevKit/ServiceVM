###Installation

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
  project load @/home/serviceVM                  # load the project into the image
  ```

###Service VM Example

* Register and start the service vms (at the tODE command prompt):

  ```Shell
  cd /home/serviceVM

  ./webServer --register=zinc --port=8383 # register zinc as web server (done once)
  ./serviceVM --register                  # register the service vm (done once)

  ./webServer --start                     # start web server gem
  ./serviceVM --start                     # start the service vm gem
  ```

* Follow the [instructions here](exampleInstructions.md) to run through the example.

* Shut down the service vms (at the tODE command prompt):

 ```Shell 
  ./webServer --stop                      # stop web server gem
  ./serviceVM --stop                      # stop the service vm gem
  ```

* Use the `--help` option for additional functionality (at the tODE command prompt):

  ```Shell 
  ./webServer --help                      # additional documentation
  ./serviceVM --help                      # additional documentation
  ```
