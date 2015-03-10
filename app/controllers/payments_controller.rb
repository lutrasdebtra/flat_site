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
    respond_with(@payment)
  end

  def edit
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.save
    respond_with(@payment)
  end

  def update
    @payment.update(payment_params)
    respond_with(@payment)
  end

  def destroy
    @payment.destroy
    redirect_to(:back)
  end

  private
    def set_payment
      @payment = Payment.find(params[:id])
    end

    def payment_params
      params.require(:payment).permit(:date, :memo, :paysb, :payks, :paysc, :paykn)
    end
end
