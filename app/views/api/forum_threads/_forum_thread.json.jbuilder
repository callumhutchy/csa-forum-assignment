json.extract! forum_thread, :id, :title, :user_id, :body, :unread_posts, :total_posts, :post_time, :created_at, :updated_at, :anonymous
json.url api_forum_thread_url(forum_thread, format: :json)
