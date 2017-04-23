const redis = require('redis');

exports.handler = function (e, ctx, cb) {
  // const redisClient = redis.createClient({ host: 'frequency-cluster.u2yttb.0001.use1.cache.amazonaws.com', port: 6379 });
  const redisClient = redis.createClient({host: 'localhost', port: 6379});

  redisClient.on('ready', () => {
    console.log('Redis is ready');
  });

  redisClient.on('error', () => {
    console.log('Error in Redis');
  });

  console.log('processing event: %s', redisClient);
  cb(null, { hello: 'world' });
};
