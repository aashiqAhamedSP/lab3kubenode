var express = require('express')
const process = require('process');

var expressapp = express()
expressapp.get('/', function (req, res) {
    res.send('{"message":"Hello World Javascript Nuvepro v1 from jenkins now"}')
})
expressapp.listen(5001, function () {
    console.log('Ready on port 5001!')
})

/* To Handle Ctrl C*/
process.on('SIGINT', function () {
    process.exit();
});
