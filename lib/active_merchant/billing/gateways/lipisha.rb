require 'active_merchant/posts_data'
module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class LipishaGateway < Gateway

      #include PaypalCommonAPI
      #include PaypalRecurringApi

      self.supported_cardtypes = [:visa, :master, :american_express, :discover]

      self.live_url = 'https://lipisha.com/payments/accounts/index.php/v2/api/authorize_card_transaction'
      #self.api_key = '218c31c2d9934f802a12d44acf619a0f'
      #self.api_signature = 'nl1HSEeTGcGe6KAAyWPXgD316L6WGNVdWVXUR/20rupoGu4VPUTinvisBuTao0DnsBLW+TYimpBsMKXvlozLlAQDXfNKk7vurwc6ydqzPBk42BjqsUe3Jkoz+o3x/fz28tsQlR3WPt1PIcRWtW7mqX7JJP5RZQUyfmBXXhyDGKw='


      # api_key = 1ffc8c725ff816ed8fa3f9c9185a1bec
      # signature = 'k9BRQLhM0MU4OP/ewMbfcnqyVscBTtqnK//75OVh04rIZjUrc1UwhIxLvVG7bJ4/SXwIAJg3eC6M0RAd7gokyhUkJetfL4ctjIy+7JAaujtsb57y+i8gmTmEVjTIftYbKLRxiywt4Y8PGPEOSJi/of/0n296DKoB2M5leL0gUxc='

      def authorize(amount, credit_card, options = {})
        post = fields_required_for_cc_transaction(amount, credit_card, options)
      end

      def fields_required_for_cc_transaction(amount, credit_card, options)
        post = {}
        #post[:api_key] = '15d2c925e9ffba7134f4b31d1c6a9123'
        #post[:api_signature] = '7AzJLsSYQZKME/t5X1jcBD0B2YW7JiHN1cFUNZyzJfd6N3icngqv8v6qb95Pm1Mzj/7AwCJFSH+KhZWJKRgCERFmMX6aGtpXQA7C9oPCArvlwbyMjGlDUaVdUTVKgfKkIrYEILadXyXXDcwdXOhYH6bpnoQNp556uR0y+SzyKtQ='

        post[:api_key] = '1ffc8c725ff816ed8fa3f9c9185a1bec'
        post[:api_signature] = 'k9BRQLhM0MU4OP/ewMbfcnqyVscBTtqnK//75OVh04rIZjUrc1UwhIxLvVG7bJ4/SXwIAJg3eC6M0RAd7gokyhUkJetfL4ctjIy+7JAaujtsb57y+i8gmTmEVjTIftYbKLRxiywt4Y8PGPEOSJi/of/0n296DKoB2M5leL0gUxc='
        post[:api_version] = '1.3.0'
        post[:api_type] = 'Callback'
        post[:account_number] = '06934'
        post[:card_number] = credit_card.number
        post[:address1] = options[:billing_address][:address1]
        post[:address2] = options[:billing_address][:address2]
        post[:expiry] = expdate(credit_card)
        post[:name] = credit_card.name if credit_card.name
        post[:country] = options[:billing_address][:country]
        post[:state] = options[:billing_address][:state]
        post[:zip] = options[:billing_address][:zip]
        post[:security_code] = credit_card.verification_value
        post[:amount] = amount(amount)
        post[:currency] = 'KES'

        commit(:authorize, amount, post)

      end

      def commit(action, money, parameters)
        response = ssl_post self.live_url , parameters.collect { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
        p 'TRANSACTION RESPONSE FROM LIPISHA'
        p response.inspect

        Response.new(response[:success] , response[:message], response,
                     :authorization => response[:transaction_id],
                     :avs_result => { :code => response[:avs_result] },
                     :cvv_result => response[:cvv_result]
        )
      end

      def post_data(action, parameters = {})
        post = {}
        request = post.merge(parameters).collect { |key, value| "x_#{key}=#{CGI.escape(value.to_s)}" }.join("&")
        request
      end

      def expdate(creditcard)
        "#{format(creditcard.month, :two_digits)}#{format(creditcard.year, :four_digits)}"
      end

      def create_lipisha_payment_account(user, data, payment_account_create_url)
        data = ssl_post payment_account_create_url , data.collect { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
        data
      end


      def purchase(money, credit_card_or_referenced_id, options = {})
        requires!(options, :ip)
        commit define_transaction_type(credit_card_or_referenced_id), build_sale_or_authorization_request('Sale', money, credit_card_or_referenced_id, options)
      end

      def verify(credit_card, options = {})
        if %w(visa master).include?(credit_card.brand)
          authorize(0, credit_card, options)
        else
          MultiResponse.run(:use_first_response) do |r|
            r.process { authorize(100, credit_card, options) }
            r.process(:ignore_result) { void(r.authorization, options) }
          end
        end
      end

      def express
        @express ||= PaypalExpressGateway.new(@options)
      end

      def supports_scrubbing?
        true
      end

      def scrub(transcript)
        transcript.
          gsub(%r((<n1:Password>).+(</n1:Password>)), '\1[FILTERED]\2').
          gsub(%r((<n1:Username>).+(</n1:Username>)), '\1[FILTERED]\2').
          gsub(%r((<n2:CreditCardNumber>).+(</n2:CreditCardNumber)), '\1[FILTERED]\2').
          gsub(%r((<n2:CVV2>).+(</n2:CVV2)), '\1[FILTERED]\2')
      end

      private

      def define_transaction_type(transaction_arg)
        if transaction_arg.is_a?(String)
          return 'DoReferenceTransaction'
        else
          return 'DoDirectPayment'
        end
      end

      def build_sale_or_authorization_request(action, money, credit_card_or_referenced_id, options)
        transaction_type = define_transaction_type(credit_card_or_referenced_id)
        reference_id = credit_card_or_referenced_id if transaction_type == "DoReferenceTransaction"

        billing_address = options[:billing_address] || options[:address]
        currency_code = options[:currency] || currency(money)

        xml = Builder::XmlMarkup.new :indent => 2
        xml.tag! transaction_type + 'Req', 'xmlns' => PAYPAL_NAMESPACE do
          xml.tag! transaction_type + 'Request', 'xmlns:n2' => EBAY_NAMESPACE do
            xml.tag! 'n2:Version', API_VERSION
            xml.tag! 'n2:' + transaction_type + 'RequestDetails' do
              xml.tag! 'n2:ReferenceID', reference_id if transaction_type == 'DoReferenceTransaction'
              xml.tag! 'n2:PaymentAction', action
              add_payment_details(xml, money, currency_code, options)
              add_credit_card(xml, credit_card_or_referenced_id, billing_address, options) unless transaction_type == 'DoReferenceTransaction'
              xml.tag! 'n2:IPAddress', options[:ip]
            end
          end
        end

        xml.target!
      end

      def add_credit_card(xml, credit_card, address, options)
        xml.tag! 'n2:CreditCard' do
          xml.tag! 'n2:CreditCardType', credit_card_type(card_brand(credit_card))
          xml.tag! 'n2:CreditCardNumber', credit_card.number
          xml.tag! 'n2:ExpMonth', format(credit_card.month, :two_digits)
          xml.tag! 'n2:ExpYear', format(credit_card.year, :four_digits)
          xml.tag! 'n2:CVV2', credit_card.verification_value

          if [ 'switch', 'solo' ].include?(card_brand(credit_card).to_s)
            xml.tag! 'n2:StartMonth', format(credit_card.start_month, :two_digits) unless credit_card.start_month.blank?
            xml.tag! 'n2:StartYear', format(credit_card.start_year, :four_digits) unless credit_card.start_year.blank?
            xml.tag! 'n2:IssueNumber', format(credit_card.issue_number, :two_digits) unless credit_card.issue_number.blank?
          end

          xml.tag! 'n2:CardOwner' do
            xml.tag! 'n2:PayerName' do
              xml.tag! 'n2:FirstName', credit_card.first_name
              xml.tag! 'n2:LastName', credit_card.last_name
            end

            xml.tag! 'n2:Payer', options[:email]
            add_address(xml, 'n2:Address', address)
          end
        end
      end

      def credit_card_type(type)
        case type
        when 'visa'             then 'Visa'
        when 'master'           then 'MasterCard'
        when 'discover'         then 'Discover'
        when 'american_express' then 'Amex'
        when 'switch'           then 'Switch'
        when 'solo'             then 'Solo'
        end
      end

      def build_response(success, message, response, options = {})
         Response.new(success, message, response, options)
      end
    end
  end
end
