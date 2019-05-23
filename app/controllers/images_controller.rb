class ImagesController < ApplicationController
  def index
    @images = Image.order(created_at: :desc)
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)

    if !@image.save
      render 'new', status: :unprocessable_entity
    else
      redirect_to @image
    end
  end

  def show
    @image = Image.find_by(id: params[:id])
  end

  private

  def image_params
    params.require(:image).permit(:url, :tag_list)
  end
end
