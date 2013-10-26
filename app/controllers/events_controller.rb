class EventsController < ApplicationController	
	def index
  	end
  
 	def create
 		@event = current_user.events.create(params[:event])
      	@event.createContributions(params[:contributions])
      	@event.createDebts()
      	respond_to do |format|
	        if @event.save
	          format.json { render json: @event, status: :created, location: @event }

	        else
	          format.html { render action: "new" }
	          format.json { render json: @event.errors, status: :unprocessable_entity }
	          format.js { render json: @event.errors, status: :unprocessable_entity }
	    	end
      	end
  	end

	def destroy
	    @event = current_user.events.find(params[:id])
  	    @event.destroy

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