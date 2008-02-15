class CommentController < ApplicationController
  def edit
    parent_question = Question.find(params[:question_id])
    unless parent_question.comment then
      Comment.new(:contents => params[:comment], :question_id => parent_question.id).save!
    else
      parent_question.comment.update_attributes(:contents => params[:comment])
    end
    render :inline => Question.find(params[:question_id]).comment.contents
  end
  def destroy
    parent_question = Question.find(params[:question_id])
    parent_question.comment.destroy if parent_question && parent_question.comment
    render :inline => ''
  end
end
