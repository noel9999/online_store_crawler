# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  store_id   :integer
#  tags       :string           default("{}"), is an Array
#  name       :string
#  url        :string
#  image      :string
#  price      :integer
#  extra_info :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :product do
    name { Faker::Name.name }    
    tags{ Array.new(2) { Faker::StarWars.specie } }
    sequence(:url) { |n| "https://www.google.com.tw/search?source=hp&ei=rEKmWvikIcLR0ASLs5O4BQ&q=star+wars+#{n}" } 
    price 200
    store_id { create(:store).id }
  end
end
