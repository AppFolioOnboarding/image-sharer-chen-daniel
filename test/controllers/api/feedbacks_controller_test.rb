require 'test_helper'

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  test 'create should successfully create a feedback and respond with ok' do
    assert_difference 'Feedback.count', 1 do
      post api_feedbacks_path, params: { feedback: { name: 'Daniel', comments: 'Nice' } }
    end
    assert_equal Feedback.last.name, 'Daniel'
    assert_equal Feedback.last.comments, 'Nice'
    assert_response :ok
  end

  test 'create should fail to create feedback with missing name' do
    assert_no_difference 'Feedback.count' do
      post api_feedbacks_path, params: { feedback: { comments: 'Daniel' } }
    end
    assert_response :unprocessable_entity
    res = JSON.parse(response.body)
    assert_equal res['name'].length, 1
    assert_equal res['name'][0], "can't be blank"
  end

  test 'create should fail to create feedback with missing comments' do
    assert_no_difference 'Feedback.count' do
      post api_feedbacks_path, params: { feedback: { name: 'Nice' } }
    end
    assert_response :unprocessable_entity
    res = JSON.parse(response.body)
    assert_equal res['comments'].length, 1
    assert_equal res['comments'][0], "can't be blank"
  end
end
