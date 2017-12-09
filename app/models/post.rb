class Post < ApplicationRecord
    belongs_to :post, class_name: 'Post', optional: true
    belongs_to :forum_thread, class_name: 'ForumThread'
    belongs_to :user, class_name: 'User'
    has_many :posts, class_name: 'Post'
end
