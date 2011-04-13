require File.dirname(__FILE__) + '/../test_helper'

class ActivityTest < ActiveSupport::TestCase
  subject{ Factory(:activity)}
  
  should validate_presence_of(:name).with_message(/All activities must have a name/)
  should validate_presence_of(:completer)
  should validate_presence_of(:approver)
  should validate_presence_of(:service_area)
  # should validate_uniqueness_of(:ref_no).with_message('Reference number must be unique')
  
  
end
