class AddAddressTypeToShipmentAddresses < ActiveRecord::Migration[7.2]
  def change
    add_column :shipment_addresses, :address_type, :string
  end
end
