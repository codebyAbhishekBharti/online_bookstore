class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
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

      t.timestamps
    end
    # Adding uniqueness constraint to avoid duplicate addresses for a user
    add_index :addresses, [:user_id, :address_line1, :city, :zip_code], unique: true, name: 'unique_user_address'
  end
end
