class ModifyOrdersForShipmentAddress < ActiveRecord::Migration[7.2]
  def change
    # Add reference to shipment_addresses
    add_reference :orders, :shipment_address, null: false, foreign_key: true

    # Remove old shipping fields
    remove_column :orders, :shipping_name, :string
    remove_column :orders, :shipping_phone, :string
    remove_column :orders, :shipping_address_line1, :string
    remove_column :orders, :shipping_address_line2, :string
    remove_column :orders, :shipping_city, :string
    remove_column :orders, :shipping_state, :string
    remove_column :orders, :shipping_zip, :string
    remove_column :orders, :shipping_country, :string
  end
end