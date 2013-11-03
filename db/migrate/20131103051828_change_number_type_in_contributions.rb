class ChangeNumberTypeInContributions < ActiveRecord::Migration
  def up
      change_column :contributions, :amount, :decimal, :precision=>20, :scale=>2
      change_column :contributions, :paid, :decimal, :precision=>20, :scale=>2
      change_column :debts, :amount, :decimal, :precision=>20, :scale=>2
      change_column :events, :amount, :decimal, :precision=>20, :scale=>2
  end

  def down
      change_column :contributions, :amount, :integer
      change_column :contributions, :paid, :integer
      change_column :debts, :amount, :integer
      change_column :events, :amount, :integer
  end
end
