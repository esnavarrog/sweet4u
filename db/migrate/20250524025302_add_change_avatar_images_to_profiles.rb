class AddChangeAvatarImagesToProfiles < ActiveRecord::Migration[7.2]
  def change
    change_column :profiles, :avatar_image, :integer, default: 1
  end
end
