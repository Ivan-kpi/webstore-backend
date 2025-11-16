class CreateOrdersDescriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :orders_descriptions do |t|
      t.references :order, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
