---
title: <cfthread>
id: tag-thread
categories:
- thread
description: The cfthread tag enables you to create threads, independent streams of code execution, in your application.
---

The `cfthread` tag enables concurrent execution through thread management in your CFML application.
 			
Threads are independent streams of code execution that allow you to perform multiple operations simultaneously, improving application performance and responsiveness. You can use this tag to:

* **Create** new threads with custom processing
* **Join** multiple threads together, synchronizing their execution
* **Sleep** the current thread to pause execution
* **Terminate** threads that need to be stopped immediately
* **Interrupt** threads, allowing for cooperative stopping with resource cleanup. (**Introduced:** 7.0.0.120)
    
Each thread gets its own isolated variable scope (`thread`) that persists across the thread's lifetime and can be accessed from other parts of your application.

You can pass in any additional attributes you need to, these are then available within the thread,
in the `attributes` scope, which is useful for passing data into the thread.

In Lucee these attributes are passed **by reference**, unlike other CFML engines.

If you are using thread in cfscript, you can also access these via the `arguments` scope,
but this is not recommended or compatible with other CFML engines.

Each thread has it's own unique set of debugging logs, which will not show up in the main pages, normal debugging report.

You can access this debugging data, inside the thread using `<cfadmin action="getDebugData" returnVariable="data">`.
