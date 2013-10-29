# Debt model 

# Ensures a debt has a "owner", a 
# "indebted" user, and an amount.

# @author Angel

class Debt < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  belongs_to :indebted, class_name: "User"
  validates :owner_id, presence: true
  validates :indebted_id, presence: true,
            :uniqueness => {:scope => :owner_id}
  validates :amount, presence: true

  # Updates the debt.
  def updateVal!(newVal)
    update_attributes(amount: newVal)
  end

  # Handles settling a debt between users, taking
  # into consideration previous debts.
  # 
  # Paramters
  # owedUser - user who is owed money
  # debtedUser - user who owes money
  # debtAmount - amount that debtedUser owes owedUser
  def self.settleDebt(owedUser, debtedUser, debtAmount)
      # If the owedUser has a previous debt due
      # by the debtedUser, simply increase that debt
      if debtedUser.owes?(owedUser)
          debt = debtedUser.debts.find_by(owner_id: debtedUser.id, indebted_id: owedUser.id)
          debt.updateVal!(debt.amount + debtAmount)

      # If the owedUser previously owed the debtedUser,
      # reduce that debt appropriately.       
      elsif owedUser.owes?(debtedUser)
          debt = owedUser.debts.find_by(owner_id: owedUser.id, indebted_id: debtedUser.id)
          newDebt = debt.amount - debtAmount

          if newDebt > 0
              debt.updateVal!(newDebt)
          elsif newDebt < 0
              debt.destroy!
              newDebt = newDebt * -1
              Debt.create!(owner_id: debtedUser.id, indebted_id: owedUser.id, amount: newDebt)
          else
              debt.destroy!
          end

      # If there is no debt between these users, 
      # simply create it.
      else
          Debt.create!(owner_id: debtedUser.id, indebted_id: owedUser.id, amount: debtAmount)
      end
  end

end
