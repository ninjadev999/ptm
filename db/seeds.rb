require 'ffaker'

def create_account(user)
  Account.create(admin: user, name: FFaker::Lorem.word, time_zone: ActiveSupport::TimeZone.all.sample.name)
end

def create_user
  email = FFaker::Internet.free_email
  email = FFaker::Internet.free_email while User.exists?(email: email)
  user = User.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: email, password: 'password', password_confirmation: 'password')
  account = create_account(user)

  5.times do
    create_interview(account)
  end

  puts "Created Profile: #{user.email}"
  user
end

def create_interview(account)
  starts_at = FFaker::Time.between(1.week.ago, 2.weeks.from_now)
  completed_at = starts_at + rand(3600 * 24).seconds if starts_at >= Date.today
  state = completed_at.nil? ? :waiting : :ended

  Interview.create!(account: account, starts_at: starts_at,
    completed_at: completed_at, state: state, name: FFaker::Lorem.word) do |i|
    i.topic = Topic.new(name: FFaker::Lorem.word)
    i.invites << Invite.new(name: FFaker::Name.name, email: FFaker::Internet.free_email)
  end
end

def create_bundles
  Bundle.create!(name: "Single Interview", price_in_cents: 1499, number_of_interviews: 1, status: 1)
  Bundle.create!(name: "Bundle of 10 Interviews", price_in_cents: 11999, number_of_interviews: 10, status: 1)
  Bundle.create!(name: "Bundle of 30 Interviews", price_in_cents: 26999, number_of_interviews: 30, status: 1)
end

def create_plans
  stripe_plans = Stripe::Plan.list
  stripe_plans.data.each do |stripe_plan|
    if stripe_plan.active
      Plan.create!(amount_in_cents: stripe_plan.amount || 100,
                  nickname: stripe_plan.nickname,
                  interval: stripe_plan.interval,
                  interval_count: stripe_plan.interval_count,
                  stripe_plan_id: stripe_plan.id)
   end
  end
  price_ordered = Plan.all.order('amount_in_cents ASC').limit(2)
  price_ordered[0].starter!
  price_ordered[1].professional!
  Plan.where(position: nil).map { |p| p.disabled! }
end

# Admin users
if AdminUser.count == 0
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end

# Users
if User.count == 0

  5.times do
    create_user
  end

  edge_case_user = User.last
  3.times do
    account = create_account(edge_case_user)
    puts "Added sub profile: #{account.name}"
  end

end

if Bundle.count == 0
  create_bundles
end

if Plan.count == 0
  create_plans
end

# Topics, Promotions, Expertise

