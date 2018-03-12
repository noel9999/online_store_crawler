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

require 'rails_helper'

RSpec.describe Store, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_uniqueness_of :url }
  it { should validate_presence_of :key }
  it { should validate_uniqueness_of :key }
end
