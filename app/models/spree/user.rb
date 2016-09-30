module Spree
  class User < Spree::Base
    include UserAddress
    include UserPaymentSource

    devise :database_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :validatable, :encryptable, :encryptor => 'authlogic_sha512'
    devise :confirmable if Spree::Auth::Config[:confirmable]

    OTP_SECRET = 'base32secret3232'

    acts_as_paranoid
    after_destroy :scramble_email_and_password

    validates :phone,:presence => true,
              :numericality => true,
              :length => { :minimum => 10, :maximum => 15 }

    has_many :orders

    has_one :personal_detail, :class_name => 'Spree::PersonalDetail', foreign_key: 'user_id'
    has_one :location_info, :class_name => 'Spree::LocationInfo', foreign_key: 'user_id'

    has_one :wallet, :class_name => 'Spree::UserWallet', foreign_key: 'user_id'

    before_validation :set_login

    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, -> { includes(:spree_roles).where("#{roles_table_name}.name" => "admin") }

    after_create :create_wallet

    def create_wallet
      wallet = Spree::UserWallet.new(wallet_balance: 0.0, user_id: self.id)
      wallet.save
    end

    def generate_otp
      otp = ROTP::TOTP.new OTP_SECRET
      update_attributes(current_otp: otp.now)
      return otp
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
        self.email = SecureRandom.uuid + "@example.net"
        self.login = self.email
        self.password = SecureRandom.hex(8)
        self.password_confirmation = self.password
        self.save
      end
  end
end
