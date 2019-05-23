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
end
