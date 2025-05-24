class AddAvatarImageToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :avatar_image, :integer
  end
end
