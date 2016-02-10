var count = msg.payload.length;

var list = [];
for (i=0;i<count;i++) {
list.push({
        _id: msg.payload[i]._id,
        _rev: msg.payload[i]._rev,
        message: msg.payload[i].sensordatavalue.message,
        temp: msg.payload[i].sensordatavalue.temp,
        irtemp: msg.payload[i].sensordatavalue.irtemp,
        date: msg.payload[i].sensordatavalue.date,
        time: msg.payload[i].sensordatavalue.time,
        optical: msg.payload[i].sensordatavalue.optical,
        status: msg.payload[i].sensordatavalue.status,
        deviceId: msg.payload[i].sensordatavalue.deviceId,
        deviceType: msg.payload[i].sensordatavalue.deviceType,
        gtfs_latitude: msg.payload[i].sensordatavalue.gtfs_latitude,
        gtfs_longitude: msg.payload[i].sensordatavalue.gtfs_longitude,
        image: msg.payload[i].sensordatavalue.image,
        imageLocalURL: msg.payload[i].sensordatavalue.imageLocalURL,
        comment : msg.payload[i].sensordatavalue.comment
    });
}

msg.payload = {
                "docs":
                list
               }
return msg;
