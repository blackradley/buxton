#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
#
require 'test_helper'

class IssueTest < ActiveSupport::TestCase

  context "with an issue that has been not completed" do
    setup do
      @activity = FactoryGirl.build(:activity)
      @issue = FactoryGirl.create(:issue, :activity => @activity, :strand => "gender", :section => "impact")
    end

    should "not be complete" do
      assert !@issue.check_responses
    end

  end

  context "with an issue that has been completed" do
    setup do
      @activity = FactoryGirl.build(:activity)
      @issue = FactoryGirl.create(:issue, :activity => @activity, :actions => "Action", :timescales => "timescale", :lead_officer_id => 1, :strand => "gender", :section => "impact", :resources => "none", :recommendations => "none", :monitoring => "none", :outcomes => "none")
    end

    should "be complete" do
      # assert @issue.check_responses
    end

  end
end
