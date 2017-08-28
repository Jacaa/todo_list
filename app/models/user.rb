class User < ApplicationRecord
  before_save   { downcase_email }
  before_create { generate_token(:activation_token)}
  before_create { generate_token(:remember_token)}
  
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_many :tasks, dependent: :destroy

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns random string/token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.sign_in_from_omniauth(auth)
    find_by(provider: auth["provider"], uid: auth["uid"]) || create_user(auth)
  end

  def self.create_user(auth)
    random_password = User.new_token[0..15]
    create(provider: auth['provider'], uid: auth['uid'],
           email: auth['info']['email'], activated: true,
           password: random_password,
           password_confirmation: random_password)
  end

  # Activates new user
  def activate
    update_attribute(:activated, true)
  end

  def create_password_reset_token
    update_columns(password_reset_sent_at:  Time.zone.now,
                   password_reset_token:    User.new_token)
  end
  
  def password_reset_token_expired?
    password_reset_sent_at < 2.hours.ago
  end

  def send_activation_email
    UserMailer.activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private

    def downcase_email
      self.email = email.downcase
    end
    
    # Generate new token
    def generate_token(column)
      self[column] = User.new_token
    end
end
