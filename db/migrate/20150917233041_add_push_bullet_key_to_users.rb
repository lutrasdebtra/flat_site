class AddPushBulletKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :push_key, :string
  end
end
