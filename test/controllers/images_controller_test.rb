require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get new image form' do
    get new_image_path
    assert_response :ok
    assert_select 'form'
  end

  test 'should accept valid image url and redirect' do
    post images_path, params: { image: { url: 'https://www.image.com/image.jpg' } }
    image = Image.last
    assert_redirected_to image
  end

  test 'should show an image in the db' do
    image = Image.create!(url: 'https://www.w3schools.com/w3css/img_lights.jpg')
    get image_path(image.id)
    assert_response :ok
    assert_select 'img[src="https://www.w3schools.com/w3css/img_lights.jpg"]'
  end
end
