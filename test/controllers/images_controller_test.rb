require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'index should successfully get the home page' do
    get root_path
    assert_response :ok
  end

  test 'index should have all stored images' do
    Image.create!(url: 'https://www.image.com/image.jpg')
    Image.create!(url: 'https://www.image.com/image2.jpg')
    Image.create!(url: 'https://www.image.com/image3.jpg')
    get root_path
    assert_response :ok
    assert_select 'img' do |images|
      assert_equal images.length, Image.count
    end
  end

  test 'index should display images in descending order of created_at time' do
    Image.create!(url: 'https://www.image.com/image.jpg')
    Image.create!(url: 'https://www.image.com/image2.jpg')
    Image.create!(url: 'https://www.image.com/image3.jpg')
    get root_path
    assert_response :ok
    assert_select 'img' do |images|
      assert_equal images[0].attribute('src').value, 'https://www.image.com/image3.jpg'
      assert_equal images[1].attribute('src').value, 'https://www.image.com/image2.jpg'
      assert_equal images[2].attribute('src').value, 'https://www.image.com/image.jpg'
    end
  end

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
