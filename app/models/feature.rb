class Feature < ApplicationRecord
    validates :Feat_Title, :Feat_ExternalUrl, :Feat_Place, :Feat_MagType, :Feat_Latitude, :Feat_Longitude, presence: true
    validates :Feat_Mag, inclusion: { in: -1.0..10.0 }
    validates :Feat_Latitude, inclusion: { in: -90.0..90.0 }
    validates :Feat_Longitude, inclusion: { in: -180.0..180.0 }
    validates :Feat_ExternalUrl, uniqueness: true
    validates :Feat_ExternalId, uniqueness: true

    has_many :comments, dependent: :destroy
end