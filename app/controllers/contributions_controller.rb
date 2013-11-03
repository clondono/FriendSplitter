# Controller for Contributions.
# Contains the following public actions:
#     approve - handles displaying approving a contribution.
#     decline - handles displaying declining a contribution.
# @ author Angel

class ContributionsController < ApplicationController

  def approve
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
  end

  def decline
    # Delete the contribution/event
    contribution = Contribution.find(params[:id])
    event = contribution.event
    contribution.destroy
    event.destroy

    respond_to do |format|
        format.html { 
            flash[:success] = "Thanks. That event has been rejected."
            redirect_to root_url 
        }
        format.js
    end
  end
end
