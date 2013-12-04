## MVCObject

An implementation of Google Maps' MVCObject.

This is a standalone class - you can use it in any of your JavaScript
applications, it doesn't have to be Google Maps related.

### test

    npm install
    make test

### API

Methods | Return Value | Description
----- | ----- | -----
addListener(eventName:string) | boolean | Adds the given listener function to the given event name.
bindTo(key:string, target:MVCObject, targetKey?:string, noNotify?:boolean) | None | Binds a View to a Model.
changed(key:string) | None | Generic handler for state changes. Override this in derived classes to handle arbitrary state changes.
get(key:string) | * | Gets a value.
notify(key:string) | None | Notify all observers of a change on this property. This notifies both objects that are bound to the object's property as well as the object that it is bound to.
set(key:string, value:*) | None | Sets a value.
setValues(values:Object) | None | Sets a collection of key-value pairs.
unbind(key:string) | None | Removes a binding. Unbinding will set the unbound property to the current value. The object will not be notified, as the value has not changed.
unbindAll() | None | Removes all bindings.


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