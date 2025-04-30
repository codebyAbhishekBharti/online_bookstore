class ReplaceAddressIdWithSnapshotInOrders < ActiveRecord::Migration[7.2]
  def change
    # Remove the foreign key and column
    remove_foreign_key :orders, :addresses
    remove_column :orders, :address_id

    # Add static address fields to store snapshot
    add_column :orders, :shipping_name, :string
    add_column :orders, :shipping_phone, :string
    add_column :orders, :shipping_address_line1, :string
    add_column :orders, :shipping_address_line2, :string
    add_column :orders, :shipping_city, :string
    add_column :orders, :shipping_state, :string
    add_column :orders, :shipping_zip, :string
    add_column :orders, :shipping_country, :string
  end
end
