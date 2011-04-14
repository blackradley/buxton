#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
#
require File.dirname(__FILE__) + '/../test_helper'

class IssueTest < ActiveSupport::TestCase

  context "with an issue that has been not completed" do
    setup do
      @activity = Factory.stub(:activity)
      @issue = Factory(:issue, :activity => @activity, :strand => "gender", :section => "impact")
    end
    
    should "not be complete" do
      assert !@issue.check_responses
    end
    
  end
  
  context "with an issue that been not completed" do
    setup do
      @activity = Factory.stub(:activity)
      @issue = Factory(:issue, :activity => @activity, :actions => "Action", :timescales => "timescale", :lead_officer => "Joe", :strand => "gender", :section => "impact", :resources => "none")
    end
    
    should "be complete" do
      assert @issue.check_responses
    end
    
  end
end
