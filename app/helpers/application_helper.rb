module ApplicationHelper

  # Checks if a string is a valid number
  # using regex. Used for authenticating 
  # form inputs for amounts.
  # Regex from: http://archive.railsforum.com/viewtopic.php?id=19081
  def isNumber?(string)
    /^[\d]+(\.[\d]+){0,1}$/ === string
  end
end
