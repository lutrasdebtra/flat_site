class Payment < ActiveRecord::Base
  belongs_to :user
  
  validates_numericality_of :paysb, :payks, :paysc, :paykn
end
