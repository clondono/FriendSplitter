# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Friendsplitter::Application.initialize!

Rails.logger = Logger.new(STDOUT)
