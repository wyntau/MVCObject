import { MVCObject } from './mvcobject';

export class Binding {
  constructor(public binder: MVCObject, public binderKey: string) { };
}
