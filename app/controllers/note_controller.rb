#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class NoteController < ApplicationController
  layout false
  before_filter :verify_question_access
  
  def set_note
    @parent_question = @current_user.activity.questions.find(params[:question_id])
    unless @parent_question.note then
      @parent_question.build_note(:contents => params[:note]).save!
    else
      @parent_question.note.update_attributes(:contents => params[:note])
    end
    if params[:note].strip.blank? then
      @parent_question.note.destroy
    end
  end
  
  def destroy
    @parent_question = Question.find(params[:question_id])
    @parent_question.note.destroy if @parent_question && @parent_question.note
  end
  
  def edit_strategy
    @parent_strategy = @current_user.activity.activity_strategies.find(params[:activity_strategy_id])
    unless @parent_strategy.note then
      @parent_strategy.build_note(:contents => params[:note]).save!
    else
      @parent_strategy.note.update_attributes(:contents => params[:note])
    end
    if params[:note].strip.blank? then
      @parent_strategy.note.destroy
    end    
  end
  
  def destroy_strategy
    @parent_strategy = ActivityStrategy.find(params[:activity_strategy_id])
    @parent_strategy.note.destroy if @parent_strategy && @parent_strategy.note
  end
  
  protected
  
    def get_related_model
      Note
    end
    
    def verify_question_access
      if params[:question_id]
        activity = Question.find(params[:question_id]).activity
      elsif params[:activity_strategy_id]
        activity = ActivityStrategy.find(params[:activity_strategy_id]).activity
      end
      condition = ((activity && current_user.class.to_s.match(/^Activity/)) ? (current_user.activity == activity) : false)
      verify_index_access get_related_model, nil, nil, false, condition
    end
  
end
