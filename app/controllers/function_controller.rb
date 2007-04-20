#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class FunctionController < ApplicationController
  layout 'application'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @function_pages, @functions = paginate :functions, :per_page => 10
  end

  def show
    @function = Function.find(params[:id])
    @user = @function.user
  end
#
# Create a new function and a new associated user
#
  def new
    @function = Function.new
    @user = User.new 
  end
#
# Create a new function and a new user based on the parameters on the form.  
#
  def create
    @function = Function.new(params[:function])   
    @function.organisation_id = @session['logged_in_user'].organisation.id 
    @user = User.new(params[:user])
    @user.passkey = User.new_passkey
    @user.user_type = User::FUNCTIONAL
    Function.transaction do
      @user.function = @function
      @function.save!
      @user.save!
      flash[:notice] = @function.name + ' was created.'
      redirect_to :action => :list
    end
  rescue ActiveRecord::RecordInvalid => e
    @user.valid? # force checking of errors even if function failed
    render :action => :new    
  end
#
# Get both the function and user information ready for editing, since they
# are both edited at the same time.  The organisational manager edits these
# not the functional manager.
#
  def edit_contact
    @function = Function.find(params[:id])
    @user = @function.user
  end
#
# Get the function information ready for editing using the relevance form.  
# These are edited by the functional manager.
#
  def edit_relevance
    @function = Function.find(params[:id])
    @strategies = Strategy.find_all_by_organisation_id(@session['logged_in_user'].function.organisation_id)
    @impact_groups = ImpactGroup.find_all_by_organisation_id(@session['logged_in_user'].function.organisation_id)
  end
#
# Update the function and all of its attributes, then redirect based on the
# type of user.
#
  def update
    @function = Function.find(params[:id])
    @function.update_attributes(params[:function])
    Function.transaction do
      @user = @function.user
      @user.update_attributes(params[:user])
      flash[:notice] =  @function.name + ' was successfully changed.'
      if @session['logged_in_user'].user_type == User::FUNCTIONAL
        redirect_to :action => :show, :id => @function
      elsif @session['logged_in_user'].user_type == User::ORGANISATIONAL
        redirect_to :action => :list
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    @user.valid? # force checking of errors even if function failed
    render :action => :new  
  end
#
# Send a reminder to the email associated with that function.  Only one
# email should be sent for that function, so if the email is used a number
# of times in the functions/users then the other functions are ignored 
# until a reminder is sent for that specific function.
#
  def remind
    @user = User.find(params[:id])
    @user.passkey = User.new_passkey
    @user.reminded_on = Time.now
    @user.save
    email = Notifier.create_function_key(@user, request)
    Notifier.deliver(email)
    flash[:notice] = 'Reminder for ' + @user.function.name + ' sent to ' + @user.email
    redirect_to :action => 'list'
  end
#
# TODO: Mark the function record with a deleted date do not destroy
#
  def destroy
    Function.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

protected
#
# Secure the relevant methods in the controller.
#
  def secure?
    true
    #["list", "add", "show"].include?(action_name)
  end
end
