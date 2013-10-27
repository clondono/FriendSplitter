# Contribution model 

# Ensures a contribution has an associatd user and event,
# as well as an "amount" and "paid" field.

# @author Angel

class Contribution < ActiveRecord::Base
  # Associate a contribution with one user and one event.
  belongs_to :user
  belongs_to :event

  # Make sure that there's an associated collection/user and
  # that every collection/user pair is unique.
  # validates :user_id, presence: true
  # validates :event_id, presence: true
  # validates :amount, presence: true
  # validates :paid, presence: true
  # Note: since a user can pay more than his/her total amount,
  #       there is no need to validate a relationship between
  #       :amount and :paid

end
