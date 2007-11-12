# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.  
# 
class DemosController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify  :method => :post,
          :only => [ :create ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  def new
  end

  # Create a new user and organisation, then log the user in.  Obviously this
  # bypasses the minimal security, but it is just a demo.  If the user is already
  # an organisational user the they go straight to the login.  So we don't get
  # multiple demo organisations for the same user.
  #
  # If an admin user requests a demo then one is created for them since the
  # admin users are not sought in the first find.
  def create
    @user = User.find(:first, :conditions => { :email => params[:user][:email], :user_type => User::TYPE[:organisational] })

    if @user.nil? then
      # Create an organisation
      @organisation = Organisation.new({ :name => 'Demo Council', :style => 'www' })
      
      # Create a new organisation manager with the e-mail address we were given
      @user = @organisation.build_user(params[:user])
      @user.user_type = User::TYPE[:organisational]
      @user.passkey = User.generate_passkey(@user)

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
        strategy = @organisation.strategies.build
        strategy.name = strategy_name
        strategy.description = strategy_name
      }
      
      # Give the organisation three functions which are owned by the same user
      function_names = ['Community Strategy', 'Publications', 'Meals on Wheels']
      function_names.each {|function_name|
        # Create a function
        function = @organisation.functions.build(:name => function_name)
        function.organisation = @organisation #this should be filled in directly above, don't know why not
        # Create a function manager
        function_manager = function.build_user(params[:user])
        function_manager.user_type = User::TYPE[:functional]
        function_manager.passkey = User.generate_passkey(function_manager)
      }

      begin
        Organisation.transaction do
          @organisation.save!
          flash[:notice] = 'Demonstration organisation was created.'
        end
      rescue
        render :action => 'new' and return
      end
    end

    # If we made it here then all of the above was successful.
    # Log in the organisational manager (be they new or old).
    redirect_to :controller => 'users', :action => :login, :passkey => @user.passkey
  end

end