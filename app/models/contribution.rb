# Contribution model 

# Ensures a contribution has an associatd user and event,
# as well as an "amount" and "paid" field.

# @author Angel

class Contribution < ActiveRecord::Base
  # Associate a contribution with one user and one event.
  belongs_to :user
  belongs_to :event

  # Note: As a hack to allow contributions to be created
  #       at the same time as an event is, the following
  #       validations were removed. Might try to
  #       implement them later, but they aren't needed - Angel
  # validates :user_id, presence: true
  # validates :event_id, presence: true
  # validates :amount, presence: true
  # validates :paid, presence: true

  # Returns whether or not the event is pending
  def isPending?
    self.pending
  end

  # Confirms a contribution
  def confirm!
    self.pending = false
    self.save
  end

  # Declines a contribution
  def decline!
    event = self.event
    self.destroy
    event.destroy
  end

end
