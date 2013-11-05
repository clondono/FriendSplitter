# Controller for Home page.
# Contains the following public actions:
#     index - handles displaying a information for logged in users.
# @ author Christian

class HomeController < ApplicationController

  def index
    # Get user info if signed in
    # Note: strong params not needed, since
    #       this simply displays a signed in
    #       user's info.
    if user_signed_in?
      allEvents = current_user.getEvents
      @events = allEvents["confirmed"]
      @pendingEvents = allEvents["pending"]

      @debts = current_user.debts
      @owed_debts = current_user.owed_debts
    end
  end

end
