namespace :user_changes do
  desc "Adds User and creates correct DB entries."
  task add_user: :environment do
    username = ENV['username'].to_s
    email = ENV['email'].to_s
    password = ENV['password'].to_s
    initials = ENV['initials'].to_s
    if username and email and password and initials
      User.create! :username => username, :email => email, :password => password, :password_confirmation => password, :initials => initials

      files = Dir.glob Rails.root.join('db/migrate/*')

      migration_patterns = {
          /add_pay_#{initials.downcase}_to_shopping_lists/ => "rails g migration AddPay#{initials}ToShoppingLists pay#{initials}:decimal",
          /add_pay_#{initials.downcase}_to_payments/ => "rails g migration AddPay#{initials}ToPayments pay#{initials}:decimal"
      }

      migration_patterns.each do |file_pattern, migration_command|
        if files.none? { |file| file =~ file_pattern }
          sh migration_command
        end
      end

      Rake::Task['db:migrate'].invoke
    end
  end

  desc "Removes User and deletes correct DB entries."
  task remove_user: :environment do
    username = ENV['username'].to_s
    if username
      user = User.where(:username => username).first
      if user
        initials = user.initials
        User.delete(user.id)
        files = Dir.glob Rails.root.join('db/migrate/*')

        migration_patterns = {
            /remove_pay_#{initials.downcase}_from_shopping_lists/ => "rails g migration RemovePay#{initials}FromShoppingLists",
            /remove_pay_#{initials.downcase}_from_payments/ => "rails g migration RemovePay#{initials}FromPayments"
        }

        migration_patterns.each do |file_pattern, migration_command|
          if files.none? { |file| file =~ file_pattern }
            sh migration_command
          end
        end

        Rake::Task['db:migrate'].invoke
      end
    end
  end
end