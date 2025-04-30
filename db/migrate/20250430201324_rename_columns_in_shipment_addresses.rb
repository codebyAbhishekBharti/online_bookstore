class RenameColumnsInShipmentAddresses < ActiveRecord::Migration[7.2]
  def change
    rename_column :shipment_addresses, :name, :full_name
    rename_column :shipment_addresses, :phone, :phone_number
    rename_column :shipment_addresses, :zip, :zip_code
  end
end
  