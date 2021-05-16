class Customers::HomesController < ApplicationController
  def top
    @farmers = Farmer.where(is_deleted: false).order('created_at DESC').first(4)
    @recipes = Recipe.order('created_at DESC').first(4)
    @events = Event.where("end_date > ?", Date.today).order('created_at DESC').first(4)
  end

  def about
  end
end
