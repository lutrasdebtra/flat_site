class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @shopping_lists = ShoppingList.all
    respond_with(@shopping_lists)
  end

  def show
    respond_with(@shopping_list)
  end

  def new
    @shopping_list = ShoppingList.new
    @shopping_list.date = Time.now.strftime('%Y-%m-%d')
    @shopping_list.total = 0.to_f
    User.all.each do |u|
      @shopping_list["pay#{u.initials}"] = 0.to_f
    end
    respond_with(@shopping_list)
  end

  def edit
  end

  def create
    @shopping_list = ShoppingList.new(shopping_list_params)
    @shopping_list.user_id = current_user.id

    set_amounts

    respond_to do |format|
      if @shopping_list.save
        format.html { redirect_to current_user, notice: 'Shopping List was successfully created.' }
        format.json { render :show, status: :created, location: @shopping_list }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_amounts
    respond_to do |format|
      if @shopping_list.update(shopping_list_params)
        format.html { redirect_to current_user, notice: 'Shopping List was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @shopping_list.destroy
    respond_with(@shopping_list)
  end

  private
    def set_amounts
      total = 0.0
      user_totals = Hash.new
      User.all.each do |u|
        user_totals[u.id.to_s] = 0.0
      end 
      @shopping_list.shopping_items.each do |i|
        division = 0
        i.payees.each do |p|
          if user_totals[p.to_s]
            division += 1
          end
        end 
        i.payees.each do |p|
          if user_totals[p.to_s]
            user_totals[p.to_s] += i.price / division
          end
        end 
        total += i.price
      end
      @shopping_list.total = total
      user_totals.each do |k, i|
        initials = User.where(:id => k).first.initials
        @shopping_list["pay#{initials}"] = i
      end
    end

    def set_shopping_list
      @shopping_list = ShoppingList.find(params[:id])
    end

    def shopping_list_params
      params.require(:shopping_list).permit(:_destroy, :id, :name, :date, :user_id, shopping_items_attributes: [:_destroy, :id, :memo, :price, :date, :shopping_list_id, :payees => []])
    end
end
