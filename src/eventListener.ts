import { oListeners } from './constant';

let listenerId = 0;

export class EventListener {
  private id: number;
  constructor(private instance: Record<string, any>, private eventName: string, public handler: Function) { // eslint-disable-line
    this.id = ++listenerId;

    instance[oListeners] = instance[oListeners] || {};
    instance[oListeners][eventName] = instance[oListeners][eventName] || {};

    instance[oListeners][eventName][this.id] = this;
  }

  public remove() {
    const { instance, eventName } = this;
    instance[oListeners] = instance[oListeners] || {};
    instance[oListeners][eventName] = instance[oListeners][eventName] || {};
    delete instance[oListeners][eventName][this.id];
  }
}
