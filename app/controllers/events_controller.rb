# Controller for Debts.
# Contains the following public actions:
#     new - used to display the event creation form.
#     create - handles creating an event from inputs in views/events/new.html.erb.
#     show - handles displaying an event.
#     destroy - used to delete an event (when a pending event is denied).

# Primary author: Angel

class EventsController < ApplicationController
  before_filter :check_user_signed_in
  before_filter :authorize_user, only: [:show, :destroy]

  def new
    @event = Event.new

    # Populate previously entered fields if any.
    @event.title = params[:title] if not params[:title].blank?
    @event.description = params[:description] if not params[:description].blank?
    @event.amount = params[:amount] if not params[:amount].blank?

    # Populate initial participant field with current 
    # user's email if no contributions
    if params[:contributions].blank?
      @event.contributions.new(email:current_user.email) 
      2.times {@event.contributions.new}
    else
      params[:contributions].each do |key, contribution|
        @event.contributions.new(contribution)
      end
    end
  end

  def create
    contributions = contributions_params[:contributions_attributes]
    # delete elements in contributions param array with empty email
    contributions.delete_if do |index|
      true if contributions[index]["email"].empty?
    end

    # Check if emails are valid emails.
    if User.validEmails?(contributions)
      # Check if valid contribution amounts.
      if Event.validContributions?(contributions, event_params[:amount])
        # Create the event.
        @event = Event.new(event_params)
        # Save event and redirect appropriately.
        if (@event.save and isNumber?(event_params[:amount]))
          # Create pending contributions.
          @event.createContributions(contributions)

          flash[:success] = "Event Created"
          redirect_to root_url
        else
          # Give error on invalid event inputs.
          flash[:error] = "Please enter a title, description, and an amount."
          redirect_to new_event_path(:amount => event_params[:amount], 
                             :title => event_params[:title], 
                             :description => event_params[:description],
                             :contributions => contributions)
        end
      else
        # Give error on invalid contributions.
        flash[:error] = "Please make sure amounts paid add up the event total."
        redirect_to new_event_path(:amount => event_params[:amount], 
                               :title => event_params[:title], 
                               :description => event_params[:description],
                               :contributions => contributions)
      end
    else
      # Give error on invalid emails.
      flash[:error] = "Please check the email addresses."
      redirect_to new_event_path(:amount => event_params[:amount], 
                                 :title => event_params[:title], 
                                 :description => event_params[:description],
                                 :contributions => contributions)
    end
  end

  def show
    @event = Event.find_by_id(params[:id])
    @contributions = @event.contributions      
  end

  def destroy
    @event = Event.find_by_id(params[:id])
    @event.destroy
    flash[:success] = "Thanks. That event has been deleted."
    redirect_to root_url
  end

  private
    # Strong parameters for security (rails way)
    def event_params
      params.require(:event).permit(:title, :description, :amount)
    end

    def contributions_params
      params.require(:event).permit(contributions_attributes:[:email,:amount,:paid])
    end

    # Checks that user is signed in.
    def check_user_signed_in
      if (not user_signed_in?)
        flash[:error] = "Please sign in."
        redirect_to root_url
      end
    end

    # Checks that the user is allowed
    # to perform the action.
    def authorize_user
      @event = Event.find_by_id(params[:id])
      participantsIDs = @event.participant_ids

      if (not participantsIDs.include?(Integer(current_user.id)))
        flash[:error] = "You are not allowed to see that page."
        redirect_to root_url
      end
    end

end
