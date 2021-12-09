class AddTransactionTable < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :payer, null: false
      t.integer :points, null: false
      t.datetime :timestamp, null: false
      t.integer :remaining_points, null: false
    end
  end
end
