class AddUniqueIndexToOrderGroupIdInOrders < ActiveRecord::Migration[7.2]
  def change
    add_index :orders, :order_group_id, unique: true
  end
end
