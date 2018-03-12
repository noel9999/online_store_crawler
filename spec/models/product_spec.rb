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

require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_uniqueness_of :url }
  it { should validate_presence_of :price }
  it { should validate_numericality_of(:price).only_integer }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
end
