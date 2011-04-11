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
  layout false
  before_filter :set_activity
  before_filter :check_submitted
  def set_comment
    @parent_question = @activity.questions.find(params[:question_id])
    unless @parent_question.comment then
      @parent_question.build_comment(:contents => params[:comment]).save!
    else
      @parent_question.comment.update_attributes(:contents => params[:comment])
    end
    if params[:comment].strip.blank? then
      @parent_question.comment.destroy
    end
  end

  def destroy
    @parent_question = @activity.questions.find(params[:question_id])
    @parent_question.comment.destroy if @parent_question && @parent_question.comment
  end

  def edit_strategy
    @parent_strategy = @activity.activity_strategies.find(params[:activity_strategy_id])
    unless @parent_strategy.comment then
      @parent_strategy.build_comment(:contents => params[:comment]).save!
    else
      @parent_strategy.comment.update_attributes(:contents => params[:comment])
    end
  end
  
  def destroy_strategy
    @parent_strategy = @activity.activity_strategies.find(params[:activity_strategy_id])
    @parent_strategy.comment.destroy if @parent_strategy && @parent_strategy.comment
  end
  
  private
  
  def check_submitted
    return false if @activity.submitted
  end
end
