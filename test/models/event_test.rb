require 'test_helper'

class EventTest < ActiveSupport::TestCase

    # isPending should return true for event with pending column true
    test "isPending returns true for pending event" do
        event = events(:one)
        assert event.isPending?, "isPending should return true for event with pending column true"
    end


    # isPending should return false for event with pending column false
    test "isPending returns false for nonpending event" do
        event = events(:two)
        assert !event.isPending?, "isPending should return false for event with pending column false"
    end


    # confirmed? should return true if all the event's contributions
    # were confirmed ie nonpending
    test "confirmed? returns true if all contributions nonpending" do
        event = events(:four)
        assert event.confirmed?, "confirmed? should return true if all contributions connected to event are nonpending"
    end


    # confirmed? should return false if at least one of the event's contributions
    # are not confirmed ie pending
    test "confirmed? returns false if not all contributions nonpending" do
        event = events(:five)
        assert !event.confirmed?, "confirmed? should return false if some contribution connected to the event is pending"
    end


    # confirm! should set the event's pending column to false
    test "confirm! sets pending to false" do
        event = events(:five)
        event.confirm!
        assert !event.pending, "confirm! should set the event's pending column to false"
    end


    # validContributions? should return true if the amount and paid contributions 
    # in params hash add up to the total amount of an event cost when dealing with
    # integers only
    test "validContributions? true if contributions sum to event amount integers only" do
        params = {"0"=>{"email"=>"one@one.com", "amount"=>"3", "paid"=>"2"}, "1"=>{"email"=>"two@two.com", "amount"=>"1", "paid"=>"2"}} 

        assert Event.validContributions?(params, 4), "validContributions? should be true if contributions sum to event amount"
    end


    # validContributions? should return true if the amount and paid contributions 
    # in params hash add up to the total amount of an event cost when dealing with
    # decimal numbers
    test "validContributions? true if contributions sum to event amount integer decimal" do
        params = {"0"=>{"email"=>"one@one.com", "amount"=>"1.5", "paid"=>"2"}, "1"=>{"email"=>"two@two.com", "amount"=>"0.5", "paid"=>"0"}} 

        assert Event.validContributions?(params, 2), "validContributions? should be true if contributions sum to event amount"
    end


    # validContributions? should return true if the amount and paid contributions
    # in params hash add up to the total amount of an event cost
    test "validContributions? true if contributions sum to event amount 2" do
        params = {"0"=>{"email"=>"lucy@lucy.com", "amount"=>"1.5", "paid"=>"2"}, "1"=>{"email"=>"cake@cake.com", "amount"=>"0.5", "paid"=>"0"}, "2" => {"email" => "pie@pie.com", "amount" => "2", "paid"=> "2"} }

        assert Event.validContributions?(params, 4), "three users involved: validContributions? should be true if contributions sum to event amount"
    end


    # validContributions? should return false if the amounts of contributions in
    # hash do not add up to total amount of event cost
    test "validContributions? false if amount does not sum to event total" do
        params = {"0"=>{"email"=>"lucy@lucy.com", "amount"=>"1.5", "paid"=>"2"}, "1"=>{"email"=>"cake@cake.com", "amount"=>"0.5", "paid"=>"0"}, "2" => {"email" => "pie@pie.com", "amount" => "2", "paid"=> "2"} }

        assert !Event.validContributions?(params, 3), "three users involved: validContributions? should be false if amount does not sum to event total"
    end


    # validContributions? should return false if the "paid" values of
    # contributions in hash do not add up to total amount of event cost
    test "validContributions? false if paid does not sum to event total" do
        params = {"0"=>{"email"=>"lucy@lucy.com", "amount"=>"1.5", "paid"=>"1"}, "1"=>{"email"=>"cake@cake.com", "amount"=>"0.5", "paid"=>"0"}, "2" => {"email" => "pie@pie.com", "amount" => "2", "paid"=> "2"} }

        assert !Event.validContributions?(params, 4), "three users involved: validContributions? should be false if paid values do not sum to event total"
    end


    # Check that createDebts creates Debts such that each indebted User's debts
    # are increased by their deficit from the event...and conversely, that each
    # person who paid over their share is owed money that sum up to the surplus
    test "createDebts create satisfactory debts for two participants" do
        event = events(:four)
        user5 = users(:five)
        user6 = users(:six)

        event.createDebts

        d1 = Debt.find_by(owner_id: 6, indebted_id: 5)
        assert_not_nil d1, "debt should not exist between users 5 and 6"
        assert d1.amount == 2, "user 6 should owe money to user 5 after createDebts is called on event 4"
    end


    # Check that createDebts creates Debts such that each indebted User's debts
    # are increased by their deficit from the event...and conversely, that each
    # person who paid over their share is owed money that sum up to the surplus
    test "createDebts create satisfactory debts for three participants" do
        event = events(:five)
        user4 = users(:four)
        user5 = users(:five)
        user6 = users(:six)

        event.createDebts

        d1 = Debt.find_by(owner_id: 4, indebted_id: 5)
        d2 = Debt.find_by(owner_id: 4, indebted_id: 6)
        assert_not_nil d1, "debt should now exist between users 4 and 5"
        assert_not_nil d2, "debt should now exist between users 4 and 6"
        assert (d1.amount+d2.amount) == 2, "total money owed by 4 should equal their deficit in the event, which is 3"
        assert d1.amount == 1, "user 5 is owed $1 after overpaying for this event"
        assert d2.amount == 1, "user 6 is owed $1 after overpaying for this event"
    end



end
