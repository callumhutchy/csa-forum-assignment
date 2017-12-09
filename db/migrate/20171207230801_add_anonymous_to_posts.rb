class AddAnonymousToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :anonymous, :integer
  end
end
