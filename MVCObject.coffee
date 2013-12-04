###*
 * An implementation of Google Maps' MVCObject
###
class MVCObject

    getterNameCache = {}
    setterNameCache = {}
    uid = 0

    getGetterName = (key)->
        if getterNameCache.hasOwnProperty key
            getterNameCache[key]
        else
            getterNameCache[key] = "get#{capitalize key}"

    getSetterName = (key)->
        if setterNameCache.hasOwnProperty key
            setterNameCache[key]
        else
            setterNameCache[key] = "set#{capitalize key}"

    capitalize = (str)->
        str.substr(0, 1).toUpperCase() + str.substr(1)

    getUid = (obj)->
        obj.__uid__ or= ++uid

    invokeChange = (target, targetKey)->
        evt = "#{targetKey}_changed"

        if target[evt]
            target[evt]()
        else
            target.changed? targetKey

        if target.__events__
            if target.__events__[evt]
                for handler in target.__events__[evt]
                    handler.call target

        target.__bindings__ or= {}
        target.__bindings__[targetKey] or= {}

        for bindingName, bindingObj of target.__bindings__[targetKey]
            invokeChange bindingObj.target, bindingObj.targetKey

    get: (key)->
        @__accessors__ or= {}

        if @__accessors__.hasOwnProperty key
            accessor = @__accessors__[key]
            targetKey = accessor.targetKey
            target = accessor.target
            getterName = getGetterName targetKey
            if target[getterName]
                value = target[getterName]()
            else
                value = target.get targetKey
        else if @hasOwnProperty key
            value = @[key]

        value

    set: (key, value)->
        @__accessors__ or= {}

        if @__accessors__.hasOwnProperty key
            accessor = @__accessors__[key]
            targetKey = accessor.targetKey
            target = accessor.target
            setterName = getSetterName targetKey
            if target[setterName]
                target[setterName] value
            else
                target.set targetKey, value
        else
            @[key] = value
            invokeChange @, key

    changed: ->

    addListener: (eventName, handler)->
        @__events__ or= {}
        @__events__[eventName] or= []

        if handler in @__events__[eventName]
            false
        else
            @__events__[eventName].push handler
            true

    notify: (key)->
        @__accessors__ or= {}

        if @__accessors__.hasOwnProperty key
            accessor = @__accessors__[key]
            targetKey = accessor.targetKey
            target = accessor.target
            target.notify targetKey
        else
            invokeChange @, key

    setValues: (values)->
        for key, value of values
            setterName = getSetterName key
            if @[setterName]
                @[setterName] value
            else
                @set key, value

    bindTo: (key, target, targetKey, noNotify)->
        targetKey or= key
        @unbind key

        @__accessors__ or= {}
        target.__bindings__ or= {}
        target.__bindings__[targetKey] or= {}

        bindingObj =
            target: @
            targetKey: key

        accessor =
            target: target
            targetKey: targetKey
            bindingObj: bindingObj

        @__accessors__[key] = accessor
        target.__bindings__[targetKey][getUid bindingObj] = bindingObj

        if not noNotify
            invokeChange @, key

    unbind: (key)->
        @__accessors__ or= {}
        accessor = @__accessors__[key]

        if accessor
            bindingObj = accessor.bindingObj
            target = accessor.target
            targetKey = accessor.targetKey
            if bindingObj
                delete target.__bindings__[targetKey][getUid bindingObj]
            @[key] = @get key
            delete @__accessors__[key]

    unbindAll: ->
        @__accessors__ or= {}

        for key of @__accessors__
            @unbind key

if module?
    module.exports = MVCObject
else
    window.MVCObject = MVCObject