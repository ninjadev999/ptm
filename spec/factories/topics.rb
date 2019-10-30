# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id   :bigint(8)        not null, primary key
#  name :string
#


FactoryBot.define do
  factory :topic do
    name { FFaker::Lorem.word }
  end
end
