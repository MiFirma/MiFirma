class FeedbackSignaturesController < ApplicationController
 def create
    @feedback = FeedbackSignature.create!(params[:feedback_signature])
    flash[:notice] = "Gracias por tu respuesta!"
    respond_to do |format|
      format.js
    end
  end
end
