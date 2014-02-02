require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  test "should get index page" do
    3.times { create(:topic) }
    get :index
    assert_response :success, @response.body
  end

  test "should get show page" do
    get :show, id: create(:topic)
    assert_response :success, @response.body
  end

  test "should redirect to comment page" do
    topic = create(:topic)
    (Comment.default_per_page + 1).times { create :comment, commentable: topic, user: topic.user }
    comment = topic.comments.order(id: :asc).last
    get :show, id: topic, comment_id: comment
    assert_redirected_to topic_url(topic, page: comment.page, anchor: "comment-#{comment.id}")
  end

  test "should get new page" do
    assert_login_required do
      get :new
    end
    assert_response :success, @response.body
  end

  test "should create topic" do
    assert_difference "Topic.count" do
      assert_login_required do
        post :create, topic: attributes_for(:topic)
      end
    end
    topic = Topic.last
    assert_equal topic.user, topic.user
    assert_redirected_to topic
  end

  test "should edit topic" do
    topic = create(:topic)
    assert_login_required topic.user do
      get :edit, id: topic
    end
    assert_response :success, @response.body
  end

  test "should update topic" do
    topic = create(:topic)
    assert_login_required topic.user do
      patch :update, id: topic, topic: { title: 'change', content: 'change' }
    end
    topic.reload
    assert_equal 'change', topic.title
    assert_equal 'change', topic.content
    assert_redirected_to topic
  end
end
