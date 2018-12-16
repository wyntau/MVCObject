import { oBindings, oAccessors, oListeners, oObjectId } from './constant';
import { Accessor } from './accessor';
import { Binding } from './binding';
import { EventListener } from './eventListener';

let objectId = 0;

function capitalize(str: string): string {
  return capitalize[str] || (capitalize[str] = str.substr(0, 1).toUpperCase() + str.substr(1));
}

function getOid(obj: object): number {
  return obj[oObjectId] || (obj[oObjectId] = ++objectId);
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
    for (let key in bindings) {
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
  for (let id in listeners) {
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
  get<T = any>(key: string): T {
    const self = this;
    if (self[oAccessors] && hasOwnProperty(self[oAccessors], key)) {
      const { target, targetKey } = self[oAccessors][key];
      const getterName = getGetterName(targetKey);
      if (target[getterName]) {
        return target[getterName]();
      } else {
        return target.get(targetKey);
      }
    } else {
      return self[key];
    }
  }

  /**
   * set方法遍历依赖链直到找到key的持有对象设置key的值;
   * 有三个分支
   */
  set(key: string, value?: any): MVCObject {
    const self = this;
    if (self[oAccessors] && hasOwnProperty(self[oAccessors], key)) {
      const { target, targetKey } = self[oAccessors][key];
      const setterName = getSetterName(targetKey);
      if (target[setterName]) {
        target[setterName](value);
      } else {
        target.set(targetKey, value);
      }
    } else {
      this[key] = value;
      triggerChange(self, key);
    }
    return self;
  }

  changed(...args: any[]): any { }

  /**
   * 手动触发对应key的事件传播
   */
  notify(key: string): MVCObject {
    const self = this;
    if (self[oAccessors] && hasOwnProperty(self[oAccessors], key)) {
      const { target, targetKey } = self[oAccessors][key];
      target.notify(targetKey);
    } else {
      triggerChange(self, key);
    }
    return self;
  }

  setValues(values: object): MVCObject {
    const self = this;
    for (let key in values) {
      if (hasOwnProperty(values, key)) {
        const value = values[key];
        const setterName = getSetterName(key);
        if (self[setterName]) {
          self[setterName](value);
        } else {
          self.set(key, value);
        }
      }
    }
    return self;
  }

  /**
   * 将当前对象的一个key与目标对象的targetKey建立监听和广播关系
   */
  bindTo(key: string, target: MVCObject, targetKey: string = key, noNotify?: boolean): MVCObject {
    const self = this;
    self.unbind(key);

    self[oAccessors] || (self[oAccessors] = {});
    target[oBindings] || (target[oBindings] = {});
    target[oBindings][targetKey] || (target[oBindings][targetKey] = {});

    const binding = new Binding(self, key);
    const accessor = new Accessor(target, targetKey, binding);

    self[oAccessors][key] = accessor;
    target[oBindings][targetKey][getOid(binding)] = binding;

    if (!noNotify) {
      triggerChange(self, key);
    }

    return self;
  }

  /**
   * 解除当前对象上key与目标对象的监听
   */
  unbind(key: string): MVCObject {
    const self = this;
    if (!self[oAccessors] || !self[oAccessors][key]) {
      return self;
    }

    const { target, targetKey, binding } = self[oAccessors][key];
    self[key] = self.get(key);
    delete target[oBindings][targetKey][getOid(binding)];
    delete self[oAccessors][key];

    return self;
  }

  unbindAll(): MVCObject {
    const self = this;
    if (!self[oAccessors]) {
      return self;
    }
    const accessors = self[oAccessors];
    for (let key in accessors) {
      if (hasOwnProperty(accessors, key)) {
        self.unbind(key);
      }
    }
    return self;
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
}

export default MVCObject;
