import typescript from 'rollup-plugin-typescript';
import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import {
  uglify
} from 'rollup-plugin-uglify';

const resolveOptions = {
  jsnext: true,
  main: true,
  browser: true,
};
const typescriptOptions = {
  typescript: require('typescript'),
  include: 'src/**',
  exclude: ['node_modules/**']
};

// 开发文件
const bundles = [{
  input: 'src/mvcobject.ts',
  output: {
    file: `dist/mvcobject.js`,
    name: 'MVCObject',
    format: 'umd',
    exports: 'named'
  },
  plugins: [
    resolve(Object.assign({}, resolveOptions)),
    commonjs(),
    typescript(Object.assign({}, typescriptOptions))
  ]
}, {
  input: 'src/mvcobject.ts',
  output: {
    file: `dist/mvcobject.min.js`,
    name: 'MVCObject',
    format: 'umd',
    exports: 'named'
  },
  plugins: [
    resolve(Object.assign({}, resolveOptions)),
    commonjs(),
    typescript(Object.assign({}, typescriptOptions)),
    uglify()
  ]
}, {
  input: 'src/mvcobject.ts',
  output: {
    file: `dist/mvcobject.esm.js`,
    format: 'esm'
  },
  plugins: [
    resolve(Object.assign({}, resolveOptions)),
    commonjs(),
    typescript(Object.assign({}, typescriptOptions))
  ]
}];

export default bundles;
