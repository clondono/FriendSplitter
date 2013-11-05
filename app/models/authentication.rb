# Authentication model 

# Used to authenticate users with third
# party services such as Google/Facebook.

# @author Christian
class Authentication < ActiveRecord::Base
  belongs_to :user
end
