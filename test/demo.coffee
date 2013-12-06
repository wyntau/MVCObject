MVCObject = require '..'


describe 'Demo', ->

    ###
    bindTo(key, target, targetKey, noNotify):
    - 一对一, 此对象的一个key只能绑定到另一个对象
    - 多对一, 此对象的一个key可以被多个对象绑定
    - bindTo时, 默认触发一次 {property}_changed 或 changed 事件, 将noNotify设为true
    可以阻止第一次changed事件
    ###
    it 'BindSetNotifyKeyCallback', ->
        m = new MVCObject()
        n = new MVCObject()
        p = new MVCObject()
        spy1 = sinon.spy()
        spy2 = sinon.spy()
        n.k_changed = spy1
        p.k_changed = spy2
        n.bindTo 'k', m # first invoke
        p.bindTo 'k', m, 'k', true # no first invoke
        m.set 'k', 1 # n second invoke, p first invoke
        expect(spy1.calledTwice).to.be.ok
        expect(spy2.calledOnce).to.be.ok

    ###
    get(key):
    - 已经绑定过: target[getterName](key) || target.get(key)
    - 未绑定过: self[key]
    - self[getterName] 不会被调用, 当有其它对象绑定到此对象时, 在其它对象上调用get(key)时会调用此对象的self[getterName]
    - 自己原本有值, 只要绑定后, 就会被绑定过的值覆盖, 即可被覆盖的值为undefined
    ###
    it 'Getter', ->
        a = new MVCObject()
        spy = sinon.spy()
        a.getX = spy
        a.x = 2
        expect(a.get('x')).to.equal 2 # 直接返回self[key]
        expect(spy.called).to.not.be.ok # getterName 未被调用

    it 'GetterBind', ->
        a = new MVCObject()
        spy = sinon.spy()
        a.getX = ->
            spy()
            1
        b = new MVCObject()
        b.bindTo 'x', a
        expect(b.get('x')).to.equal 1
        expect(spy.calledOnce).to.be.ok # 当b调用时, a[getterName]被调用一次

    it 'Priority', ->
        a = new MVCObject()
        b = new MVCObject()
        a.set 'k', 1
        b.set 'k', 2
        expect(a.get('k')).to.equal 1 # 未绑定之前
        expect(b.get('k')).to.equal 2
        a.bindTo 'k', b
        expect(a.get('k')).to.equal 2 # 绑定之后
        expect(b.get('k')).to.equal 2

    it 'PriorityUndefined', ->
        a = new MVCObject()
        b = new MVCObject()
        a.set 'k', 1
        expect(a.get('k')).to.equal 1 # 未绑定之前
        a.bindTo 'k', b
        expect(a.get('k')).to.equal undefined # 绑定之后
        expect(b.get('k')).to.equal undefined

    ###
        a --> b --> c
        |     |     |
    get('x')
    ###
    it 'Half stop search', -> # 一条链上, 中途有getterName 方法, 则不再向上寻找.
            a = new MVCObject
            b = new MVCObject
            c = new MVCObject

            a.bindTo 'm', b
            b.bindTo 'm', c

            b.getM = ->
                1
            c.getM = ->
                2
            sinon.spy b, 'getM'
            sinon.spy c, 'getM'

            a.get('m').should.equal 1
            b.getM.should.have.been.calledOnce
            c.getM.should.not.have.been.called

    ###
    set(key, value):
    - 已经绑定过, target[setterName](key, value) || target.set(key, value)
    - 未绑定过的, self[key] = value
    - self[setterName] 不会被调用, 当有其它对象绑定到此对象时, 在其它对象上调用set(key, value)时会调用此对象的self[setterName]
    ###
    it 'Setter', ->
        a = new MVCObject()
        x = undefined
        spy = sinon.spy()
        a.setX = spy
        a.set 'x', 1
        expect(a.get('x')).to.equal 1
        expect(a.x).to.equal 1 # self[key] = value
        expect(spy.called).to.not.be.ok # 自己的self[setterName]() 未被调用

    it 'SetterBind', ->
        a = new MVCObject()
        spy = sinon.spy()
        a.setX = (value)->
            @x = value
            spy()
        b = new MVCObject()
        b.bindTo 'x', a
        b.set 'x', 1
        expect(a.get('x')).to.equal 1
        expect(b.get('x')).to.equal 1 # 最终调用a.get('x'), 但是a没有getX方法,所以直接返回a.x
        expect(spy.calledOnce).to.be.ok # a[setterName]() 被调用

    ###
    {property}_changed|changed
    在链的任何位置set一个值, 总是会先到达链的顶端将值保存下来,然后从顶端开始触发changed事件.

            a    ====>    b    ====>    c    ====>    d
                          ^             ^
                          |             |
                          |             |
                          e             f
    ###
    it 'more changed', ->
        a = new MVCObject()
        b = new MVCObject()
        c = new MVCObject()
        d = new MVCObject()
        e = new MVCObject()
        f = new MVCObject()

        a.bindTo 'k', b
        # f.bindTo 'k', c
        b.bindTo 'k', c
        c.bindTo 'k', d
        e.bindTo 'k', b
        f.bindTo 'k', c

        a.k_changed = ->
            console.log 'a: k_changed'
        b.k_changed = ->
            console.log 'b: k_changed'
        c.k_changed = ->
            console.log 'c: k_changed'
        d.k_changed = ->
            console.log 'd: k_changed'
        e.k_changed = ->
            console.log 'e: k_changed'
        f.k_changed = ->
            console.log 'f: k_changed'

        a.setK = (value)->
            console.log 'a: setK'
            @set 'k', value # 理论上不会再向上set, 所以自身调用

        b.setK = (value)->
            console.log 'b: setK'
            @set 'k', value

        c.setK = (value)->
            console.log 'c: setK'
            @set 'k', value

        d.setK = (value)->
            console.log 'd: setK'
            @set 'k', value

        e.setK = (value)->
            console.log 'e: setK'
            @set 'k', value

        f.setK = (value)->
            console.log 'f: setK'
            @set 'k', value

        f.set 'k', 1