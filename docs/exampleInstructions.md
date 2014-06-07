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
