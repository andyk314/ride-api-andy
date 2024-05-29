class CreateRides < ActiveRecord::Migration[7.0]
  def change
    create_table :rides do |t|
      t.references :driver, null: false, foreign_key: true
      t.text :start_address
      t.text :destination_address

      t.timestamps
    end
  end
end
