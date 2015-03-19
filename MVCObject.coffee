###*
 * An implementation of Google Maps' MVCObject
###
class MVCObject

    getterNameCache = {}
    setterNameCache = {}
    uid = 0

    # 如果当前对象是key持有对象，则直接返回，否则在依赖链中查找
    getGetterName = (key)->
        if getterNameCache.hasOwnProperty key
            getterNameCache[key]
        else
            getterNameCache[key] = "get#{capitalize key}"

    ###*
     * @description 获取当前对象中给对应key对应的set方法
     * @param {String} key 关键字
     * @return {void}
    ###
    getSetterName = (key)->
        if setterNameCache.hasOwnProperty key
            setterNameCache[key]
        else
            setterNameCache[key] = "set#{capitalize key}"

    ###*
     * @description  是传入的字符串首字母大写
     * @param {String} str 初始值
     * @return {String}  首字符大写后的结果值
    ###
    capitalize = (str)->
        str.substr(0, 1).toUpperCase() + str.substr(1)

    ###*
     * @description  获取uid
     * @param {Object} obj 要获取uid 的对象
     * @return {Number}
    ###
    getUid = (obj)->
        obj.__uid__ or= ++uid

    toKey = (key)->
        "_#{key}"

    bindings = "__bindings__"
    accessors = "__accessors__"

    ###*
     * @description 这个函数的触发需要时机
     * 在一个key所在的终端对象遍历到时触发
     * 同时传播给所有直接、间接监听targetKey的对象
     * 在调用MVCObject的set方法时开始遍历
     *
     * @param target {MVCObject} 继承了MVCObject的对象
     * @param targetKey {String} 当前对象中被监听的字段
     * @return {void}
     *
    ###
    triggerChange = (target, targetKey)->
        evt = "#{targetKey}_changed"

        ###*
         * 优先检测并执行目标对象key对应的响应方法
         * 其次检测并执行默认方法
        ###
        if target[evt]
            target[evt]()
        else
            target.changed? targetKey

        # __bindings__ 持有着直接监听targetKey的对象的相关信息
        target[bindings] or= {}
        target[bindings][targetKey] or= {}

        for own bindingUid, bindingObj of target[bindings][targetKey]
            triggerChange bindingObj.target, bindingObj.targetKey

    ###*
     * @description 从依赖链中获取对应key的值
     * @param {String} key 关键值
     * @return {String} 对应的值
    ###
    get: (key)->
        # 遍历绑定到当前对象中是否有对应的key
        # @[accessors] 访问器,用来访问存放其他对象中的key
        @[accessors] or= {}

        # 检测是否有访问器,如果有执行相应的逻辑,通过访问器在依赖链中获取对应的值
        # 否则当前对象是持有key的终端对象，直接返回
        if @[accessors].hasOwnProperty key
            accessor = @[accessors][key]
            targetKey = accessor.targetKey
            target = accessor.target
            getterName = getGetterName targetKey
            # 检测并执行与key对应的get方法
            # 如果没有则执行默认的get方法
            if target[getterName]
                value = target[getterName]()
            else
                value = target.get targetKey
            if accessor.to
                value = accessor.to value
        else if @hasOwnProperty toKey(key)
            value = @[toKey(key)]

        value

    ###*
     * @description set方法遍历依赖链直到找到key的持有对象设置key的值;
     * 有三个分支
     * @param {String} key 关键值
     * @param {all} value 要给key设定的值,可以是所有类型
     * @return {void}
    ###
    set: (key, value)->
        @[accessors] or= {}

        # 检测访问器中是否有对应的目标对象，有则执行相应逻辑进入目标对象中进行设置
        # 否则当前对象就是持有对象，设置并广播事件
        if @[accessors].hasOwnProperty key
            accessor = @[accessors][key]
            targetKey = accessor.targetKey
            target = accessor.target
            setterName = getSetterName targetKey
            if accessor.from
                value = accessor.from value
            # 给当前key专门设定的方法
            # 什么情况下会给key 专门设定一个方法？
            if target[setterName]
                target[setterName] value
            else
            # MVCObject默认的set方法
                target.set targetKey, value
        else
            @[toKey(key)] = value
            triggerChange @, key

    ###*
     * @description 没个MVCObject对象各自的响应对应的key值变化时的逻辑
    ###
    changed: ->

    ###*
     * @description 手动触发对应key的事件传播
     * @param {String} key 关键值
     * @return {void}
    ###
    notify: (key)->
        @[accessors] or= {}

        if @[accessors].hasOwnProperty key
            accessor = @[accessors][key]
            targetKey = accessor.targetKey
            target = accessor.target
            target.notify targetKey
        else
            triggerChange @, key

    setValues: (values)->
        for own key, value of values
            setterName = getSetterName key
            if @[setterName]
                @[setterName] value
            else
                @set key, value

    ###*
     * @description 将当前对象的一个key与目标对象的targetKey建立监听和广播关系
     * @param key {String} 当前对象上的key
     * @param target {Object} 目标对象
     * @param tarrgetKey {String} 目标对象上的key
     * @param noNotify {Boolean}
    ###
    bindTo: (key, target, targetKey, noNotify)->
        targetKey or= key
        @unbind key

        # 访问器字典
        @[accessors] or= {}
        #this->
        # 广播对象字典
        target[bindings] or= {}
        target[bindings][targetKey] or= {}

        # 自身作为目标对象时,所持有广播key change 事件时需要通知的对象的信息
        binding = new Accessor @, key

        # 当前对象的一个访问器，持有用来访问目标对象的信息
        accessor = new Accessor target, targetKey

        @[accessors][key] = accessor
        target[bindings][targetKey][getUid @] = binding

        if not noNotify
            triggerChange @, key

        accessor

    ###*
     * @description 解除当前对象上key与目标对象的监听
     * @param {String} key 关键字
     * @return {void}
    ###
    unbind: (key)->
        @[accessors] or= {}
        accessor = @[accessors][key]

        if accessor
            target = accessor.target
            targetKey = accessor.targetKey
            @[toKey(key)] = @get key
            delete target[bindings][targetKey][getUid @]
            delete @[accessors][key]

    unbindAll: ->
        @[accessors] or= {}

        for own key of @[accessors]
            @unbind key

class Accessor
    constructor: (@target, @targetKey)->

    transform: (@from, @to)->
        @target.notify @targetKey

# 暴露模块
if module?
    module.exports = MVCObject
else if typeof define is 'function'
    define ->
        MVCObject
else
    window.MVCObject = MVCObject