class CreateCarts < ActiveRecord::Migration[7.2]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
    add_index :carts, [:user_id, :book_id], unique: true
  end
end
