# Controller for Debts.
# Contains the following public actions:
#     update - handles updating a debt appropriately.
# Primary author: Christian

# NOTE/TODO: Isn't this redundant? Can't we just call 
#            existing methods in the debt model?

class DebtsController < ApplicationController
  # Before every action, confirm that the user is signed in.
  before_filter :check_user_signed_in
  # Before updateing, check that the user owns
  # the debt he/she is updating.
  before_filter :authorize_user, only: [:update]

  # Update debts object after some transaction
  def update

    debt = Debt.find_by_id(params[:id])
    payment = params[:debt][:amount].to_i

    # Since the debted user is paying the indebted user,
    # we can simulate this as the indebted user "owing"
    # the debted user (a.k.a. the debt owner) the payed off
    # debt.
    Debt.settleDebt(debt.owner, debt.indebted, payment)
    flash[:success] = "Debt has been paid successfully."
    redirect_to root_url
  end

private
    # Checks that user is signed in.
    def check_user_signed_in
      if (not user_signed_in?)
        flash[:error] = "Please sign in."
        redirect_to root_url
      end
    end

    # Checks that the user modifying the
    # debt actually owns the debt.
    def authorize_user
      debt = Debt.find_by_id(params[:id])

      if (not current_user.id == debt.owner.id)
        flash[:error] = "You cannot pay the person's debt."
        redirect_to root_url
      end
    end

end
