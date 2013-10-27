class EventsController < ApplicationController	
	def index
  	end

  def new
    @event = Event.new
    1.times {@event.contributions.build}    
  end
  
 	def create
    # Extract contribution attributes from params
    # and rebuild the params hash.
    contributionsInfo = event_params.slice(:contributions_attributes)
    title = event_params.slice(:title)
    desc = event_params.slice(:description)
    amount = event_params.slice(:amount)
    newParams = title.merge(desc).merge(amount)
    
    # Create the event.
    @event = Event.new(newParams)

    #TODO check if valid contribution amounts.
    # Create method in model and call it...

    # Save event and redirect appropriately.
    if @event.save
      # Create contributions that belong to the event.
      @event.createContributions(contributionsInfo)

      flash[:success] = "Event Created"
      redirect_to root_url
    else
      render 'new'
    end

  end

	def destroy
	end

	def update
  end




  private
    # Strong parameters for security (rails way)
    def event_params
      params.require(:event).permit(:title, 
        :description, :amount, contributions_attributes:[:email,:amount,:paid])
    end

end