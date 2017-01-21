require 'active_merchant/billing/gateways/lipisha'

module Spree
  class User < Spree::Base
    include UserAddress
    include UserPaymentSource


    devise :database_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :validatable, :encryptable, :encryptor => 'authlogic_sha512'
    devise :confirmable if Spree::Auth::Config[:confirmable]

    OTP_SECRET = 'base32secret3232'
    serialize :phone, Array

    acts_as_paranoid
    after_destroy :scramble_email_and_password

=begin
    validates :phone, :presence => true,
              :numericality     => true,
              :length           => { :minimum => 10, :maximum => 15 }

    validates :phone, format: {
                        with:    /\+[1-9]{1}[0-9]{3,14}/,
                        message: 'is invalid'
                    }
=end

    has_many :orders

    has_one :personal_detail, :class_name => 'Spree::PersonalDetail', foreign_key: 'user_id'
    has_one :location_info, :class_name => 'Spree::LocationInfo', foreign_key: 'user_id'
    has_one :wallet, :class_name => 'Spree::UserWallet', foreign_key: 'user_id'
    has_one :spree_referral_credit, :class_name => 'Spree::ReferralCredit', foreign_key: 'user_id'
    has_many :spree_user_invites, :class_name => 'Spree::UserInvite', foreign_key: 'user_id'
    has_one :payment_account, :class_name => 'Spree::LipishaPaymentAccount', foreign_key: 'user_id'
    has_many :product_favorites, class_name: 'Spree::Favorite', foreign_key: 'user_id'


    before_validation :set_login

    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, -> { includes(:spree_roles).where("#{roles_table_name}.name" => "admin") }

    after_create :create_wallet, :create_referral_credit
    before_create :set_referral_code

    def full_name
      detail = personal_detail
      "#{detail.try(:first_name)} #{detail.try(:last_name)}"
    end

    # def create_payment_account
    #   debugger
    #   lipisha_payment_method = Spree::PaymentMethod.find_by(name: 'Lipisha')

    #   # payment_account_create_url = 'https://lipisha.com/payments/accounts/index.php/v2/api/create_payment_account' # live

    #   payment_account_create_url = 'http://developer.lipisha.com/index.php/v2/api/create_payment_account' # sandbox

    #   post = {}
    #   post[:api_key] = '08d17fe398450430c20ed24963ad38cd'
    #   post[:api_signature] = 'ZEIosXGjxTUpAByigXQ1EQZxu58ZyEZBl+nQNEvTPrnDLsVIOHgorxYcqQhts6hf4+W5MYl1tUOYyqrwH0oRXUWOWmnXhqMq8jYhtcVcuC22N1LVwVmKCesPoib7/Wvk7y6lEe3nuOWA2GMbhA9btSjFY9F0pPoA/DWR45OGE0A='
    #   post[:api_version] = '1.3.0'
    #   post[:api_type] = 'Callback'
    #   post[:transaction_account_type] = 1
    #   post[:transaction_account_name] = self.email.split('@').first
    #   post[:transaction_account_manager] = lipisha_payment_method.preferences[:login]

    #   # response = JSON.parse ActiveMerchant::Billing::LipishaGateway.new.create_lipisha_payment_account(self, post, payment_account_create_url)

    #   status = response['status']['status']
    #   if status == 'SUCCESS'
    #     payment_acc_info = {
    #         account_num: response['content']['transaction_account_number'],
    #         account_name: response['content']['transaction_account_name'],
    #         account_manager: response['content']['transaction_account_manager'],
    #         user_id: self.id
    #     }

    #     Spree::LipishaPaymentAccount.create(payment_acc_info)
    #   end

    # end

    def earn_referral_credit
      ref_cr = spree_referral_credit
      ref_cr.update_attributes(credit: (ref_cr.credit + 10))
    end

    def eligible_to_earn_invite?(invited_user)
      eligible = false
      if spree_user_invites.find_by(invited_email: invited_user)
        u = Spree::User.where(email: invited_user, is_invited: false).first
          u.update_attributes(is_invited: true)
          eligible = true
      end
      eligible
    end

    def send_invite(to)
      spree_user_invites.create(invited_email: to)
      Spree::ReferralMailer.send_invite(self, to).deliver
    end

    # this will deduct the referral credit by the size given
    def deduct_invite_credit(size)
      spree_referral_credit.update_attributes(credit: (spree_referral_credit.credit - size))
    end



    def set_referral_code
      self.referral_code = (0...8).map { (65 + rand(26)).chr }.join
    end

    def create_referral_credit
      referral_credit = Spree::ReferralCredit.new(user_id: self.id, credit: 10)
      referral_credit.save
    end

    def create_wallet
      wallet = Spree::UserWallet.new(wallet_balance: 0.0, user_id: self.id)
      wallet.save
    end

    def generate_otp
      otp = ROTP::TOTP.new OTP_SECRET
      update_attributes(current_otp: otp.now)
      return otp.now
    end

    def self.admin_created?
      User.admin.count > 0
    end

    def admin?
      has_spree_role?('admin')
    end

    protected
    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

    private

    def set_login
      # for now force login to be same as email, eventually we will make this configurable, etc.
      self.login ||= self.email if self.email
    end

    def scramble_email_and_password
      self.email                 = SecureRandom.uuid + "@example.net"
      self.login                 = self.email
      self.password              = SecureRandom.hex(8)
      self.password_confirmation = self.password
      self.save
    end
  end
end