class CreateFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :features do |t|
      t.string :Feat_ExternalId
      t.string :Feat_ExternalUrl
      t.string :Feat_Title
      t.string :Feat_Place
      t.string :Feat_MagType
      t.float :Feat_Mag
      t.float :Feat_Latitude
      t.float :Feat_Longitude
      t.datetime :Feat_Time
      t.boolean :Feat_Tsunami

      t.timestamps
    end
    add_index :features, :Feat_ExternalId
    add_index :features, :Feat_ExternalUrl
  end
end
