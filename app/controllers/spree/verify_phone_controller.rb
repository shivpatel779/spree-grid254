class Spree::VerifyPhoneController < ApplicationController

  def new
    @user = spree_current_user
  end

  def send_otp
    begin
      user        = spree_current_user
      sms_gateway = AfricasTalkingGateway.new(ATGUSERNAME, ATGKEY)

      current_otp = user.generate_otp

      resp = sms_gateway.sendMessage(user.phone, "Your Grid254 OTP is: #{current_otp}")

      session[:otp_data] = {
          otp:     current_otp,
          otp_ts:  DateTime.now,
          otp_uid: spree_current_user.id
      }

      p 'OTP Generated:   '+current_otp.to_s

      redirect_to '/verify_phone/enter_otp'

    rescue AfricasTalkingGatewayException => ex
      puts 'Encountered an error: ' + ex.message
    end
  end

  def verify_otp
    otp_data  = session[:otp_data]

    if (otp_data['otp'].eql?(params[:otp]))
      if (DateTime.now.to_f - otp_data['otp_ts'].to_datetime.to_f) < 45
        if otp_data['otp_uid'] == spree_current_user.id
          spree_current_user.update_attributes(phone_verified: true)
        else
          p 'user is different'
        end
      else
        p 'Time out'
      end

    else
      p 'OTP is not equal'
    end

    redirect_to spree.edit_account_url

  end

  def enter_otp;
  end

end
