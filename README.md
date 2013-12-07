## MVCObject

An CoffeeScript implementation of [Google Maps' MVCObject](https://developers.google.com/maps/articles/mvcfun).

This is a standalone class - you can use it in any of your JavaScript applications, it doesn't have to be Google Maps related.

### APIs

Methods | Return Value | Description
----- | ----- | -----
bindTo(key:string, target:MVCObject, targetKey?:string, noNotify?:boolean) | None | Binds a View to a Model.
changed(key:string) | None | Generic handler for state changes. Override this in derived classes to handle arbitrary state changes.
get(key:string) | * | Gets a value.
notify(key:string) | None | Notify all observers of a change on this property. This notifies both objects that are bound to the object's property as well as the object that it is bound to.
set(key:string, value:*) | None | Sets a value.
setValues(values:Object) | None | Sets a collection of key-value pairs.
unbind(key:string) | None | Removes a binding. Unbinding will set the unbound property to the current value. The object will not be notified, as the value has not changed.
unbindAll() | None | Removes all bindings.

### Usage
1. CoffeeScript in Node.js

        MVCObject = require 'MVCObject'

        class class1 extends MVCObject
            constructor: ->
                ...

2. JavaScript in Node.js

        var MVCObject = require('MVCObject');

        function class1(){}
        class1.prototype = new MVCObject();

3. JavaScript in Browsers

        <!-- include the MVCObject.js -->
        <script src="/path/to/MVCObject.js"></script>

        function class1(){}
        class1.prototype = new MVCObject();

### test
Thanks to @twpayne, the test suites are based on his [mvcobject_test.js](https://github.com/twpayne/mvcobject/blob/master/src/mvc/mvcobject_test.js).

    npm install
    make test

### LICENSE
The MIT License (MIT)

Copyright (c) 2013 Jeremial jeremial90@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.