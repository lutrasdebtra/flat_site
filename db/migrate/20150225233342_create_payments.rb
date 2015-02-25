class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date :date
      t.string :memo
      t.decimal :paysb
      t.decimal :payks
      t.decimal :paysc
      t.decimal :paykn

      t.timestamps null: false
    end
  end
end
