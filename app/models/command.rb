class Command < ActiveRecord::Base
  belongs_to :project
  
  validates :position, :presence => true
  
  before_validation :set_default_position, :on => :create
  
  scope :sorted, order(:position)
  default_scope order(:position)
  
  def set_default_position
    self.position = project.commands.map(&:position).push(0).max + 1
  end
end
