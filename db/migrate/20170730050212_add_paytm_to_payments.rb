class AddPaytmToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :paytm, :decimal
  end
end
