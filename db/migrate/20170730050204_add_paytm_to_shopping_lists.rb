class AddPaytmToShoppingLists < ActiveRecord::Migration[5.1]
  def change
    add_column :shopping_lists, :paytm, :decimal
  end
end
