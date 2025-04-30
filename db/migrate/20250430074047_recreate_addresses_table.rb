class RecreateAddressesTable < ActiveRecord::Migration[7.2]
  def change
    # Remove foreign key from orders to addresses
    remove_foreign_key :orders, :addresses

    # Drop the addresses table
    drop_table :addresses, if_exists: true

    # Recreate the addresses table with the updated schema
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.string :phone_number
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.boolean :is_default
      t.string :address_type

      t.timestamps
    end

    # Add uniqueness constraint
    add_index :addresses, [:user_id, :address_line1, :city, :zip_code], unique: true, name: 'unique_user_address'

    # Re-add the foreign key to orders table
    add_foreign_key :orders, :addresses
  end
end
