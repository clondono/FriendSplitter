require 'test_helper'

class UserTest < ActiveSupport::TestCase

    test "No debt initially" do
        one = users(:one)
        two = users(:two)

        assert( !one.owes?(two) , "user one should not owe user two initially")
    end

    test "Confirm debt exists" do
        owner = users(:three)
        indebted = users(:two)


        assert( indebted.owes?(owner), "debt object states user two owes user one")
    end

end
