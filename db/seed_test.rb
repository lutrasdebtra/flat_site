# Seed Test
# Stuart Bradley
# 26/02/2015
#
# Feels good to write new
# code. A few dirty workarounds,
# otherwise, elegant.

require 'csv'

# Initalise user and row variables. 
user = ''
pay_hash = {"Stuart" => -1, "Katy" => -1, "Simon" => -1, "Kieran" => -1}

CSV.foreach("seed_data.csv", {}).each_with_index do |row, i|
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
  	user = row[0].to_s.split.last 
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
  	  	puts "hash " + pay_hash[k].to_s
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

  puts date
  puts memo
  puts "Stuart: " + paysb.to_s
  puts "Simon: " + paysc.to_s
  puts "Katy: " + payks.to_s
  puts "Kieran: " + paykn.to_s

  puts "--"
end
