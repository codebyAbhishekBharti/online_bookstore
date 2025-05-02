class RemoveOrderGroupIdFromOrders < ActiveRecord::Migration[7.2]
  def change
    # Safely remove index first (only if it exists)
    remove_index :orders, :order_group_id if index_exists?(:orders, :order_group_id)

    # Then remove the column
    remove_column :orders, :order_group_id
  end
end
