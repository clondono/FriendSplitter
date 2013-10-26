# Controller for Debts.
# Contains the following public actions:
#     create - 
#     update - 
#     destroy - 

class DebtsController < ApplicationController

def index
end
  
def create
	 	@debt = current_user.debts.create(params[:debts])

		respond_to do |format|
	        if @debt.save
	          format.json { render json: @debt, status: :created, location: @debt }

	        else
	          format.html { render action: "new" }
	          format.json { render json: @debt.errors, status: :unprocessable_entity }
	          format.js { render json: @debt.errors, status: :unprocessable_entity }
	    	end
	  	end
  	end

	def destroy
	    @debt = current_user.debts.find(params[:id])
  	    @debt.destroy

        respond_to do |format|
        	#TODO fix
          format.html { redirect_to posts_url }
          format.json { head :no_content }
          format.js { head :no_content}
        end
  	end
  	
  	def update
  	end
end
