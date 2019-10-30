function beginAudiovisualCheck() {
  if (hasGetUserMedia()) {
    // Good to go!
    const video = document.querySelector('video');
    navigator.mediaDevices.getUserMedia(constraints).then((stream) => {video.srcObject = stream});
    startMicMeter();

    video.addEventListener("playing", function () {
        setTimeout(function () {
            console.log("Stream dimensions: " + video.videoWidth + "x" + video.videoHeight);
            if (video.videoWidth) {
              $('#video-width').html(video.videoWidth + " pixels");
            }
            if (video.videoHeight) {
              $('#video-height').html(video.videoHeight + " pixels");
              $('#detected-resolution').show();
              var resolution_name = getResolutionName(video.videoWidth, video.videoHeight);
              $('#resolution-name').html(resolution_name);
            }
        }, 1000);
    });

  } else {
    alert('Your webcam could not be detected. Please ensure you are on a desktop computer (not an iPhone or Android), your webcam is turned on, and that you are using a modern, updated browser (Chrome, Safari or Firefox).');
  }

}

function getResolutionName(width, height) {
  if ((width >= 1920) && (height >= 1080)) {
    return "1080p HD";
  }
  if ((width >= 1280) && (height >= 720)) {
    return "720p HD";
  }
  return "Standard Definition";
}

function hasGetUserMedia() {
  return !!(navigator.mediaDevices &&
    navigator.mediaDevices.getUserMedia);
}

function startMicMeter() {
        // grab our canvas
  canvasContext = document.getElementById( "meter" ).getContext("2d");

  // monkeypatch Web Audio
  window.AudioContext = window.AudioContext || window.webkitAudioContext;

  // grab an audio context
  audioContext = new AudioContext();

  // Attempt to get audio input
  try {
      // monkeypatch getUserMedia
      navigator.getUserMedia =
        navigator.getUserMedia ||
        navigator.webkitGetUserMedia ||
        navigator.mozGetUserMedia;

      // ask for an audio input
      navigator.getUserMedia(
      {
          "audio": {
              "mandatory": {
                  "googEchoCancellation": "false",
                  "googAutoGainControl": "false",
                  "googNoiseSuppression": "false",
                  "googHighpassFilter": "false"
              },
              "optional": []
          },
      }, gotStream, didntGetStream);
  } catch (e) {
      alert('There was a problem getting your microphone audio:' + e);
  }
}

function didntGetStream() {
  alert('Please reload this page and select "Allow" when prompted to allow use of the microphone.');
}

var mediaStreamSource = null;

function gotStream(stream) {
  // Create an AudioNode from the stream.
  mediaStreamSource = audioContext.createMediaStreamSource(stream);

  // Create a new volume meter and connect it.
  meter = createAudioMeter(audioContext);
  mediaStreamSource.connect(meter);

  // kick off the visual updating
  drawLoop();
}

function drawLoop( time ) {
  // clear the background
  canvasContext.clearRect(0,0,WIDTH,HEIGHT);

  // check if we're currently clipping
  if (meter.checkClipping())
      canvasContext.fillStyle = "red";
  else
      canvasContext.fillStyle = "green";

  // draw a bar based on the current volume
  canvasContext.fillRect(0, 0, meter.volume*WIDTH*1.4, HEIGHT);

  // set up the next visual callback
  rafID = window.requestAnimationFrame( drawLoop );
}