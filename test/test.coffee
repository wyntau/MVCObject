MVCObject = require '..'

describe 'MVCObject', ->
    it 'model', ->
        m = new MVCObject()
        expect(m).to.not.equal null
        expect(m).to.not.equal undefined

    it 'GetUndefined', ->
        m = new MVCObject()
        expect(m.get('k')).to.equal undefined

    it 'GetSetGet', ->
        m = new MVCObject()
        expect(m.get('k')).to.equal undefined
        m.set 'k', 1
        expect(m.get('k')).to.equal 1

    it 'SetValues', ->
        m = new MVCObject()
        m.setValues
            k1: 1
            k2: 2
        expect(m.get('k1')).to.equal 1
        expect(m.get('k2')).to.equal 2

    it 'NotifyCallback', ->
        m = new MVCObject()
        spy = sinon.spy()
        m.changed = spy
        m.notify 'k'
        expect(spy.calledOnce).to.be.ok

    it 'NotifyKeyCallback', ->
        m = new MVCObject()
        spy = sinon.spy()
        m.k_changed = spy
        m.notify 'k'
        expect(spy.calledOnce).to.be.ok

    # it 'NotifyKeyEvent', ->
    #     m = new MVCObject
    #     spy = sinon.spy()
    #     m.addListener 'k_changed', spy
    #     m.notify 'k'
    #     expect(spy.calledOnce).to.be.ok

    it 'SetNotifyCallback', ->
        m = new MVCObject()
        spy = sinon.spy()
        m.changed = spy
        m.set 'k', 1
        expect(spy.calledOnce).to.be.ok

    it 'SetNotifyKeyCallback', ->
        m = new MVCObject()
        spy = sinon.spy()
        m.k_changed = spy
        m.set 'k', 1
        expect(spy.calledOnce).to.be.ok

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

    # it 'SetNotifyKeyEvent', ->
    #     m = new MVCObject
    #     spy = sinon.spy()
    #     m.addListener 'k_changed', spy
    #     m.set 'k', 1
    #     expect(spy.calledOnce).to.be.ok

    it 'SetBind', ->
        m = new MVCObject()
        n = new MVCObject()
        m.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal undefined
        n.bindTo 'k', m
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1

    it 'SetBindTransform', ->
        m = new MVCObject()
        n = new MVCObject()
        m.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal undefined
        n.bindTo('k', m).transform (fromValue)->
            fromValue / 2
        , (toValue)->
            toValue * 2
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 2

    it 'BindSet', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        m.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1

    it 'BindSetTransform', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo('k', m).transform (fromValue)->
            fromValue / 2
        , (toValue)->
            toValue * 2
        m.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 2

    it 'BindSetBackwards', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        n.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1

    it 'BindSetBackwardsTransform', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo('k', m).transform (fromValue)->
            fromValue / 2
        , (toValue)->
            toValue * 2
        n.set 'k', 2
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 2

    it 'SetBindBackwards', ->
        m = new MVCObject()
        n = new MVCObject()
        n.set 'k', 1
        n.bindTo 'k', m
        expect(m.get('k')).to.equal undefined
        expect(n.get('k')).to.equal undefined

    it 'BindSetUnbind', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        n.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1
        n.unbind 'k'
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1
        n.set 'k', 2
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 2

    it 'UnbindAll', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        n.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1
        n.unbindAll()
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1
        n.set 'k', 2
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 2

    it 'BindNotify', ->
        m = new MVCObject()
        n = new MVCObject()
        m.bindTo 'k', n
        mSpy = sinon.spy()
        m.k_changed = mSpy
        nSpy = sinon.spy()
        n.k_changed = nSpy
        n.set 'k', 1
        expect(mSpy.calledOnce).to.be.ok
        expect(nSpy.calledOnce).to.be.ok

    it 'BindBackwardsNotify', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        mSpy = sinon.spy()
        m.k_changed = mSpy
        nSpy = sinon.spy()
        n.k_changed = nSpy
        n.set 'k', 1
        expect(mSpy.calledOnce).to.be.ok
        expect(nSpy.calledOnce).to.be.ok

    it 'BindRename', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'kn', m, 'km'
        m.set 'km', 1
        expect(m.get('km')).to.equal 1
        expect(n.get('kn')).to.equal 1

    it 'BindRenameCallbacks', ->
        m = new MVCObject()
        n = new MVCObject()
        kmSpy = sinon.spy()
        m.km_changed = kmSpy
        knSpy = sinon.spy()
        n.kn_changed = knSpy
        n.bindTo 'kn', m, 'km'
        m.set 'km', 1
        expect(m.get('km')).to.equal 1
        expect(n.get('kn')).to.equal 1
        expect(kmSpy.calledOnce).to.be.ok
        expect(knSpy.calledTwice).to.be.ok

    it 'TransitiveBindForwards', ->
        m = new MVCObject()
        n = new MVCObject()
        o = new MVCObject()
        n.bindTo 'kn', m, 'km'
        o.bindTo 'ko', n, 'kn'
        m.set 'km', 1
        expect(m.get('km')).to.equal 1
        expect(n.get('kn')).to.equal 1
        expect(o.get('ko')).to.equal 1

    it 'TransitiveBindBackwards', ->
        m = new MVCObject()
        n = new MVCObject()
        o = new MVCObject()
        n.bindTo 'kn', m, 'km'
        o.bindTo 'ko', n, 'kn'
        o.set 'ko', 1
        expect(m.get('km')).to.equal 1
        expect(n.get('kn')).to.equal 1
        expect(o.get('ko')).to.equal 1

    it 'Inheritance', ->
        spy = sinon.spy()
        class C extends MVCObject
            k_changed: spy
        c = new C()
        c.set 'k', 1
        expect(c.get('k')).to.equal 1
        expect(spy.calledOnce).to.equal true

    it 'MrideyAccessors', ->
        a = new MVCObject()
        a.set 'level', 2
        expect(a.get('level')).to.equal 2
        b = new MVCObject()
        b.setValues
            level: 2
            index: 3
            description: 'Hello world'
        expect(b.get('index')).to.equal 3

    it 'MrideyBinding', ->
        a = new MVCObject()
        a.set 'level', 2
        b = new MVCObject()
        b.bindTo 'index', a, 'level'
        expect(b.get('index')).to.equal 2
        a.set 'level', 3
        expect(b.get('index')).to.equal 3
        b.set 'index', 4
        expect(a.get('level')).to.equal 4
        c = new MVCObject()
        c.bindTo 'zoom', a, 'level'
        expect(c.get('zoom')).to.equal 4
        b.unbind 'index'
        expect(b.get('index')).to.equal 4
        c.set 'zoom', 5
        expect(a.get('level')).to.equal 5
        expect(b.get('index')).to.equal 4

    it 'CircularBind', ->
        a = new MVCObject()
        b = new MVCObject()
        a.bindTo 'k', b
        expect ->
            b.bindTo 'k', a
        .to.throw()

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

    it 'BindSelf', ->
        a = new MVCObject()
        expect ->
            a.bindTo 'k', a
        .to.throw()

    it 'ChangedKey', ->
        a = new MVCObject()
        spy = sinon.spy()
        a.changed = spy
        a.set 'k', 1
        expect(spy.calledWith('k')).to.be.ok

    ###
    {property}_changed|changed
    在链的任何位置set一个值, 总是会先到达链的顶端将值保存下来,然后从顶端开始触发changed事件.

            a    ====>    b    ====>    c    ====>    d
                          ^             ^
                          |             |
                          |             |
                          e             f
    ###
    xit 'more changed', ->
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