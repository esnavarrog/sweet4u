class Profile < ApplicationRecord
  belongs_to :user
  mount_uploader :image1, ProfileImageUploader
  mount_uploader :image2, ProfileImageUploader
  mount_uploader :image3, ProfileImageUploader
  mount_uploader :image4, ProfileImageUploader
  mount_uploader :image5, ProfileImageUploader
  mount_uploader :image6, ProfileImageUploader

end
