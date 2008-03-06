class CommentController < ApplicationController
  
  def edit
    return if params[:comment].blank?
    puts params
    parent_question = @current_user.activity.questions.find(params[:question_id])
    unless parent_question.comment then
      parent_question.build_comment(:contents => params[:comment]).save!
    else
      parent_question.comment.update_attributes(:contents => params[:comment])
    end
    render :inline => @current_user.activity.questions.find(params[:question_id]).comment.contents.gsub(/\S{35}/, '\0<br />')
  end
  
  def destroy
    parent_question = Question.find(params[:question_id])
    parent_question.comment.destroy if parent_question && parent_question.comment
    render :inline => ''
  end
end
