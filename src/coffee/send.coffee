exec = require('child_process').execFile;

fun = (topic, message)->
 exec('C:\\Program Files (x86)\\mosquitto\\mosquitto_pub.exe', ['-h', '54.93.150.126', '-t', topic, '-m', JSON.stringify(message)]);

module.exports = fun
