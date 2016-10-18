var mqtt = require('mqtt');
var tri = require('./trilateration');


// constants
var xMinBound = 0;
var xMaxBound = 1000; // cm
var yMinBound = 0;
var yMaxBound = 1000;
var zMinBound = 0;
var zMaxBound = 280;

function beaconMacToPos(mac)
{
    switch(mac.substr(0,5))
    {
        // x, y, z in centimeters
        case "11:76":
        case "7E:C4":
        case "7D:B5":
        case "6F:35":
        case "57:D7":
            return {x: 1, y: 1, z: 0}
        case "B6:DB":
        case "8E:1D":
        case "C6:1A":
            return {x: 3, y: 4, z: 1}
        default:
            return null
    }
}

function rssiToDistance(x)
{
    var result = -0.0012381*x*x*x-0.0271429*x*x+2.19524*x+62
    console.log(x + "->" + result)
    return result
}

function approximatePosition(L)
{
    function checkPoint(p)
    {
        if (p.x < xMinBound || p.x > xMaxBound)
        {
            return false;
        }
        else if (p.y < yMinBound || p.y > yMaxBound)
        {
            return false;
        }
        else if (p.z < zMinBound || p.z > zMaxBound)
        {
            return false;
        }
        return true;
    }

    function average(points)
    {
        var result = [0, 0, 0];
        for (i=0; i<points.length; i++)
        {
            result[0] += points[i].x;
            result[1] += points[i].y;
            result[2] += points[i].z;
        }
        for (i=0; i<result.length; i++)
        {
            result[i] /= points.length;
        }
        return result;
    }

    var results = [];

    for (i=0; i<L.length; i++)
    {
        for (j=i+1; j<L.length; j++)
        {
            for (h=j+1; h<L.length; h++)
            {
                var solution = tri.tri(L[i], L[j], L[h], true);
                if (solution != null && checkPoint(solution))
                {
                    results.push(solution);
                }
            }
        }
    }
    if (results.length > 1)
    {
        return average(results)
    }
    return null
}

var client = mqtt.connect('mqtt://54.93.150.126', {
    protocolId: 'MQIsdp',
    protocolVersion: 3
})
client.on('connect', function () {
    console.log('connected')
    client.subscribe('team1_read')
})


var positions = []
client.on('message', function (topic, message) {
    var msg = (message.toString())
    d = JSON.parse(msg)
    var pos = beaconMacToPos(d.baddr)
    if (pos != null)
    {
        // beacon
        pos.r = rssiToDistance(parseInt(d.rssi))
        positions.push(pos)
    }


    if (positions.length > 5)
    {
        // enough data, approximate positions
        var position = approximatePosition(positions);
        console.log(approximatePosition(positions))
        if(position != null)
        {
            var positionObject = {
              "x" : position[0],
              "y" : position[1],
              "z" : position[2]
            };
            client.publish(positionTopic, JSON.stringify(positionObject));
        }

        positions = []
    }
})
