class RemovingOldCommentsAndNotes < ActiveRecord::Migration
  def self.up
    Comment.find(:all).each do |comment| 
      if comment.contents && comment.contents.strip.blank?
        comment.destroy
      elsif comment.contents.nil?
        comment.destroy
      end
    end
    Note.find(:all).each do |note| 
      if note.contents && note.contents.strip.blank?
        note.destroy
      elsif note.contents.nil?
        note.destroy
      end
    end
  end

  def self.down
  end
end
