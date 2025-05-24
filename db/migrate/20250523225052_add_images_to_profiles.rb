class AddImagesToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :image1, :string
    add_column :profiles, :image2, :string
    add_column :profiles, :image3, :string
    add_column :profiles, :image4, :string
    add_column :profiles, :image5, :string
    add_column :profiles, :image6, :string
  end
end
