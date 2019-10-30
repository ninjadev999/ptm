
# Set of general utility rake tasks for PTM
# or one-off tasks necessary for site maintenance and development.

namespace :ptm do

  desc "Re-index elasticsearch indices"
  task :reindex_elasticsearch => :environment do
    %w(User Interview).each do |klass|
      klass.constantize.import(force: true)
      puts "Imported #{klass}"
    end
  end

  def load_seeds(file)
    YAML.safe_load(File.read(File.join(__dir__, "#{file}.yml")), [Symbol])
  end

  task :create_bundles => :environment do
    Bundle.create!(name: "Single Interview", price_in_cents: 1499, number_of_interviews: 1, status: 1)
    Bundle.create!(name: "Bundle of 10 Interviews", price_in_cents: 11999, number_of_interviews: 10, status: 1)
    Bundle.create!(name: "Bundle of 30 Interviews", price_in_cents: 26999, number_of_interviews: 30, status: 1)
  end

  # Need to run this after 12/04/2018 update scoping cc's to users
  task :create_stripe_customers_for_all_users => :environment do
    User.all.each do |user|
      puts "Creating Stripe::Customer for #{user.full_name} (#{user.email})"
      user.create_stripe_customer!
      puts "\tstripe_customer_id: #{user.stripe_customer_id}"
    end
  end

  task :set_invite_account_ids => :environment do
    Invite.all.each do |invite|
      if !invite.interview.nil?
        invite.account_id = invite.interview.account_id
        invite.save(validate: false)
      end
    end
  end

  task :set_all_accounts_default_time_zone => :environment do
    tz_names = ActiveSupport::TimeZone.all.collect { |tz| tz.name }
    Account.all.each do |account|
      if account.time_zone.blank?
        account.time_zone = "Pacific Time (US & Canada)"
        account.save(validate: false)
      elsif !tz_names.include?(account.time_zone)
        puts "#{account.name} had an invalid time zone '#{account.time_zone}' -- resetting to default"
        account.time_zone = "Pacific Time (US & Canada)"
        account.save(validate: false)
      end
    end
  end

  desc "Check free trial users and send email to them, on 3 weeks, 1 week, 3 days ago"
  task :check_free_trial_expiration => :environment do 
    User.where(host: true).each do |user|
      unless user.host_subscription.present? or user.bundle_itv_remaining > 0
        expiration_day = (Time.now.to_i - user.created_at.to_i) / 86400
        if expiration_day == 31
          message = 'Your free trial expired.'
        elsif expiration_day == 29
          message = '1 day remained on your free trial.'
        elsif expiration_day == 16
          message = '2 weeks remained on your free trial.'
        elsif expiration_day == 9
          message = '3 weeks remained on your free trial.'
        else
          next
        end
        message = '' unless message.present?
        message += ' You need to purchase subscription or interview packs to continue.' 
        user.send_trial_expire(message)
      end
    end
  end

end
