module Api
  class FeedbacksController < ApplicationController
    def create
      fb = Feedback.new(feedback_params)

      if !fb.valid?
        render status: :unprocessable_entity, json: fb.errors.messages
      else
        fb.save
        render status: :ok, json: { message: 'Successfully stored feedback' }
      end
    end

    private

    def feedback_params
      params.require(:feedback).permit(:name, :comments)
    end
  end
end
