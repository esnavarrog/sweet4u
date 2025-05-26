class CreateReadReceipts < ActiveRecord::Migration[7.2]
  def change
    create_table :read_receipts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true
      t.datetime :read_at

      t.timestamps
    end
  end
end
