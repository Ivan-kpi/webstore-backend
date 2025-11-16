class Api::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    orders = current_user.orders.includes(orders_descriptions: :item)

    render json: orders.map { |order|
      format_order(order)
    }
  end

  def show
    order = current_user.orders.includes(orders_descriptions: :item).find(params[:id])

    render json: format_order(order)
  end

  def create
    # order: { items: [{ item_id: , quantity: }, ...] }
    items = params[:items]

    order = current_user.orders.create(amount: 0)

    total = 0

    items.each do |i|
      item = Item.find(i[:item_id])
      qty  = i[:quantity].to_i

      OrdersDescription.create(
        order: order,
        item: item,
        quantity: qty
      )

      total += item.price * qty
    end

    order.update(amount: total)

    render json: order, include: :items
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def format_order(order)
    {
      id: order.id,
      amount: order.amount,
      created_at: order.created_at.strftime("%d.%m.%Y %H:%M"),
      items: order.orders_descriptions.map do |od|
        {
          id: od.item.id,
          name: od.item.name,
          price: od.item.price,
          quantity: od.quantity,
          total: od.quantity * od.item.price
        }
      end
    }
  end
end
