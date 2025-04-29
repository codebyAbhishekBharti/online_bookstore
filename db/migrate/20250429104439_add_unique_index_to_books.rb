class AddUniqueIndexToBooks < ActiveRecord::Migration[7.2]
  def change
    add_index :books, [:title, :vendor_id], unique: true
  end
end
