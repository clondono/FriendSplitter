require 'test_helper'

class DebtTest < ActiveSupport::TestCase

    test "Update Debt val int" do
        debt1 = debts(:one)  
        debt1.updateVal!(8)      

        assert( debt1.amount == 8.00 , "Debt value after update should be 8.00")
    end

    test "Update Debt val double" do
        debt1 = debts(:two)  
        debt1.updateVal!(8.20)      

        assert( debt1.amount == 8.20 , "Debt value after update should be 8.20")
    end





end
