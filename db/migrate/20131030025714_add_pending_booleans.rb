class AddPendingBooleans < ActiveRecord::Migration
  def change
    add_column :contributions, :pending, :boolean, default: true
    add_column :events, :pending, :boolean, default: true
  end
end
