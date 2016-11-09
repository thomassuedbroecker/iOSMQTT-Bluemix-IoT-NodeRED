vvar count = msg.payload.length;

var list1 = [];
var list2 = [];
var msg1 = { payload:"default output 1"};
var msg2 = { payload:"default output 2"};

for (i=0;i<count;i++) {

   if (msg.payload[i].sensordatavalue.message !== undefined)
   {
       list1.push({
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
   } else {

      list2.push({
        _id: msg.payload[i]._id,
        _rev: msg.payload[i]._rev
      });
   }
}

msg1.payload = {
                 "docs":
                 list1
               }

msg2.payload = {
                 "docs":
                 list2
               }

return [msg1, msg2];
