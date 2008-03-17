class NoteController < ApplicationController
  def edit
    parent_question = @current_user.activity.questions.find(params[:question_id])
    unless parent_question.note then
      parent_question.build_note(:contents => params[:note]).save!
    else
      parent_question.note.update_attributes(:contents => params[:note])
    end
    text_to_render = @current_user.activity.questions.find(params[:question_id]).note.contents.gsub(/\S{35}/, '\0<br />').gsub(/<(\script>|script>)/, "")
    text_to_render = " " if params[:note].blank?
    render :inline => text_to_render
  end
  def destroy
    parent_question = Question.find(params[:question_id])
    parent_question.note.destroy if parent_question && parent_question.note
    render :inline => ''
  end
end
