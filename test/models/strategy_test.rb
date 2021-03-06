#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
require 'test_helper'


class StrategyTest < ActiveSupport::TestCase


  should validate_presence_of(:name)

  context "with an set of strategies" do
    setup do
      Strategy.destroy_all
      2.times do |i|
        FactoryGirl.create(:strategy, :name => "Strategy #{i}", :description => "Description #{i}")
      end

      3.times do |i|
        FactoryGirl.create(:strategy, :name => "Strategy #{i}", :description => "Description #{i}", :retired => true)
      end
    end

    should "not include the retired in the live filter" do
      assert_equal 2, Strategy.live.count
    end

  end

end
