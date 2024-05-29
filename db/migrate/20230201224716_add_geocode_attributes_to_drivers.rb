class AddGeocodeAttributesToDrivers < ActiveRecord::Migration[7.0]
  def change
        add_column :drivers, :home_address_lat, :float
        add_column :drivers, :home_address_long, :float
  end
end
