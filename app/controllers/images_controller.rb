class ImagesController < ApplicationController
  def index
    @images = if params[:tag]
                Image.tagged_with(params[:tag]).by_create_date
              else
                Image.by_create_date
              end
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

  def destroy
    image = Image.find_by(id: params[:id])
    if image.nil?
      flash[:alert] = 'Image does not exist'
    else
      image.delete
      flash[:notice] = 'Image successfully deleted'
    end
    redirect_to root_path
  end

  private

  def image_params
    params.require(:image).permit(:url, :tag_list)
  end
end
