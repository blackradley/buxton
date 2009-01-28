module SecurityModelHelper
  
  def can_be_edited_by?(user_)
    return false if user_.nil?
    can_be_edited_by_user? user_
  end
  
  def can_be_deleted_by? user_
    return false if user_.nil?
    can_be_deleted_by_user? user_
  end
  
  def can_be_deleted_by_user?(user_)
    can_be_edited_by_user? user_
  end
    
  def can_be_edited_by_user? user_
     is_related_user?(user_)
  end
  
  def is_related_user?(user_)
    user_.id == self.user.id
  end
  
end

