class EventsController < ApplicationController	
	def index
  	end

  def new
    @event = Event.new
    3.times {@event.contributions.build}    
  end
  
 	def create
    # Create the event.
    @event = Event.new(event_params)

    # Create contributions that belong to the event.
    @event.createContributions()

    # Save event and redirect appropriately.
    if @event.save
      flash[:success] = "Event Created"
      redirect_to root_url
    else
      render 'new'
    end

 		# @event = current_user.events.create(params[:event])
   #    	@event.createContributions(params[:contributions])
   #    	@event.createDebts()
   #    	respond_to do |format|
	  #       if @event.save
	  #         format.json { render json: @event, status: :created, location: @event }

	  #       else
	  #         format.html { render action: "new" }
	  #         format.json { render json: @event.errors, status: :unprocessable_entity }
	  #         format.js { render json: @event.errors, status: :unprocessable_entity }
	  #   	end
   #    	end
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




  private
    # Strong parameters for security (rails way)
    def event_params
      params.require(:event).permit(:title, :description, :amount)
    end

end