###Installation

* mount the server vm tODE directory (at tODE command prompt)

  ```Shell
  mount /opt/git/ServerVM tode /home serverVM 
  ```

###Web Server

* to start a Zinc web server for serving the example Seaside pages (at the tODE command 
  prompt):

  ```Shell
  cd /home/serverVM

  ./webServer --register=zinc --port=8383 # register zinc as web server (only done once)
  ./serviceVM --register                  # register the service vm (only done once)

  ./webServer --start                     # start web server in separate vm
  ./serviceVM --start                     # start the service vm gem
  ```

* **[demo steps}**

* shut down the web browser and server vm (at the tODE command prompt):

 ```Shell 
  ./webServer --stop                      # stop web server when done
  ./serviceVM --stop                      # stop the service vm gem
  ```

* Use the `--help` option for additional functionality (at the tODE command prompt):

  ```Shell 
  ./webServer --help                      # additional documentation
  ./serviceVM --help                      # additional documentation
  ```
