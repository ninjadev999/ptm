class InterviewPrepFormatFields < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :max_resolution, :integer, default: 1
    add_column :interviews, :audio_visual_download_options, :integer, default: 1
    add_column :interviews, :audio_download_formats, :integer, default: 0
    add_column :interviews, :prep_stage, :integer, default: 1

    Interview.update_all(max_resolution: 1)
    Interview.update_all(audio_visual_download_options: 0)
    Interview.update_all(audio_download_formats: 0)
    Interview.update_all(prep_stage: 1)

  end
end
