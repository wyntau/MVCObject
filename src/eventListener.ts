import { LISTENERS } from './symbol';

let listenerId = 0;

export class EventListener {
  private id: number;
  constructor(private instance: Record<PropertyKey, any>, private eventName: string, public handler: Function) { // eslint-disable-line
    this.id = ++listenerId;

    instance[LISTENERS] = instance[LISTENERS] || {};
    instance[LISTENERS][eventName] = instance[LISTENERS][eventName] || {};

    instance[LISTENERS][eventName][this.id] = this;
  }

  public remove() {
    const { instance, eventName } = this;
    instance[LISTENERS] = instance[LISTENERS] || {};
    instance[LISTENERS][eventName] = instance[LISTENERS][eventName] || {};
    delete instance[LISTENERS][eventName][this.id];
  }
}
