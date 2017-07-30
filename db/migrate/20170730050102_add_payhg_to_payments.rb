class AddPayhgToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :payhg, :decimal
  end
end
