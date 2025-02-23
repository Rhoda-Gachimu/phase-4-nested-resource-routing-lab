class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end
  def show
    item = Item.find(params[:id])
    render json: item
  end

  def create
    item = Item.new(item_params)
    item.user_id = params[:user_id]
    item.save
    render json: item, status: :created
  end

  private

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end
end
