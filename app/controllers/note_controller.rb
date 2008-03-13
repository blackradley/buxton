class NoteController < ApplicationController
  def edit
    parent_question = Question.find(params[:question_id])
    unless parent_question.note then
      Note.new(:contents => params[:note], :question_id => parent_question.id).save!
    else
      parent_question.note.update_attributes(:contents => params[:note])
    end
    render :inline => Question.find(params[:question_id]).note.contents.gsub(/\S{35}/, '\0<br />').gsub(/<(\script>|script>)/, "")
  end
  def destroy
    parent_question = Question.find(params[:question_id])
    parent_question.note.destroy if parent_question && parent_question.note
    render :inline => ''
  end
end
