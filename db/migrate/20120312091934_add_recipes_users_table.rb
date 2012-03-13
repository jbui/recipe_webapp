class AddRecipesUsersTable < ActiveRecord::Migration
  def up
    create_table :recipes_users do |t|
      t.integer :recipe_id
      t.integer :user_id
    end
  end

  def down
    drop_table :recipes_users
  end
end
