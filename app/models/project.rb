class Project < ApplicationRecord
  belongs_to :category
  belongs_to :location
  belongs_to :certification_type
  belongs_to :project_developer
  belongs_to :project_design_validator
  belongs_to :credits_validator
  has_many :project_images
  has_many :technical_documents
  has_many :payments
end
