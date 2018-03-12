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

class Product < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :store

  delegate :name, to: :store, prefix: true
end
