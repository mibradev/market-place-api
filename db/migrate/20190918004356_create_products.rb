class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.decimal :price, null: false, default: 0.0, precision: 6, scale: 2
      t.boolean :published, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
