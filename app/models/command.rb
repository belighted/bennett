class Command < ActiveRecord::Base
  belongs_to :project
  
  scope :sorted, order(:position)
end
