#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class CommentController < ApplicationController
  helper :sections

  def edit
    parent_question = @current_user.activity.questions.find(params[:question_id])
    unless parent_question.comment then
      parent_question.build_comment(:contents => params[:comment]).save!
    else
      parent_question.comment.update_attributes(:contents => params[:comment])
    end
    if params[:comment].strip.blank? then
      parent_question.comment.destroy
      render :inline => ''
    else
      render :partial => 'sections/attachment', :locals => {:text => parent_question.comment.contents}
    end
  end

  def destroy
    parent_question = Question.find(params[:question_id])
    parent_question.comment.destroy if parent_question && parent_question.comment
    render :inline => ''
  end

  def edit_strategy
    parent_strategy = @current_user.activity.activity_strategies.find(params[:activity_strategy_id])
    unless parent_strategy.comment then
      parent_strategy.build_comment(:contents => params[:comment]).save!
    else
      parent_strategy.comment.update_attributes(:contents => params[:comment])
    end
    if params[:comment].strip.blank? then
      parent_strategy.comment.destroy
      render :inline => ''
    else
      render :partial => 'sections/attachment', :locals => {:text => parent_strategy.comment.contents}
    end
  end
  
  def destroy_strategy
    parent_strategy = ActivityStrategy.find(params[:activity_strategy_id])
    parent_strategy.comment.destroy if parent_strategy && parent_strategy.comment
    render :inline => ''
  end
  
end
