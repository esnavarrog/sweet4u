class Profile < ApplicationRecord
  belongs_to :user
  mount_uploader :image1, ProfileImageUploader
  mount_uploader :image2, ProfileImageUploader
  mount_uploader :image3, ProfileImageUploader
  mount_uploader :image4, ProfileImageUploader
  mount_uploader :image5, ProfileImageUploader
  mount_uploader :image6, ProfileImageUploader


  def complete_percentage
    count = 0
    count += 1 if image1.present?
    count += 1 if image2.present?
    count += 1 if image3.present?
    count += 1 if bio.present?
    count += 1 if birthdate.present?
    count += 1 if gender.present?
    count += 1 if sexual_orientation.present?
    count += 1 if location.present?
    count += 1 if interests.present?
    count += 1 if looking_for.present?
    count += 1 if relationship_type.present?
    count += 1 if height.present?
    count += 1 if body_type.present?
    count += 1 if ethnicity.present?
    count += 1 if education.present?
    count += 1 if occupation.present?
    count += 1 if religion.present?
    count += 1 if political_views.present?

    count * 100 / 18
  end
end
