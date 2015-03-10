class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @payments = Payment.all

    # Stuart Payments.
    @Stuart_Katy = User.calculate_total_two_users('Stuart','Katy')
    @Stuart_Simon = User.calculate_total_two_users('Stuart','Simon')
    @Stuart_Kieran = User.calculate_total_two_users('Stuart','Kieran')
    @Stuart_Total = @Stuart_Katy + @Stuart_Kieran + @Stuart_Simon

    # Katy Payments.
    @Katy_Stuart = @Stuart_Katy * -1.0
    @Katy_Simon = User.calculate_total_two_users('Katy','Simon')
    @Katy_Kieran = User.calculate_total_two_users('Katy','Kieran')
    @Katy_Total = @Katy_Stuart + @Katy_Simon + @Katy_Kieran

    # Simon Payments.
    @Simon_Stuart = @Stuart_Simon * -1.0
    @Simon_Katy = @Katy_Simon * -1.0
    @Simon_Kieran = User.calculate_total_two_users('Simon','Kieran')
    @Simon_Total = @Simon_Stuart + @Simon_Katy + @Simon_Kieran

    # Kieran Payments.
    @Kieran_Stuart = @Stuart_Kieran * -1.0
    @Kieran_Katy = @Katy_Kieran * -1.0
    @Kieran_Simon = @Simon_Kieran * -1.0
    @Kieran_Total = @Kieran_Stuart + @Kieran_Katy + @Kieran_Simon

    respond_with(@payments)
  end

  def show
    respond_with(@payment)
  end

  def new
    @payment = Payment.new
    @payment.date = Time.now.strftime('%Y-%m-%d')
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
        format.html { redirect_to current_user, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    @payment.update(payment_params)
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

    def payment_params
      params.require(:payment).permit(:user_id, :date, :memo, :paysb, :payks, :paysc, :paykn)
    end
end
