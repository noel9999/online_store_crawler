class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    enable_extension "hstore"

    create_table :products do |t|
      t.belongs_to :store
      t.string :tags, array: true, default: []
      t.string :name, index: true
      t.string :url, index: true, unique: true
      t.string :image
      t.integer :price
      t.hstore :extra_info
      t.timestamps
    end
  end
end
