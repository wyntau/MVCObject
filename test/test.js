describe('MVCObject', function () {
    it('model', function () {
        var m = new MVCObject();
        should.exist(m);
    });

    it('GetUndefined', function () {
        var m = new MVCObject();
        should.not.exist(m.get('k'));
    });

    it('GetSetGet', function () {
        var m = new MVCObject();
        should.not.exist(m.get('k'));
        m.set('k', 1);
        m.get('k').should.equal(1);
    });

    it('SetValues', function () {
        var m = new MVCObject();
        m.setValues({
            k1: 1,
            k2: 2
        });
        m.get('k1').should.equal(1);
        m.get('k2').should.equal(2);
    });

    it('NotifyCallback', function () {
        var m = new MVCObject();
        m.changed = sinon.spy();
        m.notify('k');
        m.changed.should.have.been.calledOnce;
    });

    it('NotifyKeyCallback', function () {
        var m = new MVCObject();
        m.k_changed = sinon.spy();
        m.notify('k');
        m.k_changed.should.have.been.calledOnce;
    });

    // it('NotifyKeyEvent', function() {
    //     m = new MVCObject
    //     spy = sinon.spy();
    //     m.addListener('k_changed', spy);
    //     m.notify('k');
    //     expect(spy.calledOnce).to.be.ok
    // });

    it('SetNotifyCallback', function () {
        var m = new MVCObject();
        m.changed = sinon.spy();
        m.set('k', 1);
        m.changed.should.have.been.calledOnce;
    });

    it('SetNotifyKeyCallback', function () {
        var m = new MVCObject();
        m.k_changed = sinon.spy();
        m.set('k', 1);
        m.k_changed.should.have.been.calledOnce;
    });

    /*
    bindTo(key, target, targetKey, noNotify):
    - 一对一, 此对象的一个key只能绑定到另一个对象
    - 多对一, 此对象的一个key可以被多个对象绑定
    - bindTo时, 默认触发一次 {property}_changed 或 changed 事件, 将noNotify设为true
    可以阻止第一次changed事件
    */
    it('BindSetNotifyKeyCallback', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        var p = new MVCObject();
        n.k_changed = sinon.spy();
        p.k_changed = sinon.spy();
        n.bindTo('k', m); // first invoke
        p.bindTo('k', m, 'k', true); // no first invoke
        m.set('k', 1); // n second invoke, p first invoke
        n.k_changed.should.have.been.calledTwice;
        p.k_changed.should.have.been.calledOnce;
    });

    // it('SetNotifyKeyEvent', function() {
    //     m = new MVCObject
    //     spy = sinon.spy();
    //     m.addListener('k_changed', spy);
    //     m.set('k', 1);
    //     expect(spy.calledOnce).to.be.ok
    // });

    it('SetBind', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        m.set('k', 1);
        m.get('k').should.equal(1);
        should.not.exist(n.get('k'));
        n.bindTo('k', m);
        m.get('k').should.equal(1);
        n.get('k').should.equal(1);
    });

    it('BindSet', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        n.bindTo('k', m);
        m.set('k', 1);
        m.get('k').should.equal(1);
        n.get('k').should.equal(1);
    });

    it('BindSetBackwards', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        n.bindTo('k', m);
        n.set('k', 1);
        m.get('k').should.equal(1);
        n.get('k').should.equal(1);
    });

    it('SetBindBackwards', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        n.set('k', 1);
        n.bindTo('k', m);
        should.not.exist(m.get('k'));
        should.not.exist(n.get('k'));
    });

    it('BindSetUnbind', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        n.bindTo('k', m);
        n.set('k', 1);
        m.get('k').should.equal(1);
        n.get('k').should.equal(1);
        n.unbind('k');
        m.get('k').should.equal(1);
        n.get('k').should.equal(1);
        n.set('k', 2);
        m.get('k').should.equal(1);
        n.get('k').should.equal(2);
    });

    it('UnbindAll', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        n.bindTo('k', m);
        n.set('k', 1);
        m.get('k').should.equal(1);
        n.get('k').should.equal(1);
        n.unbindAll();
        m.get('k').should.equal(1);
        n.get('k').should.equal(1);
        n.set('k', 2);
        m.get('k').should.equal(1);
        n.get('k').should.equal(2);
    });

    it('BindNotify', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        m.bindTo('k', n);
        m.k_changed = sinon.spy();
        n.k_changed = sinon.spy();
        n.set('k', 1);
        m.k_changed.should.have.been.calledOnce;
        n.k_changed.should.have.been.calledOnce;
    });

    it('BindBackwardsNotify', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        n.bindTo('k', m);
        m.k_changed = sinon.spy();
        n.k_changed = sinon.spy();
        n.set('k', 1);
        m.k_changed.should.have.been.calledOnce;
        n.k_changed.should.have.been.calledOnce;
    });

    it('BindRename', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        n.bindTo('kn', m, 'km');
        m.set('km', 1);
        m.get('km').should.equal(1);
        n.get('kn').should.equal(1);
    });

    it('BindRenameCallbacks', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        m.km_changed = sinon.spy();
        n.kn_changed = sinon.spy();
        n.bindTo('kn', m, 'km');
        m.set('km', 1);
        m.get('km').should.equal(1);
        n.get('kn').should.equal(1);
        m.km_changed.should.have.been.calledOnce;
        n.kn_changed.should.have.been.calledTwice;
    });

    it('TransitiveBindForwards', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        var o = new MVCObject();
        n.bindTo('kn', m, 'km');
        o.bindTo('ko', n, 'kn');
        m.set('km', 1);
        m.get('km').should.equal(1);
        n.get('kn').should.equal(1);
        o.get('ko').should.equal(1);
    });

    it('TransitiveBindBackwards', function () {
        var m = new MVCObject();
        var n = new MVCObject();
        var o = new MVCObject();
        n.bindTo('kn', m, 'km');
        o.bindTo('ko', n, 'kn');
        o.set('ko', 1);
        m.get('km').should.equal(1);
        n.get('kn').should.equal(1);
        o.get('ko').should.equal(1);
    });

    it('Inheritance', function () {
        var spy = sinon.spy();

        function C() {}
        C.prototype = new MVCObject();
        c = new C();
        c.k_changed = spy;

        c.set('k', 1);
        c.get('k').should.equal(1);
        spy.should.have.been.calledOnce;
    });

    it('MrideyAccessors', function () {
        var a = new MVCObject();
        a.set('level', 2);
        a.get('level').should.equal(2);
        var b = new MVCObject();
        b.setValues({
            level: 2,
            index: 3,
            description: 'Hello world'
        });
        b.get('index').should.equal(3);
    });

    it('MrideyBinding', function () {
        var a = new MVCObject();
        a.set('level', 2);
        var b = new MVCObject();
        b.bindTo('index', a, 'level');
        b.get('index').should.equal(2);
        a.set('level', 3);
        b.get('index').should.equal(3);
        b.set('index', 4);
        a.get('level').should.equal(4);
        var c = new MVCObject();
        c.bindTo('zoom', a, 'level');
        c.get('zoom').should.equal(4);
        b.unbind('index');
        b.get('index').should.equal(4);
        c.set('zoom', 5);
        a.get('level').should.equal(5);
        b.get('index').should.equal(4);
    });

    it('CircularBind', function () {
        var a = new MVCObject();
        var b = new MVCObject();
        a.bindTo('k', b);
        should.throw(function () {
            b.bindTo('k', a);
        });
    });

    /*
    set(key, value):
    - 已经绑定过, target[setterName](key, value) || target.set(key, value);
    - 未绑定过的, self[key] = value
    - self[setterName] 不会被调用, 当有其它对象绑定到此对象时, 在其它对象上调用set(key, value)时会调用此对象的self[setterName]
    */
    it('Setter', function () {
        var a = new MVCObject();
        var x = undefined
        a.setX = sinon.spy();
        a.set('x', 1);
        a.get('x').should.equal(1);
        a.x.should.equal(1); // self[key] = value
        a.setX.should.not.have.been.called // 自己的self[setterName]() 未被调用
    });

    it('SetterBind', function () {
        var a = new MVCObject();
        a.setX = function (value) {
            this.x = value
        }
        sinon.spy(a, 'setX');
        var b = new MVCObject();
        b.bindTo('x', a);
        b.set('x', 1);
        a.get('x').should.equal(1);
        b.get('x').should.equal(1); // 最终调用a.get('x'), 但是a没有getX方法,所以直接返回a.x
        a.setX.should.have.been.calledOnce; // a[setterName]() 被调用
    });

    /*
    get(key):
    - 已经绑定过: target[getterName](key) || target.get(key);
    - 未绑定过: self[key]
    - self[getterName] 不会被调用, 当有其它对象绑定到此对象时, 在其它对象上调用get(key)时会调用此对象的self[getterName]
    - 自己原本有值, 只要绑定后, 就会被绑定过的值覆盖, 即可被覆盖的值为undefined
    */
    it('Getter', function () {
        var a = new MVCObject();
        a.getX = sinon.spy();
        a.x = 2
        a.get('x').should.equal(2); // 直接返回self[key]
        a.getX.should.not.have.been.called // getterName 未被调用
    });

    it('GetterBind', function () {
        var a = new MVCObject();
        a.getX = function () {
            return 1
        }
        sinon.spy(a, 'getX');
        var b = new MVCObject();
        b.bindTo('x', a);
        b.get('x').should.equal(1);
        a.getX.should.have.been.calledOnce;
    });

    it('Priority', function () {
        var a = new MVCObject();
        var b = new MVCObject();
        a.set('k', 1);
        b.set('k', 2);
        a.get('k').should.equal(1); // 未绑定之前
        b.get('k').should.equal(2);
        a.bindTo('k', b);
        a.get('k').should.equal(2); // 绑定之后
        b.get('k').should.equal(2);
    });

    it('PriorityUndefined', function () {
        var a = new MVCObject();
        var b = new MVCObject();
        a.set('k', 1);
        a.get('k').should.equal(1); // 未绑定之前
        a.bindTo('k', b);
        should.not.exist(a.get('k')); // 绑定之后
        should.not.exist(b.get('k'));
    });

    /*
        a -function() { b -function() { c
        |     |     |
    get('x')
    */
    it('Half stop search', function () { // 一条链上, 中途有getterName 方法, 则不再向上寻找.
        var a = new MVCObject
        var b = new MVCObject
        var c = new MVCObject

        a.bindTo('m', b);
        b.bindTo('m', c);

        b.getM = function () {
            return 1
        }
        c.getM = function () {
            return 2
        }
        sinon.spy(b, 'getM');
        sinon.spy(c, 'getM');

        a.get('m').should.equal(1);
        b.getM.should.have.been.calledOnce;
        c.getM.should.not.have.been.called
    });

    it('BindSelf', function () {
        var a = new MVCObject();
        should.throw(function () {
            a.bindTo('k', a);
        });
    });

    it('ChangedKey', function () {
        var a = new MVCObject();
        a.changed = sinon.spy();
        a.set('k', 1);
        a.changed.should.have.been.calledWith('k');
    });

    /*
    {property}_changed|changed
    在链的任何位置set一个值, 总是会先到达链的顶端将值保存下来,然后从顶端开始触发changed事件.

            a    ====>    b    ====>    c    ====>    d
                          ^             ^
                          |             |
                          |             |
                          e             f
    */
    it('more changed', function () {
        var a = new MVCObject();
        var b = new MVCObject();
        var c = new MVCObject();
        var d = new MVCObject();
        var e = new MVCObject();
        var f = new MVCObject();

        a.bindTo('k', b);
        b.bindTo('k', c);
        c.bindTo('k', d);
        e.bindTo('k', b);
        f.bindTo('k', c);

        a.k_changed = sinon.spy();
        b.k_changed = sinon.spy();
        c.k_changed = sinon.spy();
        d.k_changed = sinon.spy();
        e.k_changed = sinon.spy();
        f.k_changed = sinon.spy();

        a.setK = function (value) {
            this.set('k', value); // 理论上不会再向上set, 所以自身调用
        }

        b.setK = function (value) {
            this.set('k', value);
        }

        c.setK = function (value) {
            this.set('k', value);
        }

        d.setK = function (value) {
            this.set('k', value);
        }

        e.setK = function (value) {
            this.set('k', value);
        }

        f.setK = function (value) {
            this.set('k', value);
        }

        sinon.spy(a, 'setK');
        sinon.spy(b, 'setK');
        sinon.spy(c, 'setK');
        sinon.spy(d, 'setK');
        sinon.spy(e, 'setK');
        sinon.spy(f, 'setK');

        e.set('k', 1);

        e.setK.should.not.have.been.called

        b.setK.should.have.been.calledBefore(c.setK);
        c.setK.should.have.been.calledBefore(d.setK);

        d.k_changed.should.have.been.calledBefore(c.k_changed);

        c.k_changed.should.have.been.calledBefore(b.k_changed);
        c.k_changed.should.have.been.calledBefore(f.k_changed);

        b.k_changed.should.have.been.calledBefore(a.k_changed);
        b.k_changed.should.have.been.calledBefore(e.k_changed);
    });
});
