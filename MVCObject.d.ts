export declare class Accessor {
    target: MVCObject;
    targetKey: string;
    constructor(target: MVCObject, targetKey: string);
}
export declare class MVCObject {
    /**
     * @description 从依赖链中获取对应key的值
     * @param {String} key 关键值
     * @return {mixed} 对应的值
     */
    get<T>(key: string): T;
    /**
     * @description set方法遍历依赖链直到找到key的持有对象设置key的值;
     * 有三个分支
     * @param {String} key 关键值
     * @param {all} value 要给key设定的值,可以是所有类型
     * @return {this}
     */
    set(key: string, value?: any): MVCObject;
    /**
     * @description 没个MVCObject对象各自的响应对应的key值变化时的逻辑
     */
    changed(...args: any[]): any;
    /**
     * @description 手动触发对应key的事件传播
     * @param {String} key 关键值
     * @return {this}
     */
    notify(key: string): MVCObject;
    setValues(values: any): MVCObject;
    /**
     * @description 将当前对象的一个key与目标对象的targetKey建立监听和广播关系
     * @param key {String} 当前对象上的key
     * @param target {Object} 目标对象
     * @param tarrgetKey {String} 目标对象上的key
     * @param noNotify {Boolean}
     * @return {Accessor}
     */
    bindTo(key: string, target: MVCObject, targetKey?: string, noNotify?: boolean): MVCObject;
    /**
     * @description 解除当前对象上key与目标对象的监听
     * @param {String} key 关键字
     * @return {this}
     */
    unbind(key: string): MVCObject;
    unbindAll(): MVCObject;
}
export default MVCObject;
