class Payment < ActiveRecord::Base
  belongs_to :user

  validates_numericality_of :paysb, :payks, :paysc, :paykn
  validates :memo, presence: true
  validates_date :date, :on_or_before => lambda { Time.now.in_time_zone('Auckland').to_date }
end
