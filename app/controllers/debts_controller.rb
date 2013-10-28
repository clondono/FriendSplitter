# Controller for Debts.
# Contains the following public actions:
#     update - handles updating a debt appropriately.
# Primary author: Christian

class DebtsController < ApplicationController
  
  # Update debts object after some transaction
  def update
    @debt = Debt.find_by_id(params[:debt_id])
    @payment = params[:amount].to_i

    # Make sure the person paying the debt is
    # the user that is signed in.
    if current_user.id == @debt.owner.id

      if @debt.amount > @payment
        @debt.updateVal(@debt.amount-@payment)

      elsif @debt.amount == @payment
        @debt.destroy

      # Note: If a user tries to pay more than the debt,
      # we would simply consider the debt being paid
      # and ignore the excess amount.
      else
          @debt.destroy
      end
    else
      flash[:error] = "You cannot pay the person's debt."
      redirect_to root_url
    end
  end

end
