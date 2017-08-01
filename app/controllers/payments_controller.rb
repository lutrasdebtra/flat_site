class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @payments = Payment.all

    # Get inter-user totals, better than hardcoding.
    @user_payments = Hash.new

    User.all.each do |u|
      user_payment_hash = Hash.new
      User.other_users(u).each do |u_other|
        user_payment_hash[u_other.username] = User.calculate_total_two_users(u.username, u_other.username)
      end
      # Add user totals.
      val_array = user_payment_hash.values
      user_payment_hash['Total'] = val_array.inject { |sum, x| sum + x }
      # Add hash to main hash
      @user_payments[u.username] = user_payment_hash
    end

    respond_with(@payments)
  end

  def show
    respond_with(@payment)
  end

  def new
    @payment = Payment.new
    @payment.date = Time.now.strftime('%Y-%m-%d')
    User.other_users(current_user).each do |u|
      @payment["pay#{u.initials}"] = 0.to_f
    end
    respond_with(@payment)
  end

  def edit
  end

  def create
    @payment = Payment.new(payment_params)
    @payment["pay#{current_user.initials}"] = 0.to_f
    @payment.user_id = current_user.id
    respond_to do |format|
      if @payment.save
        payment_push("create")
        format.html { redirect_to current_user, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @payment.update(payment_params)
        payment_push("update")
        format.html { redirect_to current_user, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_push(type)
    if current_user.push_key
      Pushbullet.set_access_token(current_user.push_key)
      User.other_users(current_user).each do |u|
        if u.push_key == nil
          next
        end
        if @payment["pay#{u.initials}"] > 0.0
          if type == "create"
            Pushbullet::V2::Push.note('A new payment has been created', "You owe: " + '%.2f' % @payment["pay#{u.initials}"] + ", to: " + current_user.username + ", for: " + @payment.memo, {'email' => u.email})
          else
            Pushbullet::V2::Push.note('A payment has been updated', "You owe: " + '%.2f' % @payment["pay#{u.initials}"] + ", to: " + current_user.username + ", for: " + @payment.memo + " - " + @payment.date.to_s, {'email' => u.email})
          end
        end
      end
    end
  end

  def payment_params
    params.require(:payment).permit!
  end
end
