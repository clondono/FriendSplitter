# @author Angel
class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.integer :owner_id
      t.integer :indebted_id
      t.integer :amount

      t.timestamps
    end

    # For efficiency
    add_index :debts, :owner_id
    add_index :debts, :indebted_id

    # A debt between two users is unique.
    add_index :debts, [:owner_id, :indebted_id], unique: true

  end
end
