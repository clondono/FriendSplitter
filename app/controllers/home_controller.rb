# Controller for Home page.
# Contains the following public actions:
#     index - handles displaying a information for logged in users.
# @ author Christian

class HomeController < ApplicationController

  def index
    #Get user info if signed in
    if user_signed_in?
      allEvents = current_user.getEvents
      @events = allEvents["confirmed"]
      @pendingEvents = allEvents["pending"]

      @debts = current_user.debts
      @owed_debts = current_user.owed_debts
    end
  end

end
