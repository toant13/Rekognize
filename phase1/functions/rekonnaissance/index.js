"use strict";

const AWS = require("aws-sdk");
const _ = require('lodash');

exports.handle = function(e, ctx, cb) {
  console.log('processing event: %j', e)
  cb(null, { hello: 'world' })
}
