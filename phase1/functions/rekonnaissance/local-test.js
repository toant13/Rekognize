const test = require('./index.js');

// just generic call now, but will need to change to use actual testing framework
test.handler('error', '{}', (someInput, json) => {
  console.log('value of callback', json);
});
