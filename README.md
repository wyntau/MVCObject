## MVCObject [![NPM version](https://badge.fury.io/js/mvcobject.png)](http://badge.fury.io/js/mvcobject) [![Build Status](https://travis-ci.org/Treri/MVCObject.png)](https://travis-ci.org/Treri/MVCObject) [![Dependencies Status](https://david-dm.org/Treri/MVCObject.png)](https://david-dm.org/Treri/MVCObject)

An implementation of [Google Maps' MVCObject](https://web.archive.org/web/20140331075724/https://developers.google.com/maps/articles/mvcfun) for Node.js and browers.

This is a standalone class - you can use it in any of your JavaScript applications, it doesn't have to be Google Maps related.

[![mvcobject](https://nodei.co/npm/mvcobject.png?compact=true)](https://nodei.co/npm/mvcobject)

### APIs

Methods | Return Value | Description
----- | ----- | -----
bindTo(key:string, target:MVCObject, targetKey?:string, noNotify?:boolean) | accessor | Binds a View to a Model.
changed(key:string) | ? | Generic handler for state changes. Override this in derived classes to handle arbitrary state changes.
get(key:string) | * | Gets a value.
notify(key:string) | this | Notify all observers of a change on this property. This notifies both objects that are bound to the object's property as well as the object that it is bound to.
set(key:string, value:*) | this | Sets a value.
setValues(values:Object) | this | Sets a collection of key-value pairs.
unbind(key:string) | this | Removes a binding. Unbinding will set the unbound property to the current value. The object will not be notified, as the value has not changed.
unbindAll() | this | Removes all bindings.

### Usage

- ES6

    ```js
    import MVCObject from 'mvcobject'

    class Foo extends MVCObject{
        constructor(){
            super()
        }
    }
    ```

- ES5

    ```js
    var MVCObject = require('mvcobject').MVCObject;
    function Foo(){}
    Foo.prototype = new MVCObject();
    ```

### test
Thanks to @twpayne, the test suites are based on his [mvcobject_test.js](https://github.com/twpayne/mvcobject/blob/master/src/mvc/mvcobject_test.js).

    npm install
    npm run test

### LICENSE
The MIT License (MIT)

Copyright (c) 2013-2016 Treri treri.liu@gmail.com

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
