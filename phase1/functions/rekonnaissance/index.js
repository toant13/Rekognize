const redis = require('redis');
const uuidV4 = require('uuid/v4');

function getRedisClient(correlationId) {
  const lambdaEnv = (process.env.LAMBDA_ENV || 'AWS');
  console.log(`[CID=${correlationId}] Environment is: ${lambdaEnv}`);

  if (lambdaEnv === '') {
    console.error(`[CID=${correlationId}] lambda environment should've been set`);
    throw new Error('lambda environment should\'ve been set');
  }

  if (lambdaEnv === 'LOCAL') {
    return redis.createClient({ host: 'localhost', port: 6379 });
  }

  const elasticacheHost = (process.env.ELASTICACHE_HOST || 'localhost');
  return redis.createClient({
    host: elasticacheHost,
    port: 6379,
  });
}

function setRedisCallbacks(correlationId, redisClient) {
  redisClient.on('ready', () => {
    console.log(`[CID=${correlationId}] Redis is ready`);
    redisClient.quit();

    console.log(`[CID=${correlationId}] we good, so lets disconnect`);
  });

  redisClient.on('error', () => {
    console.log(`[CID=${correlationId}] Error connecting to redis`);
  });
}

exports.handler = function (e, ctx, cb) {
  const correlationId = uuidV4();

  const redisClient = getRedisClient(correlationId);
  setRedisCallbacks(correlationId, redisClient);

  console.log(`[CID=${correlationId}] Done!`);
  cb(null, { hello: 'world' });
};

