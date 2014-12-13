service instance-server
startServerOn: port
  "start server in current vm. for gemstone, not expected to return."

  self taskClass vmStartup.
  super startServerOn: port