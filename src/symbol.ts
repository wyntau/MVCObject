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
