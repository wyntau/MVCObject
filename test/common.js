"use strict";
require('coffee-script');
global.chai      = require('chai');
global.sinon     = require('sinon');
global.expect    = chai.expect;
global.should    = chai.should();
global.MVCObject = require('../MVCObject.coffee');

var sinonChai = require('sinon-chai');
chai.use(sinonChai);