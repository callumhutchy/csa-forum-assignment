class ForumThread < ApplicationRecord
    has_many :posts, :dependent => :destroy
    belongs_to :user, class_name: 'User'
   self.per_page = 8
end
