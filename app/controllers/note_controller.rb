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
  before_filter :set_activity
  before_filter :check_submitted
  
  def set_note
    @parent_question = @activity.questions.find(params[:question_id])
    unless @parent_question.note then
      @parent_question.build_note(:contents => params[:note].to_s).save!
    else
      @parent_question.note.update_attributes(:contents => params[:note].to_s)
    end
    if params[:note].to_s.strip.blank? then
      @parent_question.note.destroy
    end
  end
  
  def destroy
    @parent_question = @activity.questions.find(params[:question_id])
    @parent_question.note.destroy if @parent_question && @parent_question.note
  end
  
  def edit_strategy
    @parent_strategy = @activity.activity_strategies.find(params[:activity_strategy_id])
    unless @parent_strategy.note then
      @parent_strategy.build_note(:contents => params[:note].to_s).save!
    else
      @parent_strategy.note.update_attributes(:contents => params[:note].to_s.to_s)
    end
    if params[:note].to_s.strip.blank? then
      @parent_strategy.note.destroy
    end    
  end
  
  def destroy_strategy
    @parent_strategy = @activity.activity_strategies.find(params[:activity_strategy_id])
    @parent_strategy.note.destroy if @parent_strategy && @parent_strategy.note
  end
  
  private
  
  def check_submitted
    if @activity.submitted
      render :nothing =>true
      return false 
    end
  end
end
