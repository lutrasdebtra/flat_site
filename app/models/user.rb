class User < ActiveRecord::Base
  has_many :payments
  attr_accessor :login

  validates :username,
  :uniqueness => {
    :case_sensitive => false
  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

  def self.calculate_total_two_users(first_username, second_username)
    first_user = User.where(username: first_username).first
    second_user = User.where(username: second_username).first

    first_user_total = 0

    first_user.payments.each do |p|
      first_user_total += eval("p.pay#{second_user.initials}")
    end

    second_user_total = 0

    second_user.payments.each do |p|
      second_user_total += eval("p.pay#{first_user.initials}")
    end

    return first_user_total - second_user_total
  end
end
