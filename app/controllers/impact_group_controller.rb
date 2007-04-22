#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
# 
class ImpactGroupController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

#
# Get the organisation you are considering and a list of it's strategies
#
  def list
    @organisation = Organisation.find(params[:id])
    @impact_groups = ImpactGroup.find_all_by_organisation_id(params[:id])
  end

  def show
    @impact_group = ImpactGroup.find(params[:id])
  end

  def new
    @impact_group = ImpactGroup.new
    @impact_group.organisation_id = params[:id]
  end

  def create
    @impact_group = ImpactGroup.new(params[:impact_group])
    if @impact_group.save
      flash[:notice] = 'Impact Group was successfully created.'
      redirect_to :action => 'list', :id => @impact_group.organisation_id
    else
      render :action => 'new'
    end
  end

  def edit
    @impact_group = ImpactGroup.find(params[:id])
  end

  def update
    @impact_group = ImpactGroup.find(params[:id])
    if @impact_group.update_attributes(params[:impact_group])
      flash[:notice] = 'ImpactGroup was successfully updated.'
      redirect_to :action => 'show', :id => @impact_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    ImpactGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
