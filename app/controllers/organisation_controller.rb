class OrganisationController < ApplicationController
  layout 'default'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @organisation_pages, @organisations = paginate :organisations, :per_page => 10
  end

  def show
    @organisation = Organisation.find(params[:id])
  end

  def new
    @organisation = Organisation.new
  end

  def create
    @organisation = Organisation.new(params[:organisation])
    if @organisation.save
      flash[:notice] = 'Organisation was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @organisation = Organisation.find(params[:id])
  end

  def update
    @organisation = Organisation.find(params[:id])
    if @organisation.update_attributes(params[:organisation])
      flash[:notice] = 'Organisation was successfully updated.'
      redirect_to :action => 'show', :id => @organisation
    else
      render :action => 'edit'
    end
  end

  def destroy
    Organisation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
