# @author Angel
class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :creator_id
      t.integer :amount

      t.timestamps
    end
  end
end
