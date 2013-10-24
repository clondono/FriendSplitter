# @author Angel
class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :amount # total amount user needs to contribute.
      t.integer :paid  # initial amount paid.

      t.timestamps
    end

  end
end
