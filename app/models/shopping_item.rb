class ShoppingItem < ActiveRecord::Base
  belongs_to :shopping_list
  serialize :payees

  validates_numericality_of :price
  validates :memo, presence: true

  def checked(id)
    if payees
      if payees.include?(id.to_s)
        return true
      else
        return false
      end
    else
      return true
    end
  end
end
