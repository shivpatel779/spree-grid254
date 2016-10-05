module Spree
  class ReferralMailer < BaseMailer
    def send_invite(user, invited_email)
      @sender = user
      subject = "#{@sender.email} has invited you to join Grid254"
      mail(to: invited_email, from: @sender.email, subject: subject)
    end

  end
end
