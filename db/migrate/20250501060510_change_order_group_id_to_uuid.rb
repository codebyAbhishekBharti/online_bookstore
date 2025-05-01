class ChangeOrderGroupIdToUuid < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :order_items, column: :order_group_id
    remove_index :orders, :order_group_id
    remove_column :orders, :order_group_id

    add_column :orders, :order_group_id, :uuid, default: "gen_random_uuid()", null: false
    add_index :orders, :order_group_id, unique: true

    # Drop and recreate the column in order_items
    remove_column :order_items, :order_group_id
    add_column :order_items, :order_group_id, :uuid

    add_foreign_key :order_items, :orders, column: :order_group_id, primary_key: :order_group_id
  end
end
