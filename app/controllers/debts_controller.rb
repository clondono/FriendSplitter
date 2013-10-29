# Controller for Debts.
# Contains the following public actions:
#     update - handles updating a debt appropriately.
# Primary author: Christian

# NOTE/TODO: Isn't this redundant? Can't we just call 
#            existing methods in the debt model?

class DebtsController < ApplicationController
  
  # Update debts object after some transaction
  def update

    @debt = Debt.find_by_id(params[:id]) #:debt_id])
    @payment = params[:debt][:amount].to_i

    # Make sure the person paying the debt is
    # the user that is signed in.
    if current_user.id == @debt.owner.id

      # If user repays less than debt, update debt amount 
      # by decreasing it
      if @debt.amount > @payment
        @debt.updateVal(@debt.amount-@payment)

      # If user repays the debt exactly, destroy the debt
      elsif @debt.amount == @payment
        @debt.destroy

      # If user pays more than the debt, destroy the debt and calculate
      # the new debt where the debt owner and indebted relationships
      # are now reversed  
      elsif @debt.amount < @payment
          newIndebted = @debt.owner
          newOwner = @debt.indebted
          newAmount = @payment - @debt.amount
          @debt.destroy
          newOwner.debts.create!(owner_id: newOwner.id, indebted_id: newIndebted.id, amount: newAmount)

      end
    else
      flash[:error] = "You cannot pay the person's debt."
    end
    redirect_to(root_url)
  end

end
