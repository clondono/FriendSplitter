module ApplicationHelper

  # Checks if a string is a valid number
  # using regex.
  # Regex from: http://archive.railsforum.com/viewtopic.php?id=19081
  def isNumber?(string)
    /^[\d]+(\.[\d]+){0,1}$/ === string
  end
end
