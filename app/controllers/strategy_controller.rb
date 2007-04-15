#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class StrategyController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @strategy_pages, @strategies = paginate :strategies, :per_page => 10
  end

  def show
    @strategy = Strategy.find(params[:id])
  end

  def new
    @strategy = Strategy.new
  end

  def create
    @strategy = Strategy.new(params[:strategy])
    if @strategy.save
      flash[:notice] = 'Strategy was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @strategy = Strategy.find(params[:id])
  end

  def update
    @strategy = Strategy.find(params[:id])
    if @strategy.update_attributes(params[:strategy])
      flash[:notice] = 'Strategy was successfully updated.'
      redirect_to :action => 'show', :id => @strategy
    else
      render :action => 'edit'
    end
  end
#
# 
#
  def destroy
    Strategy.find(params[:id]).destroy
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
