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

    triggerChange = (target, targetKey)->
        evt = "#{targetKey}_changed"

        if target[evt]
            target[evt]()
        else
            target.changed? targetKey

        # if target.__events__
        #     if target.__events__[evt]
        #         for handler in target.__events__[evt]
        #             handler.call target

        target.__bindings__ or= {}
        target.__bindings__[targetKey] or= {}

        for bindingUid, bindingObj of target.__bindings__[targetKey]
            triggerChange bindingObj.target, bindingObj.targetKey

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
            if accessor.to
                value = accessor.to value
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
            if accessor.from
                value = accessor.from value
            if target[setterName]
                target[setterName] value
            else
                target.set targetKey, value
        else
            @[key] = value
            triggerChange @, key

    changed: ->

    # addListener: (eventName, handler)->
    #     @__events__ or= {}
    #     @__events__[eventName] or= []

    #     if handler in @__events__[eventName]
    #         false
    #     else
    #         @__events__[eventName].push handler
    #         true

    notify: (key)->
        @__accessors__ or= {}

        if @__accessors__.hasOwnProperty key
            accessor = @__accessors__[key]
            targetKey = accessor.targetKey
            target = accessor.target
            target.notify targetKey
        else
            triggerChange @, key

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

        binding = new Accessor @, key

        accessor = new Accessor target, targetKey

        @__accessors__[key] = accessor
        target.__bindings__[targetKey][getUid @] = binding

        if not noNotify
            triggerChange @, key

        accessor

    unbind: (key)->
        @__accessors__ or= {}
        accessor = @__accessors__[key]

        if accessor
            target = accessor.target
            targetKey = accessor.targetKey
            @[key] = @get key
            delete target.__bindings__[targetKey][getUid @]
            delete @__accessors__[key]

    unbindAll: ->
        @__accessors__ or= {}

        for key of @__accessors__
            @unbind key

class Accessor
    constructor: (@target, @targetKey)->

    transform: (@from, @to)->
        @target.notify @targetKey

if module?
    module.exports = MVCObject
else
    window.MVCObject = MVCObject