module Api
  class SubmissionsController < BaseController
    before_action :require_authentication
    before_action :set_submission, only: [:show, :update]
    before_action :require_authorized_submission, only: [:show, :update]
    before_action :set_pagination_params, only: [:index]

    def show
      render json: @submission.to_json, status: 200
    end

    def create
      param! :artist_id, String, required: true

      create_params = submission_params(params).merge(user_id: current_user)
      submission = Submission.create!(create_params)
      render json: submission.to_json, status: 201
    end

    def update
      SubmissionService.update_submission(@submission, submission_params(params))
      render json: @submission.to_json, status: 201
    end

    def index
      param! :completed, :boolean, default: nil

      submissions = Submission.where(user_id: current_user)
      if params.include? :completed
        submissions = params[:completed] ? submissions.completed : submissions.draft
      end

      submissions = submissions.order(created_at: :desc).page(@page).per(@size)
      render json: submissions.to_json, status: 200
    end

    private

    def submission_params(params)
      params.permit(
        :additional_info,
        :artist_id,
        :authenticity_certificate,
        :category,
        :deadline_to_sell,
        :depth,
        :dimensions_metric,
        :edition,
        :edition_number,
        :edition_size,
        :height,
        :location_city,
        :location_country,
        :location_state,
        :medium,
        :provenance,
        :signature,
        :state,
        :title,
        :width,
        :year
      )
    end
  end
end
