class AddGeocodeAttributesToRidesTable < ActiveRecord::Migration[7.0]
  def change
    add_column :rides, :destination_address_lat, :float
    add_column :rides, :destination_address_long, :float
    add_column :rides, :start_address_lat, :float
    add_column :rides, :start_address_long, :float
  end
end
