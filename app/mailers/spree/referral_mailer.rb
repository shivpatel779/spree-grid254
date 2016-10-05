module Spree
  class ReferralMailer < BaseMailer
    def send_invite(user, invited_email)
      @sender = user
      subject = "#{@sender.email} has invited you to join Grid254"
      mail(to: invited_email, from: @sender.email, subject: subject)
    end

    def invite_earned(user, invited_user)
      @user, @invited_user = user, invited_user
      subject = "Congratulations! You've earned the Referral Credits"
      mail(to: @user.email, from: 'noreply@grid254.com', subject: subject)
    end

  end
end