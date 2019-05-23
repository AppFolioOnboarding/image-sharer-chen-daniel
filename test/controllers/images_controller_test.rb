require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'new should get new image form' do
    get new_image_path
    assert_response :ok
    assert_select 'form'
  end

  test 'create should accept valid image url and redirect' do
    assert_difference 'Image.count', 1 do
      post images_path, params: { image: { url: 'https://www.image.com/image.jpg' } }
    end
    image = Image.last
    assert_redirected_to image
    assert_equal 'https://www.image.com/image.jpg', image.url
  end

  test 'create should reject invalid image url and rerender' do
    assert_no_difference 'Image.count' do
      post images_path, params: { image: { url: 'asdf' } }
    end
    assert_response :unprocessable_entity
  end

  test 'show should show an image in the db' do
    image = Image.create!(url: 'https://www.w3schools.com/w3css/img_lights.jpg')
    get image_path(image.id)
    assert_response :ok
    assert_select 'img[src="https://www.w3schools.com/w3css/img_lights.jpg"]'
  end
end
