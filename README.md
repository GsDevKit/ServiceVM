ServiceVM
=========

The Service VM is intended to provide example code for creating and using a separate "Service VM" for offloading work that in a Squeak/Pharo Seaside application, you would have forked of a thread to do the work 

The Service VM work was tracked by a [conversation between Nick Ager and I (Dale Henrichs)][1].

## Futures work by Nick Ager
A Future implementation for Pharo with a package containing two Seaside examples to demonstrate a typical usage scenario.
Designed to be compatible with a GemStone future implementation.

The implementation is based on: http://onsmalltalk.com/smalltalk-concurrency-playing-with-futures:

* Pharo-Future-NickAger.3.mcz
* Future-Seaside-Examples-NickAger.9.mcz

[1]: http://forum.world.st/threads-within-a-request-td2335295.html#a2335295
