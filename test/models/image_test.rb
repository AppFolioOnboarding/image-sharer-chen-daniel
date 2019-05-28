require 'test_helper'

class ImageTest < ActionDispatch::IntegrationTest
  test 'should create an image with a valid URL' do
    image = Image.create!(url: 'https://www.image.com/image.jpg')
    assert_equal image, Image.last
  end

  test 'should reject a URL that is not valid' do
    assert_raises(ActiveRecord::RecordInvalid) do
      Image.create!(url: 'asdfmovie')
    end
  end

  test 'should reject a URL that is does not have an image extension' do
    assert_raises(ActiveRecord::RecordInvalid) do
      Image.create!(url: 'https://www,google.com')
    end
  end

  test 'validates properly formatted URLs' do
    image = Image.new(url: 'httpl://www.google.com/image.jpg')
    assert_not image.valid?
    image = Image.new(url: 'httpl://www.google.com/image')
    assert_not image.valid?
    image = Image.new(url: 'httpl://www.google.com/image.j')
    assert_not image.valid?
    image = Image.new(url: 'www.google.com/image.jpg')
    assert_not image.valid?
    image = Image.new(url: 'https://www.google.com/image.jpg')
    assert image.valid?
  end

  test 'should accept an image with no tags' do
    image = Image.create!(url: 'https://www.image.com/image.jpg')
    image2 = Image.last
    assert_equal image, image2
    assert_empty image2.tag_list
  end

  test 'should accept a tag for an image' do
    tag = '#fun'
    image = Image.create!(url: 'https://www.image.com/image.jpg', tag_list: tag)
    image2 = Image.last
    assert_equal image, image2
    assert_equal 1, image2.tag_list.length
    assert_equal tag, image2.tag_list[0]
  end

  test 'should accept a list of tags for an image' do
    tags = '#fun, #sun, #funinthesun'
    image = Image.create!(url: 'https://www.image.com/image.jpg', tag_list: tags)
    image2 = Image.last
    assert_equal image, image2
    assert_equal 3, image2.tag_list.length
    assert_includes image2.tag_list, '#fun'
    assert_includes image2.tag_list, '#sun'
    assert_includes image2.tag_list, '#funinthesun'
  end

  test 'by_create_date scope should order by descending create_date' do
    image1 = Image.create!(url: 'https://www.image.com/image.jpg', created_at: Time.utc(2008, 7, 8, 9, 10))
    image2 = Image.create!(url: 'https://www.image.com/image.jpg', created_at: Time.utc(2008, 7, 8, 9, 12))
    image3 = Image.create!(url: 'https://www.image.com/image.jpg', created_at: Time.utc(2008, 7, 8, 9, 11))
    image4 = Image.create!(url: 'https://www.image.com/image.jpg', created_at: Time.utc(2008, 7, 8, 9, 13))
    images = Image.by_create_date
    assert_equal images[0], image4
    assert_equal images[1], image2
    assert_equal images[2], image3
    assert_equal images[3], image1
  end
end
