module Api
  class AssetsController < BaseController
    before_action :require_authentication
    before_action :set_submission_and_asset, only: [:show]
    before_action :set_submission, only: [:create]
    before_action :require_authorized_submission

    def show
      param! :id, String, required: true

      render json: @asset.to_json, status: 200
    end

    def create
      param! :asset_type, String, default: 'image'
      param! :gemini_token, String, required: true
      param! :submission_id, String, required: true

      asset = @submission.assets.create(asset_params)
      render json: asset.to_json, status: 201
    end

    private

    def set_submission_and_asset
      @asset = Asset.find(params[:id])
      @submission = @asset.submission
    end

    def asset_params
      params.permit(
        :asset_type,
        :gemini_token,
        :submission_id
      )
    end
  end
end
