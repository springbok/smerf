class SmerfTestController < ApplicationController
  
  include Smerf
 
  def index

    # Set the record ID for the user accessing the smerf 
    # normally this would be done by the authentication code
    # for the application, the test app does not use authentication
    # so we set it here as an example
    self.smerf_user_id = 1
    
  end
  
end
