class InterviewDecorator < Draper::Decorator
  delegate_all

  def starts_at_in_account_time_zone
    time = if account.present?
      starts_at&.in_time_zone(account.time_zone)
    else
      starts_at
    end
    time || 'Unscheduled'
  end

  def completed_at_in_account_time_zone
    time = if account.present?
      completed_at&.in_time_zone(account.time_zone)
    else
      completed_at
    end
    time || 'N/A'
  end

end
