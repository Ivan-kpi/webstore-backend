class Order < ApplicationRecord
  belongs_to :user
  has_many :orders_descriptions
  has_many :items, through: :orders_descriptions
end
