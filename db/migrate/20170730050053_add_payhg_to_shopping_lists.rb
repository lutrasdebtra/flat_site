class AddPayhgToShoppingLists < ActiveRecord::Migration[5.1]
  def change
    add_column :shopping_lists, :payhg, :decimal
  end
end
