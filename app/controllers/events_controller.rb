# Controller for Debts.
# Contains the following public actions:
#     new - used to display the event creation form.
#     create - handles creating an event from inputs in views/events/new.html.erb.
#     show - handles displaying an event.
#     destroy - used to delete an event (when a pending event is denied).
#     update - used to change the status of an event from pending to confirmed.

# Primary author: Angel

class EventsController < ApplicationController
  
  def new
    @event = Event.new

    # Populate previously entered fields if any.
    @event.title = params[:title] if not params[:title].blank?
    @event.description = params[:description] if not params[:description].blank?
    @event.amount = params[:amount] if not params[:amount].blank?

    # Populate initial participant field with current user's email.
    @event.contributions.build(email:current_user.email) 
    1.times {@event.contributions.build}
  end
  
 	def create
    # Note: This method is a hack.
    # Extract contribution attributes from params
    # and rebuild the params hash.
    contributionsInfo = event_params[:contributions_attributes]
    title = event_params.slice(:title)
    desc = event_params.slice(:description)
    amount = event_params.slice(:amount)
    newParams = title.merge(desc).merge(amount)
    
    # Check if emails are emails.
    # TODO check for duplicates....
    if User.validEmails?(contributionsInfo)
      # Check if valid contribution amounts.
      if Event.validContributions?(contributionsInfo, amount[:amount])
        # Create the event.
        @event = Event.new(newParams)
        # Save event and redirect appropriately.
        if @event.save
          # Create contributions and debts.
          @event.createContributions(contributionsInfo)
          @event.createDebts

          flash[:success] = "Event Created"
          redirect_to root_url
        else
          flash[:error] = "Please check your inputs"
          redirect_to new_event_path
        end
      else
        # Give error on invalid contributions.
        flash[:error] = "Please make sure amounts paid add up the event total."
        redirect_to new_event_path
      end
    else
      # Give error on invalid emails.
      flash[:error] = "Please check the email addresses entered."
      redirect_to new_event_path(:amount => event_params[:amount], 
        :title => event_params[:title], :description => event_params[:description])
    end
  end

  def show
      @event = Event.find_by_id(params[:id])
      @contributions = @event.contributions      
  end

	def destroy
        @event = Event.find_by_id(params[:id])
        @event.destroy
        flash[:success] = "Event deleted."
        redirect_to root_url
	end

	def update
    # TODO implement after implementing pending events.
  end

  private
    # Strong parameters for security (rails way)
    def event_params
        params.require(:event).permit(:title, :description, :amount, 
          contributions_attributes:[:email,:amount,:paid])
    end

end
