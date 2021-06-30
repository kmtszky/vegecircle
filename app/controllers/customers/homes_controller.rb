class Customers::HomesController < ApplicationController
  def top
    @farmers = Farmer.where(is_deleted: false).reverse_order.first(3)
    @recipes = Recipe.all.reverse_order.first(3)
    @events = Event.where("end_date >= ?", Date.current).reverse_order.first(3)
  end

  def about
  end
end
