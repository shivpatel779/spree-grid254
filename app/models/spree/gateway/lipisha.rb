require 'active_merchant/billing/gateways/lipisha'
class Spree::Gateway::Lipisha < Spree::Gateway

  preference :login, :string
  preference :password, :string
  preference :server, :string, default: "test"

  #preference :server,:string, default: 'test'
  #preference :test_mode, :boolean, default: true


  def provider_class
    ActiveMerchant::Billing::LipishaGateway
  end
  def payment_source_class
    Spree::CreditCard
  end

  def method_type
    'lipisha'
  end

  def purchase(amount, transaction_details, options = {})
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end
end