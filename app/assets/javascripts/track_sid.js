// Stores Twilio Track SID information so that the audio/video
//  recordings can be cross-referenced later.
function createTrackSid(interview_code, track_sid, track_type) {
  var submit_data = { track_sid: track_sid, track_type: track_type };

  $.ajax({
    method: "POST",
    url: "/interviews/" + interview_code + "/create_track_sid",
    data: submit_data,
    dataType: "json"
  })
  .done(function( data ) {
    //console.log("Created Track SID");
    //console.log(data);
  });

}