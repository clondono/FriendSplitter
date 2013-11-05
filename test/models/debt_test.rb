# Author: Lucy 

require 'test_helper'

class DebtTest < ActiveSupport::TestCase

    # A Debt object should not be saved if another Debt object with the
    # same owner_id and indebted_id already exists
    test "Unique owner_id and indebted_id" do
        debt = Debt.new
        # A fixture already exists with the same owner and indebted
        debt.owner_id = 3
        debt.indebted_id = 2
        debt.amount = 3.00
        assert !debt.save, "Debt should not save if owner_id and indebted_id not unique"
    end


    # A Debt object should not be saved if there is no owner_id
    test "Validate owner_id presence" do
        debt = Debt.new
        debt.amount = 3.00
        debt.indebted_id = 2
        assert !debt.save, "Debt should not save if owner_id not present"
    end


    # A Debt object should not be saved if there is no indebted_id
    test "Validate indebted_id presence" do
        debt = Debt.new
        debt.amount = 3.00
        debt.owner_id = 2
        assert !debt.save, "Debt should not save if indebted_id not present"
    end


    # A Debt object should not be saved if there is no amount
    test "Validate amount presence" do
        debt = Debt.new
        debt.owner_id = 1
        debt.indebted_id = 2
        assert !debt.save, "debt should not save if owner_id not present"
    end


    # A Debt object should successfully save if there exists owner_id, indebted_id,
    # and amount fields AND there exists no other Debt object with the same 
    # owner/indebted
    test "Save Debt for valid fields" do
        debt = Debt.new
        debt.owner_id = 1
        debt.indebted_id = 2
        debt.amount = 2.40
        assert debt.save, "Debt should save if owner_id, indebted_id, amount are all present and uniqueness is true"
    end


    # A Debt object should update its amount correctly when assigned a new integer amount
    test "Update Debt amount with integer" do
        debt1 = debts(:one)  
        debt1.updateVal!(8)      

        assert debt1.amount == 8 , "Debt value after update should be 8"
    end


    # A Debt object should update its amount correctly when assigned a two-precision decimal amount
    test "Update Debt amount with two precision decimal" do
        debt1 = debts(:one)  
        debt1.updateVal!(8.21)      

        assert debt1.amount == 8.21 , "Debt value after update should be 8.21"
    end


    # settleDebt method should decrease debt between two users if the indebted user 
    # pays back some of the amount
    test "settleDebt updates amount after partial payback" do
        two = users(:two)
        four = users(:four)
        Debt.settleDebt(four, two, 2.00)
        assert debts(:two).amount == 2.00, "Debt should be decreased to 2.00"
    end


    # settleDebt method should increase the amount of the debt object between two
    # users if the indebted user owes the debt owner again
    test "settleDebt updates amount for increased debt" do
        two = users(:two)
        four = users(:four)
        Debt.settleDebt(two, four, 2.00)
        assert debts(:two).amount == 6.00, "Debt should be increased to 6.00"
    end


    # settleDebt method should create a debt object between two users if none
    # existed before
    test "settleDebt creates debt object" do
        one = users(:one)
        two = users(:two)
        assert !one.owes?(two), "No debt should exist between users yet"
        Debt.settleDebt(two, one, 2.00)
        assert one.owes?(two), "Debt should exist between users"
    end


    # settleDebt method should create a debt object with the correct amount
    # value between two users if none existed before
    test "settleDebt creates debt object with correct value" do
        one = users(:one)
        two = users(:two)
        Debt.settleDebt(two, one, 2.00)
        debt = one.debts.find_by(owner_id:1, indebted_id:2)
        assert debt.amount == 2.00, "New debt should be $2.00"
    end


    # settleDebt method should destroy existing Debt object if the indebted user
    # over-repays the debt owner and create a new Debt object reversing the 
    # ower and the owed
    test "settleDebt creates reverse debt after over-repay" do
        two = users(:two)
        four = users(:four)
        assert four.owes?(two), "Originally, user 4 owes user 2"
        assert !two.owes?(four), "Originally, user 2 does not owe user 4"
        Debt.settleDebt(four, two, 6.00)
        assert two.owes?(four), "After settleDebt, user 2 owes user 4"
        assert !four.owes?(two), "After settleDebt, user 4 does not owe user 2"
    end


    # settleDebt method should destroy existing debt object if the indebted user
    # over-repays the debt owner and create a new Debt object reversing the ower
    # and the owed with the difference as the new amount
    test "settleDebt creates debt with correct amount after over-repay" do
        two = users(:two)
        four = users(:four)
        Debt.settleDebt(four, two, 6.00)
        debt = two.debts.find_by(owner_id:2, indebted_id:4)
        assert debt.amount == 2.00, "New debt should be $2.00"
    end


    # settleDebt method should destroy an existing Debt object if the indebted
    # user repays exactly the amount of the debt
    test "settleDebt destroys debt after exact payment" do
        two = users(:two)
        four = users(:four)
        assert four.owes?(two), "Originally, user 4 owes user 2"
        Debt.settleDebt(four, two, 4.00)
        assert !four.owes?(two), "After settleDebt, user 4 no longer owes user 2"
    end



end
