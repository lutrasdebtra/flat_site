class ShoppingList < ActiveRecord::Base
	has_many :shopping_items, :dependent => :destroy

	accepts_nested_attributes_for :shopping_items, :allow_destroy => true
	validates :name, presence: true
	validates_date :date, :on_or_before => lambda { Time.now.in_time_zone('Auckland').to_date }
end
