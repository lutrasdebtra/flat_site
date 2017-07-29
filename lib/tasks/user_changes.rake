namespace :user_changes do
  desc "Adds User and creates correct DB entries."
  task add_user: :environment do
    username = ENV['username'].to_s
    email = ENV['email'].to_s
    password = ENV['password'].to_s
    initials = ENV['initials'].to_s
    if username and email and password and initials
      User.create! :username => username, :email => email, :password => password, :password_confirmation => password, :initials => initials
      Rake::Task['generate migration AddPay' + initials + 'ToShoppingLists pay' + initials + ':decimal'].invoke
      Rake::Task['generate migration AddPay' + initials + 'ToPayments pay' + initials + ':decimal'].invoke
      Rake::Task['db:migrate'].invoke
    end
  end

  desc "Removes User and deletes correct DB entries."
  task add_user: :environment do
    username = ENV['username'].to_s
    if username
      user = User.where(:username => username).first
      if user
        initials = user.initials
        User.delete(user.id)
        Rake::Task['generate migration RemovePay' + initials + 'ToShoppingLists pay' + initials + ':decimal'].invoke
        Rake::Task['generate migration RemovePay' + initials + 'ToPayments pay' + initials + ':decimal'].invoke
        Rake::Task['db:migrate'].invoke
      end

    end
  end
end