class CreateShipmentAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :shipment_addresses do |t|
      t.string :name
      t.string :phone
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.timestamps
    end
  end
end
