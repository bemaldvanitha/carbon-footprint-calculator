class User < ApplicationRecord
  belongs_to :user_type
  has_many :carbon_emissions
end
