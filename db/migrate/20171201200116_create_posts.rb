class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :author
      t.text :content
      t.integer :parent_post

      t.timestamps
    end
  end
end
