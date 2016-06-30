# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
Rails.logger = Le.new('8c837fd8-a99d-4d19-82d8-fc71cd25adbb', :debug => true, :local => true)
