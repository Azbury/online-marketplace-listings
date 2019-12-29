class CreateItemsTable < ActiveRecord::Migration
  def change
    create_table :items do |i|
      i.string :title
      i.string :description
      i.string :price
      i.integer :user_id
    end
  end
end
