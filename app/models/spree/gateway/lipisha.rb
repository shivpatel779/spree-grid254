class Spree::Gateway::Lipisha < Spree::Gateway
  def provider_class
    Spree::Gateway::Lipisha
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