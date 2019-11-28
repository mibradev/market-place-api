class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.decimal :total, null: false, default: 0.0, precision: 7, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
