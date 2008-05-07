class HelpTextController < ApplicationController
  def edit
    @help_texts = HelpText.find(:all)
    @split_texts = @help_texts.map{|text| [Question.fast_split(text.question_name), text]}
  end
  def update
    params[:help_text] = [] if params[:help_text].nil?
    params[:help_text].each do |id, attributes|
      HelpText.find(id).update_attributes(attributes)
    end
    flash[:notice] =  "Help Text was successfully updated."
    redirect_to :action => :edit, :controller => :help_text
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end

  # rescue_from
  def show_errors(exception)
    flash[:notice] = 'Help text could not be updated.'
    render :action => (exception.record.new_record? ? :new : :edit)
  end

end
