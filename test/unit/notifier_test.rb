#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
require File.dirname(__FILE__) + '/../test_helper'

class NotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"
  fixtures :users

  include ActionMailer::Quoting
#
# Set up some fixtures to mess about with
#
  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
    
    @user = users(:three)
  end
#
# 
#
  def test_new_administration_key
    @expected.subject = 'Notifier#new_key'
    @expected.body    = read_fixture('new_key')
    @expected.date    = Time.now

    #assert_equal @expected.encoded, Notifier.create_administration_key(@user).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/notifier/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
