# == Schema Information
#
# Table name: track_sids
#
#  id           :bigint(8)        not null, primary key
#  track_sid    :string
#  track_type   :integer          default("video")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  interview_id :integer
#  user_id      :integer
#
# Indexes
#
#  index_track_sids_on_track_sid  (track_sid)
#

class TrackSid < ApplicationRecord
  belongs_to :interview
  belongs_to :user

  enum track_type: { video: 0, audio: 1}

end
