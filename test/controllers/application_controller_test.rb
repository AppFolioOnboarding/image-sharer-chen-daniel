require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    Image.create!(url: 'https://www.image.com/image.jpg')
    Image.create!(url: 'https://www.image.com/image2.jpg')
    Image.create!(url: 'https://www.image.com/image3.jpg')
    get root_path
    assert_response :ok
    assert_select 'img' do |images|
      assert_equal images.length, Image.count
      assert_equal images.first.attribute('src').value, 'https://www.image.com/image3.jpg'
    end
  end
end
