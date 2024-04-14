class Comment < ApplicationRecord
    belongs_to :feature
  
    validates :Comm_Body, :feature, presence: true
  end