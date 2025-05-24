class AddDataToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :avatar, :string
    add_column :users, :name, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :bio, :text
    add_column :users, :birthdate, :date
    add_column :users, :username, :string
    add_column :users, :gender, :integer
  end
end
