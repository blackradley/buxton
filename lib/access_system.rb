module AccessSystem
  
  private
    
  def set_related_object  rel_model = get_related_model, related_param = nil, instance_var_name = nil
    related_param ||= :id
    rel_model ||= get_related_model
    begin
      @target = rel_model.find(params[related_param])
    rescue
      flash[:error] ="No such a #{rel_model.name}" rescue "No such a #{rel_model.class.to_s}"
      return render_no_access
    end
    instance_var_name ||= rel_model.name.underscore
    instance_variable_set(('@' + instance_var_name.to_s).to_sym, @target)
    true
  end
    
  def verify_edit_access rel_model = get_related_model, related_param = nil, instance_var_name = nil , force = false , additional_condition = nil
    return false unless set_related_object(rel_model,related_param,instance_var_name)
    can_be_edited = force || (@target.can_be_edited_by?(current_user)  && (additional_condition.nil? || additional_condition))
    unless can_be_edited
      render_no_permission(rel_model,"edit") 
    end
    can_be_edited
  end 
  
  def verify_index_access rel_model = get_related_model,related_param = nil, instance_var_name = nil  , force = false, additional_condition = nil
    can_be_viewed = force || (rel_model.can_be_viewed_by?(current_user)  && (additional_condition.nil? || additional_condition))
    unless can_be_viewed
      render_no_permission(rel_model,"view")
    end
    can_be_viewed
  end
  
  def verify_view_access rel_model = get_related_model,related_param = nil, instance_var_name = nil  , force = false, additional_condition = nil
    return false unless set_related_object(rel_model,related_param,instance_var_name)
    can_be_viewed = force || (@target.can_be_viewed_by?(current_user)  && (additional_condition.nil? || additional_condition))
    unless can_be_viewed
      render_no_permission(rel_model,"view")
    end
    can_be_viewed
  end   
       
  def verify_delete_access rel_model = get_related_model,related_param = nil, instance_var_name = nil , force = false, additional_condition = nil
    return false unless set_related_object(rel_model,related_param,instance_var_name)
    can_be_deleted = force || (@target.can_be_deleted_by?(current_user)  && (additional_condition.nil? || additional_condition))
    unless can_be_deleted
      render_no_permission(rel_model,"delete")
    end
    can_be_deleted
  end
  
  def render_no_permission(rel_model = nil,access_action = "edit")
    flash[:error] = "No permission to #{access_action} this #{rel_model.name}"  rescue "No such a #{rel_model.class.to_s}"
    render_no_access
  end      
   
  def verify_ssl_request
    #if Rails.env == 'production' and !request.ssl?
    #  flash[:error] = "You have tried to run unsecured action. Please use SSL"
    #  return render_no_access
    #end
    true
  end  
 
  def render_no_access
    if request.xhr?
      render :update do |page| 
        page.rjs_flash(flash)
        flash.clear
      end
    else
      redirect_to(access_denied_url)
    end
    return false
  end 
  
  public
end
