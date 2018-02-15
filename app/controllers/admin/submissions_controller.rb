module Admin
  class SubmissionsController < ApplicationController
    include GraphqlHelper

    before_action :set_submission, only: [:show, :edit, :update]
    before_action :set_pagination_params, only: [:index]

    def index
      @filters = { state: params[:state], user: params[:user] }
      @term = params[:term]

      @submissions = Submission.all
      @submissions = @submissions.search(@term) if @term.present?
      @submissions = @submissions.where(state: params[:state]) if params[:state].present?
      @submissions = @submissions.where(user_id: params[:user]) if params[:user].present?
      @submissions = @submissions.order(id: :desc).page(@page).per(@size)
      @artist_details = artists_query(@submissions.map(&:artist_id))

      respond_to do |format|
        format.html
        format.json do
          submissions_with_thumbnails = @submissions.map { |submission| submission.as_json.merge(thumbnail: submission.thumbnail) }
          render json: submissions_with_thumbnails || []
        end
      end
    end

    def new
      @submission = Submission.new
    end

    def create
      @submission = SubmissionService.create_submission(submission_params.merge(state: 'submitted'), params[:submission][:user_id])
      redirect_to admin_submission_path(@submission)
    rescue SubmissionService::SubmissionError => e
      @submission = Submission.new(submission_params)
      flash.now[:error] = e.message
      render 'new'
    end

    def show
      notified_partner_submissions = @submission.partner_submissions.where.not(notified_at: nil)
      @partner_submissions_count = notified_partner_submissions.group_by_day.count
      @offers = @submission.offers
    end

    def edit; end

    def update
      if SubmissionService.update_submission(@submission, submission_params, @current_user)
        redirect_to admin_submission_path(@submission)
      else
        render 'edit'
      end
    end

    def match_artist
      if params[:term]
        @term = params[:term]
        @artists = Gravity.client.artists(term: @term).artists
      end
      respond_to do |format|
        format.json { render json: @artists || [] }
      end
    end

    def match_user
      if params[:term]
        @term = params[:term]
        @users = Gravity.client.users(term: @term).users
      end
      respond_to do |format|
        format.json { render json: @users || [] }
      end
    end

    private

    def set_submission
      @submission = Submission.find(params[:id])
    end

    def submission_params
      params.require(:submission).permit(
        :artist_id,
        :authenticity_certificate,
        :category,
        :depth,
        :dimensions_metric,
        :edition_number,
        :edition_size,
        :height,
        :location_city,
        :location_country,
        :location_state,
        :medium,
        :primary_image_id,
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
