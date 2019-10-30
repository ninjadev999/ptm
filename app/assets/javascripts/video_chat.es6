class VideoChat {
  constructor(accessToken, roomName, audio_video_option) {
    this.accessToken = accessToken;
    this.roomName = roomName; // interview code
    this.audio_video_option = audio_video_option;
    this.joined = false;
    this.room = null;
    this.participant_count = 0;
  }
  joinRoom(callback) {
    const dataTrack = new Twilio.Video.LocalDataTrack();
    $("#submit-data").off('click')
    $("#submit-data").on('click', (e) =>{
      e.preventDefault();
      var data = $("#data").val()
      $("#data").val('')
      dataTrack.send(data)
      var objDiv = $("#data-stream")
      objDiv.append("<div>Me: " + data +"</div>")
      objDiv.scrollTop(objDiv[0].scrollHeight);
      // $("#data-stream").append("<div>Me: " + data +"</div>")
    })

    var video_option = { width: window.VIDEO_WIDTH };
    if (this.audio_video_option == 'audio_only') {
      video_option = false;
    }
    Twilio.Video.createLocalTracks({
      audio: true,
      video: video_option,
      }).then(
        localTracks => {
          var tracks = localTracks.concat(dataTrack)
          Twilio.Video.connect(this.accessToken, { name: this.roomName, tracks: tracks, video: video_option, audio: true }).then(
            room => {
              room.localParticipant.videoTracks.forEach(function(ele) {
                // There should only be one
                createTrackSid(window.INTERVIEW_CODE, ele.trackSid, 'video')
              });

              room.localParticipant.audioTracks.forEach(function(ele) {
                // There should only be one
                createTrackSid(window.INTERVIEW_CODE, ele.trackSid, 'audio')
              })

              this.addMe(room, callback);
              room.participants.forEach(participant => {
                console.log('existing participantConnected');
                this.appendParticipant(participant)
              });
              room.on('participantDisconnected', participant => {
                console.log('participantDisconnected');
                this.removeParticipant(participant)
              });
              room.on('participantConnected', participant => {
                console.log('participantConnected');
                this.appendParticipant(participant)
              });
              room.on('disconnected', room => {
                console.log('disconnected');
                // Detach the local media elements
                room.localParticipant.videoTracks.forEach(publication => {
                  console.log('video disconnected');
                  const attachedElements = publication.track.detach();
                  publication.track.stop()
                  attachedElements.forEach(element => element.remove());
                });
                room.localParticipant.audioTracks.forEach(publication => {
                  console.log('audio disconnected');
                  const attachedElements = publication.track.detach();
                  publication.track.stop()
                  attachedElements.forEach(element => element.remove());
                });

                this.room = null;
              });
            },
            error => {
              alert(`Unable to connect to Room: ${error.message}`);
            }
          );
        },
        error => {
          this.toggleJoinLeaveButton(true);
          alert(`Check your Camera or Microphone: ${error.message}`)
        }
      );
  }
  addMeWithVideo(callback){
    Twilio.Video.createLocalVideoTrack().then(
      track => {
        const localMediaContainer = $("#my-video")
        localMediaContainer.append(track.attach());
        this.toggleJoinLeaveButton(false, track)
      },
      error => {
        alert(`Check your devices: ${error.message}`)
      }
    ).then(callback);
  }
  addMeWithAudio(callback){
    callback();
  }
  addMe(room, callback){
    this.room = room;
    if (this.audio_video_option == 'audio_only') {
      this.addMeWithAudio(callback);
      $("#participants").append("<div class='participant' id='name-me'>Me</div>")
      return;
    }

    this.addMeWithVideo(() => {
      callback();
      this.joined = true;
      $("#participants").append("<div class='participant' id='name-me'>Me</div>")
    })
  }

  removeMe(){
    $("#name-me").remove();
    this.room.participants.forEach(participant =>{
      this.removeParticipant(participant);
    })
    $("#my-video").html('')
    // debugger;
    this.room.disconnect();
    this.joined = false;
  }

  removeParticipant(participant){
    $(`#name-${participant.sid}`).remove();
    $(`#video-${participant.sid}`).remove();
    this.participant_count -= 1;
  }

  appendParticipant(participant){
    $("#participants").append(`<div class='participant' id='name-${participant.sid}'>${participant.identity}</div>`)

    participant.videoTracks.forEach(publication => {
      var $div = $("<div>", {id: `video-${participant.sid}`, class: 'participant-video'});
      if (publication.isSubscribed) {
        const track = publication.track;
        $div.append(track.attach());
      }
      $('#video-box').append($div);
    });

    participant.on('trackSubscribed', track => {
      console.log(`Participant "${participant.identity}" added ${track.kind} Track ${track.sid}`);
      if (track.kind === 'data') {
        track.on('message', data => {
          var objDiv = $("#data-stream")
          objDiv.append(`<div>${participant.identity}: ${data}</div>`)
          objDiv.scrollTop(objDiv[0].scrollHeight);
          // objDiv.scrollTop = objDiv.scrollHeight;
        });
      } else {
        $(`#video-${participant.sid}`).append(track.attach());
      }
    });
    this.participant_count += 1;
    if (this.participant_count >= 2) {
      $('.participant-video').addClass('multiple-participant-video');
    }
  }
  startTimer(){
    var start = Date.now();
    this.timer = setInterval(function() {
        var delta = Date.now() - start;
        var duration = Math.floor(delta / 1000)
        var hours = Math.floor(duration / 3600)
        duration = duration -(hours * 3600)
        var min = Math.floor(duration / 60)
        var seconds = duration - (min * 60)
        var formatted = ""
        if(hours > 0){
          formatted = hours + ":"
        }
        if(min < 10){
          formatted = formatted + "0" + min + ":"
        }else{
          formatted = formatted + min + ":"
        }
        if(seconds < 10){
          formatted = formatted + "0" + seconds
        } else {
          formatted = formatted + seconds
        }
        $("#clock").text(formatted); // in seconds
    }, 100);
  }
  stopTimer(){
    clearInterval(this.timer)
  }
  toggleJoinLeaveButton(join, track){
    if (join) {
      $('#call').on('click', (e) =>{
        $("#call").off('click')
        this.joinRoom(() => {
          var $btn = $(e.target);
          $btn.text('Leave Interview')
          $btn.removeClass('btn-info')
          $btn.addClass('btn-warning')
          $('#submit-data').removeClass('disabled');
          this.startTimer()
          this.toggleJoinLeaveButton(false);
        });
      });
    } else {
      $('#call').on('click', (e) =>{
        $("#call").off('click')
        this.stopTimer()
        var $btn = $(e.target);
        $btn.text('Join Interview')
        $btn.addClass('btn-info')
        $btn.removeClass('btn-warning')
        $('#submit-data').addClass('disabled');
        if (this.room) {
          this.removeMe();
        }
        if (track != undefined) {
          track.stop()
          track.detach()
        }
        this.toggleJoinLeaveButton(true);
      });
    }
  }
  joinToggled() {
    this.joinRoom(() => {
      var $btn = $('#call');
      $btn.text('Leave Interview')
      $btn.removeClass('btn-info')
      $btn.addClass('btn-warning')
      $('#submit-data').removeClass('disabled');
      this.startTimer()
      this.toggleJoinLeaveButton(false);
    });
  }
}
