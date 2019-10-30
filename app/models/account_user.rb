# frozen_string_literal: true

# == Schema Information
#
# Table name: account_users
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#  user_id    :integer
#
# Indexes
#
#  index_account_users_on_account_id_and_user_id  (account_id,user_id)
#


class AccountUser < ApplicationRecord
  belongs_to :account, dependent: :destroy
  belongs_to :user, dependent: :destroy

  validates_uniqueness_of :user_id, scope: [:account_id]
end
