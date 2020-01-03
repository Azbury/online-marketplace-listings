#Class for Items table in database
class Item < ActiveRecord::Base
  belongs_to :user
end
