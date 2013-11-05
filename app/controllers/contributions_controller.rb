# Controller for Contributions.
# Contains the following public actions:
#     approve - handles displaying approving a contribution.
#     decline - handles displaying declining a contribution.
# @ author Angel

class ContributionsController < ApplicationController
  # Before every action, confirm that the user is signed in.
  before_filter :check_user_signed_in
  # Before approve and decline, check that the user 
  # owns the contribution
  before_filter :authorize_user, only: [:approve, :decline]

  def approve
    if current_user.valid_password?(params[:password])
    
        # Confirm the contribution
        contribution = Contribution.find(params[:id])
        contribution.confirm!

        # Update event if a;; contributions have been confirmed.
        event = contribution.event
        event.confirm! if event.confirmed?

        respond_to do |format|
            format.html { 
                flash[:success] = "Thanks. That event has been confirmed."
                redirect_to root_url 
            }
            format.js
        end
    else
        flash[:error] = "Incorrect Password"
        redirect_to root_url 
    end
  end

  def decline
    # Delete the contribution/event
    contribution = Contribution.find(params[:id])
    contribution.decline!

    respond_to do |format|
        format.html { 
            flash[:success] = "Thanks. That event has been rejected."
            redirect_to root_url 
        }
        format.js
    end
  end

  private

    # Checks that user is signed in.
    def check_user_signed_in
      if (not user_signed_in?)
        flash[:error] = "Please sign in."
        redirect_to root_url
      end
    end

    # Checks that the user is owns the contribution
    # before performing the action.
    def authorize_user
      contribution = Contribution.find(params[:id])

      if (not (current_user.id == contribution.user.id) )
        flash[:error] = "You are not allowed to confirm that contribution."
        redirect_to root_url
      end
    end
end
