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

  # Calculates who owes who.
  def self.calculate_total_two_users(first_username, second_username)
    first_user = User.find_by(username: first_username)
    second_user = User.find_by(username: second_username)

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

  # Determines colour for TD cells.
  def self.td_cell_colour_class(val)
    colour = 'success'

    if val < 0.0 
      colour = 'danger'
    end
    return colour
  end

  def self.other_users(user)
    @users = [] 
    @users << User.find_by_username("Stuart")
    @users << User.find_by_username("Katy")
    @users << User.find_by_username("Simon")
    @users << User.find_by_username("Kieran")
    return @other_users = @users.reject {|x| x.username == user.username}
  end
end
