import { MVCObject } from './mvcobject';
import { Binding } from './binding';

export class Accessor {
  constructor(public target: MVCObject, public targetKey: string, public binding: Binding) { };
}
