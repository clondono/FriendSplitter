# Author: Lucy
#
require 'test_helper'

class ContributionTest < ActiveSupport::TestCase


    # isPending should return true if a Contribution object's pending column is true
    test "isPending returns true if contribution is pending" do
        pendingContr = contributions(:one)
        assert pendingContr.isPending?, "isPending? should return true for pending contribution"
    end


    # isPending should return false if a Contribution object's pending column is false
    test "isPending returns false if contribution not pending" do
        nonPending = contributions(:two)
        assert !nonPending.isPending?, "isPending? should return false for not pending contribution"
    end


    # confirm! should set previously pending Confirmation object's pending column to false
    test "confirm! sets pending to false for previously pending" do
        pending = contributions(:one)
        pending.confirm!
        assert !pending.isPending?, "isPending? should return false after confirm! for previously pending contribution"
    end

    # confirm! should set previously nonpending Confirmation object's pending column to false
    test "confirm! sets pending to false for previously nonpending" do
        nonPending = contributions(:two)
        nonPending.confirm!
        assert !nonPending.isPending?, "isPending? should return false after confirm! for previously nonpending contribution"
    end


end
