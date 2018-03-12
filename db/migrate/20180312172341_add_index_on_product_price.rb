class AddIndexOnProductPrice < ActiveRecord::Migration[5.1]
  def change
    add_index :products, :price    
  end
end
