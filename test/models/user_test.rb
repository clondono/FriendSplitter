# Author: Lucy
require 'test_helper'

class UserTest < ActiveSupport::TestCase

    # setContribution! creates a Contribution object belonging to the user
    test "setContribution! creates Contribution" do
        user = users(:two)
        event = events(:three)
        user.setContribution!(event, 2.00, 3.00)
        assert user.contributions.find_by(event: event), "setContribution! should create a contribution"
    end


    # setContribution! creates a Contribution object belonging to the user with correct event_id
    test "setContribution! creates Contribution with correct event_id" do
        user = users(:two)
        event = events(:three)
        user.setContribution!(event, 2.00, 3.00)
        contribution = user.contributions.find_by(event: event)
        assert contribution.event_id==3, "setContribution! contribution should have event_id 3"
    end


    # setContribution! creates a Contribution object belonging to the user with correct amount
    test "setContribution! creates Contribution with correct amount" do
        user = users(:two)
        event = events(:three)
        user.setContribution!(event, 2.00, 3.00)
        contribution = user.contributions.find_by(event: event)
        assert contribution.amount==2, "setContribution! contribution should have amount==2"
    end


    # setContribution! creates a Contribution object belonging to the user with correct paid value
    test "setContribution! creates Contribution with correct paid value" do
        user = users(:two)
        event = events(:three)
        user.setContribution!(event, 2.00, 3.00)
        contribution = user.contributions.find_by(event: event)
        assert contribution.paid==3, "setContribution! contribution should have paid==3"
    end


    # the owes? method should return false if no Debt object exists
    # between self and user specified in params
    test "owes? method returns false if no debt exists" do
        one = users(:one)
        two = users(:two)

        assert !one.owes?(two) , "No debt should exist between users 1 and 2"
    end

    
    # the owes? method should return true if a Debt object exists
    # between self and user specified in params
    test "owes? method returns true if debt exists" do
        owner = users(:three)
        indebted = users(:two)
        assert owner.owes?(indebted), "Debt object states user three owes user two"
    end


    # self.validEmails? should return true if all emails in contributions params hash
    # belong to existing users and aren't repeated
    test "validEmails? returns true for valid contributions params" do
        param = {"0"=>{"email"=>"one@one.com", "amount"=>"1.5", "paid"=>"2"}, "1"=>{"email"=>"two@two.com", "amount"=>"0.5", "paid"=>"0"}, "3"=>{"email"=>"three@three.com", "amount"=>"1.5", "paid"=>"2"}, }
        assert User.validEmails?(param) , "validEmails? should return true if all emails in contributions param belong to existing users and arent' repeated"
    end


    # self.validEmails? should return false if some email in contributions param hash
    # does not belong to an existing user
    test "validEmails? returns false for nonexistant email" do
        param = {"0"=>{"email"=>"one@one.com", "amount"=>"1.5", "paid"=>"2"}, "1"=>{"email"=>"two@two.com", "amount"=>"0.5", "paid"=>"0"}, "3"=>{"email"=>"notanemail@notanemail.com", "amount"=>"1.5", "paid"=>"2"}, }
        assert !User.validEmails?(param) , "validEmails? should return false if some email does not belong to existing user"
    end


    # self.validEmails? should return false if some email in contributions param hash
    # is repeated
    test "validEmails? returns false for repeated email" do
        param = {"0"=>{"email"=>"one@one.com", "amount"=>"1.5", "paid"=>"2"}, "1"=>{"email"=>"two@two.com", "amount"=>"0.5", "paid"=>"0"}, "3"=>{"email"=>"two@two.com", "amount"=>"1.5", "paid"=>"2"}, }
        assert !User.validEmails?(param) , "validEmails? should return false if some email is repeated"
    end


    # getEvents should the users events, separated into confirmed and pending events
    test "getEvents returns confirmed events" do
        user = users(:one)
        events = user.getEvents
        confirmed = [events(:two)]
        assert events["confirmed"] == confirmed, "getEvents should return user's events which are confirmed"
    end


    # getEvents should the users events, separated into confirmed and pending events
    test "getEvents returns pending events" do
        user = users(:one)
        events = user.getEvents
        pending = [events(:one), events(:three)]
        assert events["pending"] == pending, "getEvents should return user's events which are pending"
    end


    # confirmedEvent? should return true if the user has confirmed their own contribution
    # in the event and pending in contribution object is false
    test "confirmedEvent? returns true if user contribution nonpending" do
        user = users(:four)
        event = events(:one)
        assert user.confirmedEvent?(event), "confirmedEvent? should return true if user's contribution object pending is false"
    end


    # confirmedEvent? should return false if the user has not confirmed their own contribution
    # in the event and pending in contribution object is true
    test "confirmedEvent? returns false if user contribution pending" do
        user = users(:four)
        event = events(:two)
        assert !user.confirmedEvent?(event), "confirmedEvent? should return false if user's contribution object pending is true"
    end


    # getContribution should return the user Contribution object 
    # for a given event
    test "getContribution returns Contribution or given event" do
        contributionFixture = contributions(:seven)
        user = users(:four)
        event = events(:two)
        contribution = user.getContribution(event)
        assert contribution.id == contributionFixture.id, "contribution.id should be 7 to indicate correct Contribution object has been returned"
    end


    # getContribution should return nil when the user has not participated in a given event
    test "getContribution returns nil for no user contribution" do
        user = users(:four)
        event = events(:three)
        contribution = user.getContribution(event)
        assert_nil contribution, "contribution should be nil because no participation of user in event"
    end



end
