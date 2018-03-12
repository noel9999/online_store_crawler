class CreateStoreData < ActiveRecord::Migration[5.1]
  def up
    [
      {
        key: 'rt_mart',
        name: '大潤發',
        url: 'http://www.rt-mart.com.tw/direct/'
      }, {
        key: 'wellcome',
        name: '頂好',
        url: 'https://sbd-ec.wellcome.com.tw'
      }
    ].each do |data|
      Store.create data
    end
  end

  def down
    %w(rt_mart wellcome).each do |key|
      Store.find_by(key).destroy
    end
  end
end
