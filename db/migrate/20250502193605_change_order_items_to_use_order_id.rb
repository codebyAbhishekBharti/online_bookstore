class ChangeOrderItemsToUseOrderId < ActiveRecord::Migration[7.2]
  def change
    # Step 1: Add new order_id column to order_items (nullable initially)
    add_reference :order_items, :order, foreign_key: true

    # Step 2: Copy data from order_group_id → order_id
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE order_items
          SET order_id = orders.id
          FROM orders
          WHERE order_items.order_group_id = orders.order_group_id
        SQL
      end
    end

    # Step 3: Now enforce NOT NULL
    change_column_null :order_items, :order_id, false

    # Step 4: Remove old foreign key and columns
    remove_foreign_key :order_items, column: :order_group_id
    remove_column :order_items, :order_group_id

    # Step 5: Remove index and column from orders table
    remove_index :orders, :order_group_id
    remove_column :orders, :order_group_id
  end
end
