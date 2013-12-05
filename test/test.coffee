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

    it 'NotifyKeyEvent', ->
        m = new MVCObject
        spy = sinon.spy()
        m.addListener 'k_changed', spy
        m.notify 'k'
        expect(spy.calledOnce).to.be.ok

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

    it 'BindSetNotifyKeyCallback', ->
        m = new MVCObject()
        n = new MVCObject()
        spy = sinon.spy()
        n.k_changed = spy
        n.bindTo 'k', m # first invoke
        m.set 'k', 1 # second invoke
        expect(spy.calledTwice).to.be.ok

    it 'SetNotifyKeyEvent', ->
        m = new MVCObject
        spy = sinon.spy()
        m.addListener 'k_changed', spy
        m.set 'k', 1
        expect(spy.calledOnce).to.be.ok

    it 'SetBind', ->
        m = new MVCObject()
        n = new MVCObject()
        m.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal undefined
        n.bindTo 'k', m
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1

    it 'BindSet', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        m.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1

    it 'BindSetBackwards', ->
        m = new MVCObject()
        n = new MVCObject()
        n.bindTo 'k', m
        n.set 'k', 1
        expect(m.get('k')).to.equal 1
        expect(n.get('k')).to.equal 1

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

    it 'Priority', ->
        a = new MVCObject()
        b = new MVCObject()
        a.set 'k', 1
        b.set 'k', 2
        a.bindTo 'k', b
        expect(a.get('k')).to.equal 2
        expect(b.get('k')).to.equal 2

    it 'PriorityUndefined', ->
        a = new MVCObject()
        b = new MVCObject()
        a.set 'k', 1
        a.bindTo 'k', b
        expect(a.get('k')).to.equal undefined
        expect(b.get('k')).to.equal undefined

    it 'Setter', ->
        a = new MVCObject()
        x = undefined
        spy = sinon.spy()
        a.setX = (value)->
            @x = value
            spy()
        a.set 'x', 1
        expect(a.get('x')).to.equal 1
        expect(spy.called).to.not.be.ok

    it 'SetterBind', ->
        a = new MVCObject()
        x = undefined
        spy = sinon.spy()
        a.setX = (value)->
            @x = value
            spy()
        b = new MVCObject()
        b.bindTo 'x', a
        b.set 'x', 1
        expect(a.get('x')).to.equal 1
        expect(b.get('x')).to.equal 1
        expect(spy.calledOnce).to.be.ok

    it 'Getter', ->
        a = new MVCObject()
        spy = sinon.spy()
        a.getX = ->
            spy()
            1
        expect(a.get('x')).to.equal undefined
        expect(spy.called).to.not.be.ok

    it 'GetterBind', ->
        a = new MVCObject()
        spy = sinon.spy()
        a.getX = ->
            spy()
            1
        b = new MVCObject()
        b.bindTo 'x', a
        expect(b.get('x')).to.equal 1
        expect(spy.calledOnce).to.be.ok

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
