#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class NoteController < ApplicationController
  
  def edit
    parent_question = @current_user.activity.questions.find(params[:question_id])
    unless parent_question.note then
      parent_question.build_note(:contents => params[:note]).save!
    else
      parent_question.note.update_attributes(:contents => params[:note])
    end
    if params[:note].strip.blank? then
      parent_question.note.destroy
      render :inline => ''
    else
      render :partial => 'sections/attachment', :locals => {:text => parent_question.note.contents}
    end
  end
  
  def destroy
    parent_question = Question.find(params[:question_id])
    parent_question.note.destroy if parent_question && parent_question.note
    render :inline => ''
  end
  
  def edit_strategy
    parent_strategy = @current_user.activity.activity_strategies.find(params[:activity_strategy_id])
    unless parent_strategy.note then
      parent_strategy.build_note(:contents => params[:note]).save!
    else
      parent_strategy.note.update_attributes(:contents => params[:note])
    end
    if params[:note].strip.blank? then
      parent_strategy.note.destroy
      render :inline => ''
    else
      render :partial => 'sections/attachment', :locals => {:text => parent_strategy.note.contents}
    end    
  end
  
  def destroy_strategy
    parent_strategy = ActivityStrategy.find(params[:activity_strategy_id])
    parent_strategy.note.destroy if parent_strategy && parent_strategy.note
    render :inline => ''
  end
  
end
