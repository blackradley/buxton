#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class WelcomeController < ApplicationController
  layout "application"
  
  def index
  end
  
  def new_key
    @function = Function.find_by_email(params[:email])
    Email.deliver_new_key(@function)
  end
end
