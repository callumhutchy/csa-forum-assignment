class AddForeignToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :forum_thread_id, :integer
  end
end
