const AWS = require('aws-sdk');

exports.handle = function (e, ctx, cb) {
  const elasticache = new AWS.ElastiCache({ apiVersion: '2015-02-02' });

  console.log('processing event: %s', elasticache);
  cb(null, { hello: 'world' });
}
