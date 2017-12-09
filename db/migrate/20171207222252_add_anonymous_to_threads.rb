class AddAnonymousToThreads < ActiveRecord::Migration[5.1]
  def change
    add_column :forum_threads, :anonymous, :integer
  end
end
