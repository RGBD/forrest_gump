class WebNode < ApplicationRecord
  belongs_to :parent, class_name: 'WebNode', optional: true

  validates :name, presence: true
end
