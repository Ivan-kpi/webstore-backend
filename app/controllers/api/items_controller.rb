class Api::ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:create, :update, :destroy]
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    render json: Item.all
  end

  def show
    render json: @item
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    head :no_content
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end

  def check_admin
    render json: { error: "forbidden" }, status: :forbidden unless current_user.role == "admin"
  end
end


