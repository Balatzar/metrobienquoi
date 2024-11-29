class Station < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
