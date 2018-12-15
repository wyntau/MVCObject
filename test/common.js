"use strict";
global.chai      = require('chai');
global.sinon     = require('sinon');
global.should    = chai.should();
global.MVCObject = require('../').MVCObject;

var sinonChai = require('sinon-chai');
chai.use(sinonChai);