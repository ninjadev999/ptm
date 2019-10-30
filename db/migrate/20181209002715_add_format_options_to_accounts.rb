class AddFormatOptionsToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :max_resolution, :integer, default: 1
    add_column :accounts, :audio_visual_download_options, :integer, default: 1
    add_column :accounts, :audio_download_formats, :integer, default: 0

    Account.update_all(max_resolution: 1)
    Account.update_all(audio_visual_download_options: 0)
    Account.update_all(audio_download_formats: 0)
  end
end
