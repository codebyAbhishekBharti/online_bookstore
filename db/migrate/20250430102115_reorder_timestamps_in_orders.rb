class ReorderTimestampsInOrders < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :created_at
    remove_column :orders, :updated_at

    add_column :orders, :created_at, :datetime, null: false
    add_column :orders, :updated_at, :datetime, null: false
  end
end
