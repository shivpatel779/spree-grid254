module Spree
  class ReferralMailer < BaseMailer
    def send_invite(user, invited_emails)
      @sender = user
      subject = "#{@sender.email} has invited you to join Grid254"
      invited_emails.each do |email|
        mail(to: email, from: @sender.email, subject: subject)
      end
    end

  end
end
