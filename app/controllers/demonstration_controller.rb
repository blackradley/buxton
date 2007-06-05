#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
# 
class DemonstrationController < ApplicationController

  def index
  end
#
# Create a new user and organisation, then log the user in.  Obviously this 
# bypasses the minimal security, but it is just a demo.
#
  def new_organisation
    user = User.find_by_email(params[:email])
    if !user.nil?
      passkey = user.passkey
    else
      # Create a new user
      user = User.new
      user.email = params[:email]
      user.user_type = User::TYPE[:organisational]
      user.save!
      passkey = user.passkey
      # Give the user an organisation
      organisation = Organisation.new
      organisation.user = user
      organisation.name = 'Demo Council'
      organisation.style = 'demo'
      organisation.save!
      # Give the organisation some strategies
      strategy_names = ['Manage resources effectively, flexibly and responsively',
        'Investing in our staff to build an organisation that is fit for its purpose',
        'Raising performance in our services for children, young people, families and adult',
        'Raising performance in our housing services',
        'Cleaner, greener and safer environment',
        'Investing in regeneration',
        'Improving our transport and tackling congestion',
        'Providing more effective education and leisure opportunities']
      strategy_names.each {|strategy_name|
        strategy = Strategy.new
        strategy.organisation = organisation
        strategy.name = strategy_name
        strategy.description = strategy_name
        strategy.display_order = 0
        strategy.save!
      }
      # Give the organisation three functions which are owned by the same user
      function_names = ['Community Strategy', 'Publications', 'Meals on Wheels']
      function_names.each {|function_name|
        user = User.new
        user.email = params[:email]
        user.user_type = User::TYPE[:functional]
        user.save!
        function = Function.new
        function.user = user
        function.organisation = organisation
        function.name = function_name
        function.save!
      }
    end
    flash[:notice] = 'Demonstration organisation was created.'
    # Log in the organisational version of the user.
    redirect_to :controller => :welcome, :action => :login, :passkey => passkey
  end
end
