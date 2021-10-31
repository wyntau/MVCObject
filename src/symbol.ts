const hasSymbol = typeof Symbol === 'function' && process.env._MVCObjectForceNoSymbol !== '1';
let makeSymbol: (key: string) => string | symbol;
if (hasSymbol) {
  makeSymbol = function (key: string) {
    return Symbol(key);
  };
} else {
  makeSymbol = function (key: string) {
    return `_mvcobject_${key}`;
  };
}

export { makeSymbol };

export const OBJECT_ID = makeSymbol('objectId');
export const BINDINGS = makeSymbol('bindings');
export const ACCESSORS = makeSymbol('accesssors');
export const LISTENERS = makeSymbol('listeners');
