class Spree::VerifyPhoneController < ApplicationController

  def new
    @user = spree_current_user
  end

  def send_otp
    begin
      user        = spree_current_user
      sms_gateway = AfricasTalkingGateway.new(ATGUSERNAME, ATGKEY)

      current_otp = user.generate_otp
      #session[:current_otp] = {otp: current_otp, otp_ts: Time.now}
      resp       = sms_gateway.sendMessage('+254722616478', "Your Grid254 OTP is: #{current_otp.now}")

      p 'OTP Generated:   '+current_otp.now.to_s

      redirect_to '/verify_phone/enter_otp'

    rescue AfricasTalkingGatewayException => ex
      puts 'Encountered an error: ' + ex.message
    end
  end

  def verify_otp

    a.verify(params[:otp])
    exit
  end

  def enter_otp; end

end
