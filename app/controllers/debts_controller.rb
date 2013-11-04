# Controller for Debts.
# Contains the following public actions:
#     update - handles updating a debt appropriately.
# Primary author: Christian

# NOTE/TODO: Isn't this redundant? Can't we just call 
#            existing methods in the debt model?

class DebtsController < ApplicationController
  
  # Update debts object after some transaction
  def update

    debt = Debt.find_by_id(params[:id])
    payment = params[:debt][:amount].to_i

    # Make sure the person paying the debt is
    # the user that is signed in.
    if current_user.id == debt.owner.id
      # Since the debted user is paying the indebted user,
      # we can simulate this as the indebted user "owing"
      # the debted user (a.k.a. the debt owner) the payed off
      # debt.
      Debt.settleDebt(debt.owner, debt.indebted, payment)
    else
      flash[:error] = "You cannot pay the person's debt."
    end
    redirect_to(root_url)
  end

end
