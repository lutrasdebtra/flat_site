# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Payment.delete_all

User.create! :username => 'Stuart', :email => 'stuy.bradley@gmail.com', :password => 'topsecret', :password_confirmation => 'topsecret', :initials => 'sb'
User.create! :username => 'Simon', :email => 'simon.corkindale@rapide.co.nz', :password => 'topsecret', :password_confirmation => 'topsecret', :initials => 'sc'
User.create! :username => 'Katy', :email => 'katy.seddon@hotmail.com', :password => 'topsecret', :password_confirmation => 'topsecret', :initials => 'ks'
User.create! :username => 'Kieran', :email => 'kmaster101@gmail.com', :password => 'topsecret', :password_confirmation => 'topsecret', :initials => 'kn'


require 'csv'

# Initalise user and row variables. 
user = ''
pay_hash = {"Stuart" => -1, "Katy" => -1, "Simon" => -1, "Kieran" => -1}

i = -1 
CSV.foreach('db/seed_data.csv', {}) do |row|
  i += 1
  # Skips top of csv file.
  if i < 7
  	next
  end

  # Skip blanks.
  if row[0].nil? 
  	next
  end

  # Assigns new user.
  if row[0].to_s.include?('Payments to')
  	user_name = row[0].to_s.split.last 
  	user = User.find_by_username(user_name)
  	# Skip to next line.
 	next
  end

  # Sets row variables for current user.
  if row[0].to_s.include?('Date')
  	# Reset variables.
  	pay_hash.each do |k, v|
  	  pay_hash[k] = -1
  	end
	# Iterate row with names.
  	row[2..4].each_with_index do |l, i|
  	  # Set which rows belong to which users.
  	  # Index i needs to start at 2, and not 0.
  	  case l 
  	  when 'SB'
  	  	pay_hash["Stuart"] = i + 2
  	  when 'SC'
  	  	pay_hash["Simon"] = i + 2
  	  when 'KS'
  	  	pay_hash["Katy"] = i + 2
  	  when 'KN'
  	  	pay_hash["Kieran"] = i + 2
  	  end	
  	end
  	# Skip to next line. 
  	next
  end

  # Skip totals lines.
  if row[0].to_s.include?('TOTALS')
  	next
  end

  # Payment Line.
  date = Date.strptime(row[0].to_s, "%d/%m/%Y")
  memo = row[1].to_s

  # Set payments to 0.
  paysb = 0.0
  paysc = 0.0
  payks = 0.0
  paykn = 0.0

  # Sort pay.
  pay_hash.each do |k, v|
  	# Ignore user.
  	if k == user
  	  next 
  	else 
  	  # Extract payments.
  	  case k 
  	  when "Stuart"
  	  	paysb = row[pay_hash[k]].to_f
  	  when "Simon"
  	  	paysc = row[pay_hash[k]].to_f
  	  when "Katy"
  	  	payks = row[pay_hash[k]].to_f
  	  when "Kieran"
  	  	paykn = row[pay_hash[k]].to_f
  	  end
  	end
  end
  Payment.create! :user_id => user.id, :date => date, :memo => memo, :paysb => paysb, :paysc => paysc, :payks => payks, :paykn => paykn
end