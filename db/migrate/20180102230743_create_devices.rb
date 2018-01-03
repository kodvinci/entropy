class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :uuid, unique: true
      t.timestamps
    end
    add_index :devices, :uuid, unique: true
  end
end
