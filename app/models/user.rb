class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github, :google_oauth2]

  ## Custom
  field :availability_id, type: String, default: ""
  field :experience_level_id, type: String, default: ""
  field :rating, type: Float
  field :links, type: Array, default: []
  field :is_admin, type: Boolean, default: false

  belongs_to :company, inverse_of: :users
  belongs_to :availability
  belongs_to :experience_level
  has_one :wallet

  has_many :to_messages, class_name: 'Message', inverse_of: :to_user
  has_many :from_messages, class_name: 'Message', inverse_of: :from_user

  has_many :links
  has_many :payment_requests
  has_many :withdraw_requests

  ## Database authenticatable
  field :email,                 type: String, default: ""
  field :name,                  type: String, default: ""
  field :username,              type: String, default: ""
  field :image,              type: String, default: ""
  field :encrypted_password,    type: String, default: ""
  field :provider,              type: String, default: ""
  field :uid,                   type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.username = auth.info.nickname
      user.name = auth.info.name
      user.image = auth.info.image
      user.password = Devise.friendly_token[0,20]
    end
  end

  def as_json(options={})
    super(:only => [ :_id, :availability_id, :experience_level_id, :rating, :links, :name, :image, :created_at ],
      :include => {
        :availability => {:only => [:_id, :name]},
        :experience_level => {:only => [:_id, :name]},
        :links => {:only => [:_id, :title, :body, :user_id, :url]}
      }
    )
  end

  def is_current_user?(user_id)
    return id.to_s == user_id.to_s
  end
end
