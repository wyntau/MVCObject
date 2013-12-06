"use strict";
global.chai      = require('chai');
global.sinon     = require('sinon');
global.expect    = chai.expect;
global.should    = global.chai.should();

var sinonChai = require('sinon-chai');
chai.use(sinonChai);