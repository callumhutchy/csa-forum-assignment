json.extract! unread_post, :id, :title, :author, :content, :parent_post, :created_at, :updated_at
json.url unread_post_url(unread_post, format: :json)
