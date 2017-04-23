const test = require('./index.js');

test.handler('error', '{}', (someInput, json) => {
  console.log('value of callback', json);
});
