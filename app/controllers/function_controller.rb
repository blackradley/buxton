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

  def new
    @function = Function.new
    @user = User.new 
  end

  def create
    @function = Function.new(params[:function])    
    @function.key = ApplicationHelper.newUUID
    @function.organisation_id = 1
    @user = User.new(params[:user])
    Function.transaction do
      @user.function = @function
      @function.save!
      @user.save!
      flash[:notice] = 'Function and User were successfully created.'
      redirect_to :action => 'list'
    end
  rescue ActiveRecord::RecordInvalid => e
    @user.valid? # force checking of errors even if function failed
    render :action => :new    
  end

  def edit_contact
    @function = Function.find(params[:id])
    @user = @function.user
  end

  def edit_relevance
    @function = Function.find(params[:id])
  end

  def update
    @function = Function.find(params[:id])
    if @function.update_attributes(params[:function])
      flash[:notice] = 'Function was successfully updated.'
      redirect_to :action => 'show', :id => @function
    else
      render :action => 'edit'
    end
  end

  def remind
    @user = User.find(params[:id])
    @user.passkey = User.new_UUID
    @user.reminded_on = Time.now
    @user.save
    email = Notifier.create_function_key(@user, request)
    Notifier.deliver(email)
    flash[:notice] = 'New key sent to ' + @user.email
    redirect_to :action => 'list'
  end

  def destroy
    Function.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
