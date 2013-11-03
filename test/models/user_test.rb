require 'test_helper'

class UserTest < ActiveSupport::TestCase

    test "No debt initially" do
        one = users(:one)
        two = users(:two)

        assert( !one.owes?(two) , "user one should not owe user two initially")
    end

    test "Confirm debt exists" do
        owner = users(:three)
        Rails.logger.debug("owner id: #{owner.id}")
        indebted = users(:two)
        Rails.logger.debug("indebted id: #{indebted.id}")
        find = Debt.all

        find.each do |f|
            Rails.logger.debug("f owner: #{f.owner_id}")
            Rails.logger.debug("f indebted: #{f.indebted_id}")
        end

        assert( owner.owes?(indebted), "debt object states user two owes user one")
    end

end
