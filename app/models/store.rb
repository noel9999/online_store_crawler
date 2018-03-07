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
#

class Store < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
end
