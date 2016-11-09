if (msg.payload.length!== undefined) {
  var count = msg.payload.length;
  msg.payload = "Cloudant search contains in total (" + count + ") docs";
} else {
  msg.payload = "no valid data available";
}
return msg;
