const redis = require('redis');

function getRedisClient() {
  const lambdaEnv = (process.env.LAMBDA_ENV || 'AWS');
  if (lambdaEnv === 'LOCAL') {
    return redis.createClient({ host: 'localhost', port: 6379 });
  }

  return redis.createClient({
    host: 'frequency-cluster.u2yttb.0001.use1.cache.amazonaws.com',
    port: 6379,
  });
}

exports.handler = function (e, ctx, cb) {
  console.log('changed backed to required', redis);

  const redisClient = getRedisClient();

  redisClient.on('ready', () => {
    console.log('Redis is ready');
  });

  redisClient.on('error', () => {
    console.log('Error in Redis');
  });

  console.log('processing event: %s', redisClient);
  cb(null, {hello: 'world'});
};

