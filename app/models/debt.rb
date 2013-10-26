# Debt model 

# Ensures a debt has a "owner" and a 
#   "indebted" user.

# @author Angel


class Debt < ActiveRecord::Base

  belongs_to :owner, class_name: "User"
  belongs_to :indebted, class_name: "User"
  validates :owner_id, presence: true
  validates :indebted_id, presence: true,
            :uniqueness => {:scope => :owner_id}
  validates :amount, presence: true

  def updateVal(newVal)
    update_attributes(amount: newVal)
  end

end
