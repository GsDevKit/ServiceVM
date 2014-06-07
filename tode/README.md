###Installation

* mount the server vm tode directory (at tODE command line)

  ```Shell
  mount /opt/git/ServerVM tode /home serverVM 
  ```

###Web Server

* to start a Zinc web server for serving the example Seaside pages (at the tODE command 
  line):

  ```Shell
  cd /home/serverVM

  ./webServer --register=zinc --port=8383 # register zinc as web server (only done once)

  ./webServer --start                     # start web server in separate vm

  ./webServer --stop                      # stop web server when done

  ./webServer --help                      # additional documentation

  ./serviceVM --register                  # register the service vm (only done once)

  ./serviceVM --start                     # start the service vm gem

  ./serviceVM --stop                      # stop the service vm gem

  ./serviceVM --help                      # additional documentation
  ```
