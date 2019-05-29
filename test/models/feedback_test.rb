require 'test_helper'

class FeedbackTest < ActionDispatch::IntegrationTest
  test 'should create a Feedback with a name and comments' do
    assert_difference 'Feedback.count', 1 do
      fb = Feedback.create!(name: 'Daniel', comments: 'Feedfront')
      assert_equal fb, Feedback.last
    end
  end

  test 'should reject Feedbacks that are missing either a name or comments' do
    assert_no_difference 'Feedback.count' do
      fb = Feedback.new
      assert_raises(ActiveRecord::RecordInvalid) do
        fb.save!
      end
      assert_equal fb.errors.messages, name: ["can't be blank"], comments: ["can't be blank"]
    end
  end
end
