class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.decimal :price
      t.text :description
      t.integer :stock_quantity
      t.string :category_name
      t.integer :vendor_id, null: false  # This will refer to user_id in the users table
      t.timestamps
    end

    add_foreign_key :books, :users, column: :vendor_id
  end
end
