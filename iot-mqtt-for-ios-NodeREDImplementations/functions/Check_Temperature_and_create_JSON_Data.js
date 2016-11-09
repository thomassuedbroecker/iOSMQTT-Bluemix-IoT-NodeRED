// Define different output options
var msg1 = { payload:"undefined"};
var msg2 = { payload:"undefined"};

// if msg !0 null begin
if ( msg !== null)
{
  // Check if there is any valid sensor data
  if ((msg.payload.d.AmbTemp === undefined) &&
      (msg.payload.d.ambient_temp === undefined) &&
      (msg.payload.d.temp === undefined)) {
      msg2.payload = "No valid Sensor IoT Data Input";
  } else {
    // Create data object
    data = new Object();

    // *****************
    // Get Data and time
    var currentdate = new Date();
    var the_minutes     = "00";
    var the_seconds     = "00";

    if ((currentdate.getMinutes() < 10)){
        the_minutes = "0"+currentdate.getMinutes();
    } else {
        the_minutes = currentdate.getMinutes();
    }

    if ((currentdate.getSeconds() < 10)){
        the_seconds = "0"+currentdate.getSeconds();
    } else {
        the_seconds = currentdate.getSeconds();
    }

    data.date   = currentdate.getDate() + "." + (currentdate.getMonth()+1)  + "." + currentdate.getFullYear();
    data.time   = currentdate.getHours() + ":"  + currentdate.getMinutes() + ":" + currentdate.getSeconds();
    data.image  = "undefined";
    data.imageLocalURI = "undefined";

    // *****************
    // Get the concrete Sensor data
    // the input can be different based on your device/app type:
    // "Apple, Android, Simulator do have different datastructure in the payload"
    //-----------------------------------------------------------------------
    data.temp = "20.0000"; // default
    if (msg.payload.d.AmbTemp !== undefined) {
        data.temp     = "" + msg.payload.d.AmbTemp + "";      // Typical Apple datastructure
    }

    if (msg.payload.d.ambient_temp !== undefined) {
        data.temp     = "" + msg.payload.d.ambient_temp + "";  // Typical Android datastructure
    }

    if (msg.payload.d.temp !== undefined) {
        data.temp     = "" + msg.payload.d.temp + "";          // Typical Simulator datastructure
    }

    //-------------------------IPTEMP-------------------------------------------------
    data.iptemp = 20.0000; //default
    if (msg.payload.d.IRTemp !== undefined) {
        data.irtemp   = "" + msg.payload.d.IRTemp + "";        // Typical Apple datastructure
    }

    if (msg.payload.d.object_temp !== undefined) {
        data.irtemp   = "" + msg.payload.d.object_temp + "";   // Typical Android datastructure
    }

    if (msg.payload.d.objectTemp !== undefined) {
        data.irtemp   = msg.payload.d.objectTemp + "";    // Typical Simulator datastructure
    }

    //-------------------------OPTICAL---------------------------------------------
    data.optical = 0; // default if not defined by others

    if (msg.payload.d.optical !== undefined) {
        data.optical  = "" + msg.payload.d.optical + "";      // Typical Apple datastructure
    }

    if (msg.payload.d.light !== undefined) {
        data.optical  = "" + msg.payload.d.light + "";      // Typical Android datastructure
    }

    //--------------------------------------------------------------------------
    data.deviceId = msg.deviceId; // Typical datastructure for all

    // *****************
    // Add your additional sensor data
    data.sensorImage = "img/sensor-detail.png";
    data.comment = "Currently no comment";
    if (data.sensorType !== undefined) {
       data.sensorType = "Simplelink SensorTag - TI.com";
    }
    data.image    = "undefined";
    data.imageLocalURI = "undefined";

    // *****************
    // Define your Device Type: Which ICON should be dispayed in the App?
    // ==================================================================
    // You can get the Device ID from your TI App on your mobile device.
    //
    // (iPad:94128ececff1) (iPhone:08b5cbcfa326) (Samsung:c4be84722b07)
    // http://www.w3schools.com/jsref/jsref_localecompare.asp
    var ipad = "94128ececff1";
    var iphone = "1247823ebf04"; // "08b5cbcfa326";
    var samsung = "c4be84722b07";
    var iosfakeapp = "123456789";

    if(data.deviceId.localeCompare("94128ececff1") == 0){
     data.deviceType="iPad";
     data.deviceImageURI="img/ipad.png";
    }

    if(data.deviceId.localeCompare("08b5cbcfa326") == 0){
     data.deviceType="iPhone";
     data.deviceImageURI="img/iphone.png";
    }

    if(data.deviceId.localeCompare("123456789") == 0){
     data.deviceType="iPhone";
     data.deviceImageURI="img/iphone.png";
     data.sensorType = "Fake App on iOS Device";
    }

    if(data.deviceId.localeCompare("c4be84722b07") == 0){
     data.deviceType="Samsung";
     data.deviceImageURI="img/samsung.png";
    } else {
     data.deviceType="Container";
     data.deviceImageURI="img/container.png";
    }

     // *****************
     // Ehningen 48.65891, 8.940540000000055
     // http://www.viewphotos.org/germany/coordinates-of-Ehningen-5390.html
     data.gtfs_latitude  = "48.6589";
     data.gtfs_longitude = "8.940540000000055";

     if (data.sensorType !== undefined ){
       data.sensorType = "Simplelink SensorTag - TI.com";
     }

     // ******************
     // Check Temperature and create message
     // ******************
     if ( data.temp < 25 )
     {
       data.message= data.date + "/" + data.time + " (" + data.temp + ") within safe limits";
       data.status ="SAFE";
     } else {
       data.message= data.date + "/" + data.time + " (" + data.temp + ") is in critical limits";
       data.status ="CRITICAL";
     }

     // *****************
     // Build data your own datastructure
     // -> create json root object
     sensorroot = new Object();
     sensorroot.sensordatavalue = data;

     // *****************
     // Set your data as the payload,
     // which will be used in the next node as input.
    msg1.payload = sensorroot;
  } // if check if there is any valid sensor data
} else {
    msg2.payload = "No valid Sensor IoT Data Input";

}// if else msg != null end

return [msg1,msg2];
