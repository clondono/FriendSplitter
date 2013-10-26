class ContributionsController < ApplicationController	
	def index
  	end
  
 	def create
	 	@contribution = current_user.contributions.create(params[:contributions])

		respond_to do |format|
	        if @contribution.save
	          format.json { render json: @contribution, status: :created, location: @contribution }

	        else
	          format.html { render action: "new" }
	          format.json { render json: @contribution.errors, status: :unprocessable_entity }
	          format.js { render json: @contribution.errors, status: :unprocessable_entity }
	    	end
	  	end
  	end

	def destroy
	    @contribution = current_user.contributions.find(params[:id])
  	    @contribution.destroy

        respond_to do |format|
        	#TODO fix
          format.html { redirect_to posts_url }
          format.json { head :no_content }
          format.js { head :no_content}
        end
  	end
end