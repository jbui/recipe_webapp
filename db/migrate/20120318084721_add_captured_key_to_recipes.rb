class AddCapturedKeyToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :captured_key, :string
  end
end
