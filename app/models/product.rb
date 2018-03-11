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
end
