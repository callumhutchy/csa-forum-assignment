class CreateForumThreads < ActiveRecord::Migration[5.1]
  def change
    create_table :forum_threads do |t|
      t.string :title
      t.string :author
      t.text :body
      t.integer :unread_posts
      t.integer :total_posts
      t.datetime :post_time

      t.timestamps
    end
  end
end
