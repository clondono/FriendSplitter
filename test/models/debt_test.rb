require 'test_helper'

class DebtTest < ActiveSupport::TestCase

    test "Update Debt val int" do
        debt1 = debts(:one)  
        debt1.updateVal!(8)      

        assert( debt1.amount == 8.00 , "Debt value after update should be 8.00")
    end

    test "Update Debt val double" do
        debt1 = debts(:one)  
        debt1.updateVal!(8.20)      

        assert( debt1.amount == 8.20 , "Debt value after update should be 8.20")
    end

    test "Debt shouldn't save if not unique" do
        debt = Debt.new
        debt.owner_id = 3
        debt.amount = 3.00
        debt.indebted_id = 2
        assert !debt.save, "Debt should not save if not unique"
    end

    test "Debt shouldn't save if owner_id not present" do
        debt = Debt.new
        debt.amount = 3.00
        debt.indebted_id = 2
        assert !debt.save, "Debt should not save if owner_id not present"
    end

    test "Debt shouldn't save if amount not present" do
        debt = Debt.new
        debt.owner_id = 1
        debt.indebted_id = 2
        assert !debt.save, "Debt should not save if owner_id not present"
    end

    test "Debt should save if valid fields" do
        debt = Debt.new
        debt.owner_id = 1
        debt.indebted_id = 2
        debt.amount = 2.40
        assert debt.save, "Debt should save if owner_id, indebted_id, amount are all present"
    end





end
