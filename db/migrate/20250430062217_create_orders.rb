class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :order_group_id
      t.references :address, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :status

      t.timestamps
    end
  end
end
