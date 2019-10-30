## Pass The Microphone
Pass the Microphone is Video Chat software to support podcasters performing remote interviews.

### Twilio integration
- Pass the Mic uses The Twilio Video Api to support the live conference view.
- https://www.twilio.com/docs/video
- We use a combination of the js sdk and the ruby gem
- the rooms are created by ruby gem to enable recordings
- Callbacks go to twilio_controller#events where the case statement for events from twilio, change and effect the room
- Data Tracks are used to handle the chatbox on the live screen, which is another offering from the video sdk

### Recordings
- Recordings get sent to us from twilio as an event. "recording-completed"
- This fires off a sidekiq job that
  - saves the recording to s3
  - if it is an audio recording (mka format)
    - it then converts the recording to a wav file using ffmpeg on the servers (added through heroku buildpack)
    - And stores the wav file to s3

### Mailgun
- Basic plan, get 100k emails free to start.
- Set up via smtp settings in production.rb

### Authentication
  - User models use devise for auth.  They are Confimable, 10 day waiting period (set in devise.rb)
  - Also set through devise.rb is the email that the confirmations come from (noreply@passthemicrophone.com)
  - AdminUsers were added as the default through the active admin screen, but as far as I can tell not used anywhere

### Authorization
  - There's no authorization for Admin. Pundit is used for application authorization between guest and host.

### Active Admin
  - Straightfoward use case of the active_admin dashboard.  Right now, only Accounts, and Users are being shown.  But it can show any model that is in the db if you configure it in the `app/admin` folder

### Twilio_event_channel
  - this is the start of a action_cable channel to handle twilio events, but as it turns out the video sdk ships with a websocket implementation so development here was paused.  However it did work, so if your looking for a action cable example that might be a good place to start.

### Deployment
  - `production` branch should be deployed to prod heroku with this command: `git push heroku production:master`
  - `master` branch should be deployed to staging heroku with this commabd: `git push staging master` assuming that you have set git remote staging as staging heroku git url