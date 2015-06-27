class CreateShoppingItems < ActiveRecord::Migration
  def change
    create_table :shopping_items do |t|
      t.string :memo
      t.decimal :price
      t.integer :shopping_list_id
      t.string :payees

      t.timestamps null: false
    end
  end
end
