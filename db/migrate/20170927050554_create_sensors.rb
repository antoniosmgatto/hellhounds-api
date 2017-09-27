class CreateSensors < ActiveRecord::Migration[5.1]
  def change
    create_table :sensors do |t|
      t.text :arduino_id
      t.text :sensor_id
      t.integer :target_temperature
      t.integer :current_temperature

      t.timestamps
    end
  end
end
