require 'test_helper'

class ForumThreadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum_thread = forum_threads(:one)
  end

  test "should get index" do
    get forum_threads_url
    assert_response :success
  end

  test "should get new" do
    get new_forum_thread_url
    assert_response :success
  end

  test "should create forum_thread" do
    assert_difference('ForumThread.count') do
      post forum_threads_url, params: { forum_thread: { author: @forum_thread.user_id, body: @forum_thread.body, post_time: @forum_thread.post_time, title: @forum_thread.title, total_posts: @forum_thread.total_posts, unread_posts: @forum_thread.unread_posts } }
    end

    assert_redirected_to forum_thread_url(ForumThread.last)
  end

  test "should show forum_thread" do
    get forum_thread_url(@forum_thread)
    assert_response :success
  end

  test "should get edit" do
    get edit_forum_thread_url(@forum_thread)
    assert_response :success
  end

  test "should update forum_thread" do
    patch forum_thread_url(@forum_thread), params: { forum_thread: { author: @forum_thread.user_id, body: @forum_thread.body, post_time: @forum_thread.post_time, title: @forum_thread.title, total_posts: @forum_thread.total_posts, unread_posts: @forum_thread.unread_posts } }
    assert_redirected_to forum_thread_url(@forum_thread)
  end

  test "should destroy forum_thread" do
    assert_difference('ForumThread.count', -1) do
      delete forum_thread_url(@forum_thread)
    end

    assert_redirected_to forum_threads_url
  end
end
