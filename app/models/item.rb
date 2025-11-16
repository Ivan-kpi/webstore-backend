class Item < ApplicationRecord
  has_many :orders_descriptions
  has_many :orders, through: :orders_descriptions
end
