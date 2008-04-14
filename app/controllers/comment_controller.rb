class CommentController < ApplicationController

  def edit
    parent_question = @current_user.activity.questions.find(params[:question_id])
    unless parent_question.comment then
      parent_question.build_comment(:contents => params[:comment]).save!
    else
      parent_question.comment.update_attributes(:contents => params[:comment])
    end
    text_to_render = @current_user.activity.questions.find(params[:question_id]).comment.contents.gsub(/\S{35}/, '\0<br />').gsub(/<(\script>|script>)/, "")
    text_to_render = " " if params[:comment].blank?
    render :inline => text_to_render
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
    text_to_render = @current_user.activity.activity_strategies.find(params[:activity_strategy_id]).comment.contents.gsub(/\S{35}/, '\0<br />').gsub(/<(\script>|script>)/, "")
    text_to_render = " " if params[:comment].blank?
    render :inline => text_to_render
  end
  def destroy_strategy
    parent_strategy = ActivityStrategy.find(params[:activity_strategy_id])
    parent_strategy.comment.destroy if parent_strategy && parent_strategy.comment
    render :inline => ''
  end
end
