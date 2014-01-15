describe 'MVCObject', ->
    it 'model', ->
        m = new MVCObject()
        should.exist m

    it 'GetUndefined', ->
        m = new MVCObject()
        should.not.exist m.get 'k'

    it 'GetSetGet', ->
        m = new MVCObject()
        should.not.exist m.get 'k'
        m.set 'k', 1
        m.get('k').should.equal 1

    it 'SetValues', ->
        m = new MVCObject()
        m.setValues
            k1: 1
            k2: 2
        m.get('k1').should.equal 1
        m.get('k2').should.equal 2

    it 'NotifyCallback', ->
        m = new MVCObject()
        m.changed = sinon.spy()
        m.notify 'k'
        m.changed.should.have.been.calledOnce

    it 'NotifyKeyCallback', ->
        m = new MVCObject()
        m.k_changed = sinon.spy()
        m.notify 'k'
        m.k_changed.should.have.been.calledOnce

    # it 'NotifyKeyEvent', ->
    #     m = new MVCObject
    #     spy = sinon.spy()
    #     m.addListener 'k_changed', spy
    #     m.notify 'k'
    #     expect(spy.calledOnce).to.be.ok

    it 'SetNotifyCallback', ->
        m = new MVCObject()
        m.changed = sinon.spy()
        m.set 'k', 1
        m.changed.should.have.been.calledOnce

    it 'SetNotifyKeyCallback', ->
        m = new MVCObject()
        m.k_changed = sinon.spy()
        m.set 'k', 1
        m.k_changed.should.have.been.calledOnce

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
        n.k_changed = sinon.spy()
        p.k_changed = sinon.spy()
        n.bindTo 'k', m # first invoke
        p.bindTo 'k', m, 'k', true # no first invoke
        m.set 'k', 1 # n second invoke, p first invoke
        n.k_changed.should.have.been.calledTwice
        p.k_changed.should.have.been.calledOnce

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
        m.get('k').should.equal 1
        should.not.exist n.get 'k'
        n.bindTo 'k', m
        m.get('k').should.equal 1
        n.get('k').should.equal 1

    it 'SetBindTransform', ->
        m = new MVCObject()
        n = new MVCObject()
        m.set 'k', 1
        m.get('k').should.equal 1
        should.not.exist n.get 'k'
        n.bindTo('k', m).transform (fromValue)->
            fromValue / 2
        , (toValue)->
            toValue * 2
        m.get('k').should.equal 1
        n.get('k').should.equal 2

    it 'BindSet', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        m.set 'k', 1
        m.get('k').should.equal 1
        n.get('k').should.equal 1

    it 'BindSetTransform', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo('k', m).transform (fromValue)->
            fromValue / 2
        , (toValue)->
            toValue * 2
        m.set 'k', 1
        m.get('k').should.equal 1
        n.get('k').should.equal 2

    it 'BindSetBackwards', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        n.set 'k', 1
        m.get('k').should.equal 1
        n.get('k').should.equal 1

    it 'BindSetBackwardsTransform', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo('k', m).transform (fromValue)->
            fromValue / 2
        , (toValue)->
            toValue * 2
        n.set 'k', 2
        m.get('k').should.equal 1
        n.get('k').should.equal 2

    it 'SetBindBackwards', ->
        m = new MVCObject()
        n = new MVCObject()
        n.set 'k', 1
        n.bindTo 'k', m
        should.not.exist m.get 'k'
        should.not.exist n.get 'k'

    it 'BindSetUnbind', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        n.set 'k', 1
        m.get('k').should.equal 1
        n.get('k').should.equal 1
        n.unbind 'k'
        m.get('k').should.equal 1
        n.get('k').should.equal 1
        n.set 'k', 2
        m.get('k').should.equal 1
        n.get('k').should.equal 2

    it 'UnbindAll', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        n.set 'k', 1
        m.get('k').should.equal 1
        n.get('k').should.equal 1
        n.unbindAll()
        m.get('k').should.equal 1
        n.get('k').should.equal 1
        n.set 'k', 2
        m.get('k').should.equal 1
        n.get('k').should.equal 2

    it 'BindNotify', ->
        m = new MVCObject()
        n = new MVCObject()
        m.bindTo 'k', n
        m.k_changed = sinon.spy()
        n.k_changed = sinon.spy()
        n.set 'k', 1
        m.k_changed.should.have.been.calledOnce
        n.k_changed.should.have.been.calledOnce

    it 'BindBackwardsNotify', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        m.k_changed = sinon.spy()
        n.k_changed = sinon.spy()
        n.set 'k', 1
        m.k_changed.should.have.been.calledOnce
        n.k_changed.should.have.been.calledOnce

    it 'BindRename', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'kn', m, 'km'
        m.set 'km', 1
        m.get('km').should.equal 1
        n.get('kn').should.equal 1

    it 'BindRenameCallbacks', ->
        m = new MVCObject()
        n = new MVCObject()
        m.km_changed = sinon.spy()
        n.kn_changed = sinon.spy()
        n.bindTo 'kn', m, 'km'
        m.set 'km', 1
        m.get('km').should.equal 1
        n.get('kn').should.equal 1
        m.km_changed.should.have.been.calledOnce
        n.kn_changed.should.have.been.calledTwice

    it 'TransitiveBindForwards', ->
        m = new MVCObject()
        n = new MVCObject()
        o = new MVCObject()
        n.bindTo 'kn', m, 'km'
        o.bindTo 'ko', n, 'kn'
        m.set 'km', 1
        m.get('km').should.equal 1
        n.get('kn').should.equal 1
        o.get('ko').should.equal 1

    it 'TransitiveBindBackwards', ->
        m = new MVCObject()
        n = new MVCObject()
        o = new MVCObject()
        n.bindTo 'kn', m, 'km'
        o.bindTo 'ko', n, 'kn'
        o.set 'ko', 1
        m.get('km').should.equal 1
        n.get('kn').should.equal 1
        o.get('ko').should.equal 1

    it 'Inheritance', ->
        spy = sinon.spy()
        class C extends MVCObject
            k_changed: spy
        c = new C()
        c.set 'k', 1
        c.get('k').should.equal 1
        spy.should.have.been.calledOnce

    it 'MrideyAccessors', ->
        a = new MVCObject()
        a.set 'level', 2
        a.get('level').should.equal 2
        b = new MVCObject()
        b.setValues
            level: 2
            index: 3
            description: 'Hello world'
        b.get('index').should.equal 3

    it 'MrideyBinding', ->
        a = new MVCObject()
        a.set 'level', 2
        b = new MVCObject()
        b.bindTo 'index', a, 'level'
        b.get('index').should.equal 2
        a.set 'level', 3
        b.get('index').should.equal 3
        b.set 'index', 4
        a.get('level').should.equal 4
        c = new MVCObject()
        c.bindTo 'zoom', a, 'level'
        c.get('zoom').should.equal 4
        b.unbind 'index'
        b.get('index').should.equal 4
        c.set 'zoom', 5
        a.get('level').should.equal 5
        b.get('index').should.equal 4

    it 'CircularBind', ->
        a = new MVCObject()
        b = new MVCObject()
        a.bindTo 'k', b
        should.throw ->
            b.bindTo 'k', a
        # expect ->
        #     b.bindTo 'k', a
        # .to.throw()

    ###
    set(key, value):
    - 已经绑定过, target[setterName](key, value) || target.set(key, value)
    - 未绑定过的, self[key] = value
    - self[setterName] 不会被调用, 当有其它对象绑定到此对象时, 在其它对象上调用set(key, value)时会调用此对象的self[setterName]
    ###
    it 'Setter', ->
        a = new MVCObject()
        x = undefined
        a.setX = sinon.spy()
        a.set 'x', 1
        a.get('x').should.equal 1
        a.x.should.equal 1 # self[key] = value
        a.setX.should.not.have.been.called # 自己的self[setterName]() 未被调用

    it 'SetterBind', ->
        a = new MVCObject()
        a.setX = (value)->
            @x = value
        sinon.spy a, 'setX'
        b = new MVCObject()
        b.bindTo 'x', a
        b.set 'x', 1
        a.get('x').should.equal 1
        b.get('x').should.equal 1 # 最终调用a.get('x'), 但是a没有getX方法,所以直接返回a.x
        a.setX.should.have.been.calledOnce # a[setterName]() 被调用

    ###
    get(key):
    - 已经绑定过: target[getterName](key) || target.get(key)
    - 未绑定过: self[key]
    - self[getterName] 不会被调用, 当有其它对象绑定到此对象时, 在其它对象上调用get(key)时会调用此对象的self[getterName]
    - 自己原本有值, 只要绑定后, 就会被绑定过的值覆盖, 即可被覆盖的值为undefined
    ###
    it 'Getter', ->
        a = new MVCObject()
        a.getX = sinon.spy()
        a.x = 2
        a.get('x').should.equal 2 # 直接返回self[key]
        a.getX.should.not.have.been.called # getterName 未被调用

    it 'GetterBind', ->
        a = new MVCObject()
        a.getX = ->
            1
        sinon.spy a, 'getX'
        b = new MVCObject()
        b.bindTo 'x', a
        b.get('x').should.equal 1
        a.getX.should.have.been.calledOnce

    it 'Priority', ->
        a = new MVCObject()
        b = new MVCObject()
        a.set 'k', 1
        b.set 'k', 2
        a.get('k').should.equal 1 # 未绑定之前
        b.get('k').should.equal 2
        a.bindTo 'k', b
        a.get('k').should.equal 2 # 绑定之后
        b.get('k').should.equal 2

    it 'PriorityUndefined', ->
        a = new MVCObject()
        b = new MVCObject()
        a.set 'k', 1
        a.get('k').should.equal 1 # 未绑定之前
        a.bindTo 'k', b
        should.not.exist a.get 'k' # 绑定之后
        should.not.exist b.get 'k'

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
        should.throw ->
            a.bindTo 'k', a

    it 'ChangedKey', ->
        a = new MVCObject()
        a.changed = sinon.spy()
        a.set 'k', 1
        a.changed.should.have.been.calledWith 'k'

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
        b.bindTo 'k', c
        c.bindTo 'k', d
        e.bindTo 'k', b
        f.bindTo 'k', c

        a.k_changed = sinon.spy()
        b.k_changed = sinon.spy()
        c.k_changed = sinon.spy()
        d.k_changed = sinon.spy()
        e.k_changed = sinon.spy()
        f.k_changed = sinon.spy()

        a.setK = (value)->
            @set 'k', value # 理论上不会再向上set, 所以自身调用

        b.setK = (value)->
            @set 'k', value

        c.setK = (value)->
            @set 'k', value

        d.setK = (value)->
            @set 'k', value

        e.setK = (value)->
            @set 'k', value

        f.setK = (value)->
            @set 'k', value

        sinon.spy a, 'setK'
        sinon.spy b, 'setK'
        sinon.spy c, 'setK'
        sinon.spy d, 'setK'
        sinon.spy e, 'setK'
        sinon.spy f, 'setK'

        e.set 'k', 1

        e.setK.should.not.have.been.called

        b.setK.should.have.been.calledBefore c.setK
        c.setK.should.have.been.calledBefore d.setK

        d.k_changed.should.have.been.calledBefore c.k_changed

        c.k_changed.should.have.been.calledBefore b.k_changed
        c.k_changed.should.have.been.calledBefore f.k_changed

        b.k_changed.should.have.been.calledBefore a.k_changed
        b.k_changed.should.have.been.calledBefore e.k_changed
