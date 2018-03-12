class AddColumnNameKeyToStore < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :key, :string, index: true
    Store.find_each do |store|
      store.key = store.name
      store.save
    end
  end
end
