class Payment < ActiveRecord::Base
  belongs_to :user

  User.all.each do |u|
    validates_numericality_of eval(":pay#{u.initials}")
  end
  validates :memo, presence: true
  validates_date :date, :on_or_before => lambda { Time.now.in_time_zone('Auckland').to_date }
end
