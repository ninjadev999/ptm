
function submitOptions() {
  var options_form = $(".edit_interview");
  var serialized = options_form.serialize();
  //console.log(serialized);
  $.ajax({url:'/interviews/' + window.INTERVIEW_ID + ".json",
          type:'PUT',
          data: serialized,
          success:function(result){
            goPrep();
          }
  });
}

function goPrep() {

  $( "#main-content-area" ).load( "/interviews/" + window.INTERVIEW_ID + "/live_room_html", function() {
    $('#step1').hide();
    $('#step3').show();
    $.fancybox.close();
    initPrepRoom();
  });

}

function initPrepRoom() {

  $.getJSON( "/interviews/" + window.INTERVIEW_CODE + "/prep", function( data ) {
    var chat = new VideoChat(data.access_token, data.room_name, data.interview.audio_visual_download_options);
    chat.joinToggled();
    $('#clock-container').hide();
  });

}