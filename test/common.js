"use strict";
require('coffee-script').register();
global.chai      = require('chai');
global.sinon     = require('sinon');
global.should    = chai.should();
global.MVCObject = require('../MVCObject.coffee');

var sinonChai = require('sinon-chai');
chai.use(sinonChai);