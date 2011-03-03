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
  before_filter :verify_question_access

  def set_comment
    @parent_question = @current_user.activity.questions.find(params[:question_id])
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
    @parent_question = Question.find(params[:question_id])
    @parent_question.comment.destroy if @parent_question && @parent_question.comment
  end

  def edit_strategy
    @parent_strategy = @current_user.activity.activity_strategies.find(params[:activity_strategy_id])
    unless @parent_strategy.comment then
      @parent_strategy.build_comment(:contents => params[:comment]).save!
    else
      @parent_strategy.comment.update_attributes(:contents => params[:comment])
    end
  end
  
  def destroy_strategy
    @parent_strategy = ActivityStrategy.find(params[:activity_strategy_id])
    @parent_strategy.comment.destroy if @parent_strategy && @parent_strategy.comment
  end
  
  protected
  
    def get_related_model
      Comment
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
