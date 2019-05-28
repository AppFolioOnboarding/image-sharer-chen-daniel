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

  test 'index should display tags with images' do
    Image.create!(url: 'https://www.image.com/image.jpg', tag_list: '#fun, #sun, #funinthesun')
    Image.create!(url: 'https://www.image.com/image2.jpg', tag_list: '#sun, #suninthefun')
    Image.create!(url: 'https://www.image.com/image3.jpg')
    get root_path
    assert_response :ok
    assert_select '.home-image, .js-image-tag' do |elements|
      assert_equal elements[0].attribute('src').value, 'https://www.image.com/image3.jpg'

      assert_equal elements[1].attribute('src').value, 'https://www.image.com/image2.jpg'
      assert_equal elements[2].content.strip, '#sun'
      assert_equal elements[3].content.strip, '#suninthefun'

      assert_equal elements[4].attribute('src').value, 'https://www.image.com/image.jpg'
      assert_equal elements[5].content.strip, '#fun'
      assert_equal elements[6].content.strip, '#sun'
      assert_equal elements[7].content.strip, '#funinthesun'
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

  test 'create should accept valid image url and empty tag_list and redirect' do
    assert_difference 'Image.count', 1 do
      post images_path, params: { image: { url: 'https://www.image.com/image.jpg', tag_list: '' } }
    end
    image = Image.last
    assert_redirected_to image
    assert_equal 'https://www.image.com/image.jpg', image.url
    assert_empty image.tag_list
  end

  test 'create should accept valid image url and tags and redirect' do
    assert_difference 'Image.count', 1 do
      post images_path, params: { image: { url: 'https://www.image.com/image.jpg', tag_list: '#fun, #sun' } }
    end
    image = Image.last
    assert_redirected_to image
    assert_equal 'https://www.image.com/image.jpg', image.url
    assert_includes image.tag_list, '#fun'
    assert_includes image.tag_list, '#sun'
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

  test 'show should show tags along with the image' do
    image = Image.create!(url: 'https://www.image.com/image.jpg', tag_list: '#funinthesun, #fun, #sun')
    get image_path(image.id)
    assert_response :ok
    assert_select 'img[src="https://www.image.com/image.jpg"]'
    assert_select '.js-image-tag' do |elements|
      assert_equal elements[0].content.strip, '#funinthesun'
      assert_equal elements[1].content.strip, '#fun'
      assert_equal elements[2].content.strip, '#sun'
    end
  end

  test 'filter should display only images with matching tags' do
    Image.create!(url: 'https://www.image.com/image.jpg', tag_list: '#fun, #sun, #funinthesun')
    Image.create!(url: 'https://www.image.com/image2.jpg')
    Image.create!(url: 'https://www.image.com/image3.jpg', tag_list: '#sun, #suninthefun')
    get images_path(tag: '#sun')
    assert_response :ok
    assert_select 'img[src="https://www.image.com/image.jpg"]'
    assert_select 'img[src="https://www.image.com/image2.jpg"]', false
    assert_select 'img[src="https://www.image.com/image3.jpg"]'
  end

  test 'filter should display no images if no tags match' do
    Image.create!(url: 'https://www.image.com/image.jpg', tag_list: '#fun, #sun, #funinthesun')
    Image.create!(url: 'https://www.image.com/image2.jpg')
    Image.create!(url: 'https://www.image.com/image3.jpg', tag_list: '#sun, #suninthefun')
    get images_path(tag: '#pun')
    assert_response :ok
    assert_select 'img', false
  end
end
