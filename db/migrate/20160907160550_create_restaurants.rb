class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :category
      t.string :rating
      t.string :name
      t.string :address
      t.string :image_url
      t.string :phone
      t.string :menu_link

      t.timestamps
    end
  end
end
