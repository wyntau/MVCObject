import { oBindings, oAccessors, oListeners } from './constant';
import { Accessor } from './accessor';
import { Binding } from './binding';
import { EventListener } from './eventListener';
import { makeSymbol } from './symbol';

const OBJECT_ID = makeSymbol('objectId');
const BINDINGS = makeSymbol('bindings');
const ACCESSORS = makeSymbol('accesssors');
const LISTENERS = makeSymbol('listeners');

let objectId = 0;

function capitalize(str: string): string {
  return str.substr(0, 1).toUpperCase() + str.substr(1);
}

function getObjectId(obj: object): number {
  // @ts-ignore: 允许变量
  return obj[OBJECT_ID] || (obj[OBJECT_ID] = ++objectId);
}

function hasOwnProperty(instance: object, property: string): boolean {
  return Object.prototype.hasOwnProperty.call(instance, property);
}

function getGetterName(key: string): string {
  return `get${capitalize(key)}`;
}

function getSetterName(key: string): string {
  return `set${capitalize(key)}`;
}

/**
 * 这个函数的触发需要时机
 * 在一个key所在的终端对象遍历到时触发
 * 同时传播给所有直接、间接监听targetKey的对象
 * 在调用MVCObject的set方法时开始遍历
 */
function triggerChange(target: MVCObject, targetKey: string): void {
  const eventName = `${targetKey}_changed`;

  /**
   * 优先检测并执行目标对象key对应的响应方法
   * 其次检测并执行默认方法
   */
  if (target[eventName]) {
    target[eventName]();
  } else {
    target.changed(targetKey);
  }

  if (target[oBindings] && target[oBindings][targetKey]) {
    const bindings = target[oBindings][targetKey];
    for (const key in bindings) {
      if (hasOwnProperty(bindings, key)) {
        const binding = bindings[key];
        triggerChange(binding.binder, binding.binderKey);
      }
    }
  }

  if (!target[oListeners] || !target[oListeners][eventName]) {
    return;
  }
  const listeners = { ...target[oListeners][eventName] };
  for (const id in listeners) {
    const eventListener = listeners[id];
    if (eventListener && eventListener.handler) {
      eventListener.handler();
    }
  }
}

export class MVCObject {
  public static removeListener(eventListener: EventListener): void {
    if (eventListener) {
      eventListener.remove();
    }
  }
  /**
   * 从依赖链中获取对应key的值
   */
  public get<T = any>(key: string): T {
    if (this[oAccessors] && hasOwnProperty(this[oAccessors], key)) {
      const { target, targetKey } = this[oAccessors][key];
      const getterName = getGetterName(targetKey);
      if (target[getterName]) {
        return target[getterName]();
      } else {
        return target.get(targetKey);
      }
    } else {
      return this[key];
    }
  }

  /**
   * set方法遍历依赖链直到找到key的持有对象设置key的值;
   * 有三个分支
   */
  public set(key: string, value?: any): MVCObject {
    if (this[oAccessors] && hasOwnProperty(this[oAccessors], key)) {
      const { target, targetKey } = this[oAccessors][key];
      const setterName = getSetterName(targetKey);
      if (target[setterName]) {
        target[setterName](value);
      } else {
        target.set(targetKey, value);
      }
    } else {
      this[key] = value;
      triggerChange(this, key);
    }
    return this;
  }

  public changed(...args: any[]): any {} // eslint-disable-line

  /**
   * 手动触发对应key的事件传播
   */
  public notify(key: string): MVCObject {
    if (this[oAccessors] && hasOwnProperty(this[oAccessors], key)) {
      const { target, targetKey } = this[oAccessors][key];
      target.notify(targetKey);
    } else {
      triggerChange(this, key);
    }
    return this;
  }

  public setValues(values: Record<string, any>): MVCObject {
    for (const key in values) {
      if (hasOwnProperty(values, key)) {
        const value = values[key];
        const setterName = getSetterName(key);
        if (this[setterName]) {
          this[setterName](value);
        } else {
          this.set(key, value);
        }
      }
    }
    return this;
  }

  /**
   * 将当前对象的一个key与目标对象的targetKey建立监听和广播关系
   */
  public bindTo(key: string, target: MVCObject, targetKey: string = key, noNotify?: boolean): MVCObject {
    this.unbind(key);

    this[oAccessors] || (this[oAccessors] = {});
    target[oBindings] || (target[oBindings] = {});
    target[oBindings][targetKey] || (target[oBindings][targetKey] = {});

    const binding = new Binding(this, key);
    const accessor = new Accessor(target, targetKey, binding);

    this[oAccessors][key] = accessor;
    target[oBindings][targetKey][getObjectId(binding)] = binding;

    if (!noNotify) {
      triggerChange(this, key);
    }

    return this;
  }

  /**
   * 解除当前对象上key与目标对象的监听
   */
  public unbind(key: string): MVCObject {
    if (!this[oAccessors] || !this[oAccessors][key]) {
      return this;
    }

    const { target, targetKey, binding } = this[oAccessors][key];
    this[key] = this.get(key);
    delete target[oBindings][targetKey][getObjectId(binding)];
    delete this[oAccessors][key];

    return this;
  }

  public unbindAll(): MVCObject {
    if (!this[oAccessors]) {
      return this;
    }
    const accessors = this[oAccessors];
    for (const key in accessors) {
      if (hasOwnProperty(accessors, key)) {
        this.unbind(key);
      }
    }
    return this;
  }

  public addListener(eventName: string, handler: Function): EventListener {
    return new EventListener(this, eventName, handler);
  }

  public addListenerOnce(eventName: string, handler: Function): EventListener {
    const eventListener = new EventListener(this, eventName, () => {
      handler();
      eventListener.remove();
    });
    return eventListener;
  }

  public removeListener(eventListener: EventListener): void {
    MVCObject.removeListener(eventListener);
  }

  [x: string]: any;
}

export default MVCObject;
