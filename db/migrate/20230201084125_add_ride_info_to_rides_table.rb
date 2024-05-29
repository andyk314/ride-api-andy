class AddRideInfoToRidesTable < ActiveRecord::Migration[7.0]
  def change
    add_column :rides, :ride_distance, :float
    add_column :rides, :ride_duration, :float
    add_column :rides, :commute_duration, :float
    add_column :rides, :ride_earnings, :float
    add_column :rides, :ride_score, :float
  end
end
