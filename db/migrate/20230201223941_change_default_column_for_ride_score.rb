class ChangeDefaultColumnForRideScore < ActiveRecord::Migration[7.0]
  def up
    change_column :rides, :ride_score, :float, default: 0.0
  end

  def down
    change_column :rides, :ride_score, :float, default: nil
  end
end
