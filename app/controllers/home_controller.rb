class HomeController < ApplicationController

    def index
        #Get user info if signed in
        if user_signed_in?
            @participationInEvent = current_user.participationInEvent
            @contributions = current_user.contributions
            @debts = current_user.debts
            @owed_debts = current_user.owed_debts
            # At some point, somewhere, need to make sure that debts tha aref ully paid get deleted!
        end

    end
end
