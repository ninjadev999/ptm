# frozen_string_literal: true
# == Schema Information
#
# Table name: accounts
#
#  id                              :bigint(8)        not null, primary key
#  address_line1                   :string
#  address_line2                   :string
#  audio_download_formats          :integer          default("wav_only")
#  audio_visual_download_options   :integer          default("audio_only")
#  city                            :string
#  country                         :string
#  description                     :text
#  downloads_per_episode           :bigint(8)
#  interviewer                     :boolean          default(FALSE)
#  max_resolution                  :integer          default("resolution_720p")
#  max_units                       :integer          default(1), not null
#  name                            :string
#  social_media_followers          :bigint(8)
#  state                           :string
#  time_zone                       :string
#  wants_help_finding_interviewees :boolean          default(FALSE)
#  zip_code                        :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  admin_id                        :integer
#  stripe_customer_id              :string
#
# Indexes
#
#  index_accounts_on_admin_id            (admin_id)
#  index_accounts_on_stripe_customer_id  (stripe_customer_id)
#

require "rails_helper"

class FakeStripe
  def id
    "ID String"
  end
  def [](key)
    "Random Key"
  end
end

describe Account, type: :model do
  context "new" do
    it "creates a new account_user" do
      user = build_stubbed(:user)
      account = Account.new(admin: user, name: "Name")
      expect(user.account_users.size).to eq(0)
      account.save
      expect(account.persisted?).to be_truthy
      expect(account.admin).to eq(user)
      expect(account.account_users.pluck(:user_id)).to include(user.id)
    end
  end

  xdescribe "new_order?" do
    let(:account) { create :account }
    it "returns false if no subscription exists" do
      account.subscription = nil
      account.save
      expect(account.new_order?).to eq false
    end
    it "returns false if subscription not ok" do
      allow(Stripe::Subscription).to receive(:create).and_return(FakeStripe.new)
      sub = create :subscription, account: account
      allow(sub).to receive(:ok?).and_return(false)
      expect(account.new_order?).to eq false
    end
    it "returns false if there are more or equal oustanding orders to max units" do
      allow(Stripe::Subscription).to receive(:create).and_return(FakeStripe.new)
      create :order, account: account
      sub = create :subscription, account: account
      expect(account.new_order?).to eq false
    end
    it "returns true if there are more or max units than outstanding orders" do
      allow(Stripe::Subscription).to receive(:create).and_return(FakeStripe.new)
      create :order, account: account, aasm_state: "completed"
      sub = create :subscription, account: account
      expect(account.new_order?).to eq true
    end
  end

  xdescribe "new order reason" do
    let(:account) { create :account }
    it "returns no subscription if no subscription exists" do
      account.subscription = nil
      account.save
      expect(account.new_order_reason).to eq "Your account has no subscription."
    end
    it "returns not in good standing if subscription not ok" do
      allow(Stripe::Subscription).to receive(:create).and_return(FakeStripe.new)
      sub = create :subscription, account: account
      allow(sub).to receive(:ok?).and_return(false)
      expect(account.new_order_reason).to eq "Your subscription is not in good standing."
    end
    it "returns reached max units if there are more or equal oustanding orders to max units" do
      allow(Stripe::Subscription).to receive(:create).and_return(FakeStripe.new)
      create :order, account: account
      sub = create :subscription, account: account
      expect(account.new_order_reason).to eq "You have reached your current number of outstanding units."
    end
    it "returns nil if there are more or max units than outstanding orders" do
      allow(Stripe::Subscription).to receive(:create).and_return(FakeStripe.new)
      create :order, account: account, aasm_state: "completed"
      sub = create :subscription, account: account
      expect(account.new_order_reason).to eq nil
    end
  end
end
