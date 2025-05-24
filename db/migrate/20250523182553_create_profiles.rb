class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :bio
      t.date :birthdate
      t.string :gender
      t.string :sexual_orientation
      t.string :location
      t.string :interests, array: true, default: []
      t.string :looking_for
      t.string :relationship_type
      t.integer :height
      t.string :body_type
      t.string :ethnicity
      t.string :education
      t.string :occupation
      t.string :religion
      t.string :political_views
      t.string :age_range, default: '18-99'
      t.integer :distance_range, default: 100
      t.boolean :is_visible, default: true
      t.jsonb :gallery, default: []

      t.timestamps
    end
  end
end
