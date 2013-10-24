# Event model 

# Ensures a debt has a "creator" and many contributions.

# @author Angel

class Event < ActiveRecord::Base
  # Makes sure every collection is associated with a user.
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  validates :creator_id, presence: true

  # Associate an event with many contributions.
  has_many :contributions, dependent: :destroy

  validates :amount, presence: true

end
