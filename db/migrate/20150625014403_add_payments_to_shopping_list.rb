class AddPaymentsToShoppingList < ActiveRecord::Migration
  def change
    add_column :shopping_lists, :total, :decimal
    add_column :shopping_lists, :paysb, :decimal
    add_column :shopping_lists, :paysc, :decimal
    add_column :shopping_lists, :payks, :decimal
    add_column :shopping_lists, :paykn, :decimal
  end
end
