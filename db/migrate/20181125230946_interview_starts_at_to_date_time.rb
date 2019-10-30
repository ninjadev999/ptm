class InterviewStartsAtToDateTime < ActiveRecord::Migration[5.2]
  def change
    execute "ALTER TABLE interviews ALTER COLUMN starts_at TYPE timestamp with time zone"
  end
end
