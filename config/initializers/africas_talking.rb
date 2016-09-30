
# Include the helper gateway class
require 'AfricasTalkingGateway'

# API Credentials
ATGUSERNAME = "uma"
ATGKEY   = "0c8a58e0d7363dbe71d089590d7cc3c2a9b079abaa4e43277e0f9ffaf175facb"



# testing whether API works or not
=begin
begin
  user = gateway.getUserData()
  puts user['balance']
    # The result will have the format=> KES XXX
rescue AfricasTalkingGatewayException => ex
  puts "Encountered an error: " + ex.message
end
=end
