# == Schema Information
#
# Table name: stores
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  key         :string
#

FactoryGirl.define do
  factory :store do
    name 'JediStore'
    sequence(:url) { |n| "https://swgoh.gg/#{n}_stor" }
    sequence(:key) { |n| "jedi_store_#{n}" }
  end
end
