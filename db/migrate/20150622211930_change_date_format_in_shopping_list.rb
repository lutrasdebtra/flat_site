class ChangeDateFormatInShoppingList < ActiveRecord::Migration
  def up
    change_column :shopping_lists, :date, :date
  end

  def down
    change_column :shopping_lists, :date, :string
  end
end
