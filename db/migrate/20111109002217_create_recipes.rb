class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :url
      t.string :image_url
      t.text :ingredients
      t.text :directions

      t.timestamps
    end
  end
end
