class UserMailer < ApplicationMailer
  helper :url, :submissions

  def submission_receipt(submission:, user:, user_detail:, artist:)
    @submission = submission
    @user = user
    @user_detail = user_detail
    @artist = artist
    @utm_params = utm_params(source: 'consignment-receipt', campaign: 'consignment-complete')

    smtpapi category: ['submission_receipt'], unique_args: {
      submission_id: submission.id
    }
    mail(to: user_detail.email,
         subject: "Consignment Submission Confirmation ##{@submission.id}",
         bcc: [Convection.config.admin_email_address, Convection.config.bcc_email_address])
  end

  def first_upload_reminder(submission:, user:, user_detail:)
    @submission = submission
    @user = user
    @user_detail = user_detail
    @utm_params = utm_params(source: 'drip-consignment-reminder-e01', campaign: 'consignment-complete')

    smtpapi category: ['first_upload_reminder'], unique_args: {
      submission_id: submission.id
    }
    mail to: user_detail.email, subject: "You're Almost Done"
  end

  def second_upload_reminder(submission:, user:, user_detail:)
    @submission = submission
    @user = user
    @user_detail = user_detail
    @utm_params = utm_params(source: 'drip-consignment-reminder-e02', campaign: 'consignment-complete')

    smtpapi category: ['second_upload_reminder'], unique_args: {
      submission_id: submission.id
    }
    mail to: user_detail.email, subject: "You're Almost Done"
  end

  def third_upload_reminder(submission:, user:, user_detail:)
    @submission = submission
    @user = user
    @user_detail = user_detail
    @utm_params = utm_params(source: 'drip-consignment-reminder-e03', campaign: 'consignment-complete')

    smtpapi category: ['third_upload_reminder'], unique_args: {
      submission_id: submission.id
    }
    mail to: user_detail.email, subject: 'Last chance to complete your consignment'
  end

  def submission_approved(submission:, user:, user_detail:, artist:)
    @submission = submission
    @user = user
    @user_detail = user_detail
    @artist = artist
    @utm_params = utm_params(source: 'consignment-approved', campaign: 'consignment-complete')

    smtpapi category: ['submission_approved'], unique_args: {
      submission_id: submission.id
    }
    mail(to: user_detail.email,
         subject: 'Your consignment has been approved')
  end

  def submission_rejected(submission:, user:, user_detail:, artist:)
    @submission = submission
    @user = user
    @user_detail = user_detail
    @artist = artist
    @utm_params = utm_params(source: 'consignment-rejected', campaign: 'consignment-complete')

    smtpapi category: ['submission_rejected'], unique_args: {
      submission_id: submission.id
    }
    mail(to: user_detail.email,
         subject: 'An important update about your consignment submission')
  end

  def offer(offer:, user:, user_detail:, artist:)
    @offer = offer
    @submission = offer.submission
    @artist = artist
    @user = user
    @user_detail = user_detail
    @utm_params = utm_params(source: 'consignment-offer', campaign: 'consignment-offer')

    smtpapi category: ['offer'], unique_args: {
      offer_id: offer.id
    }
    mail(to: user_detail.email,
         subject: 'An important update about your consignment submission')
  end
end
