class Customers::HomesController < ApplicationController
  def top
    @farmers = Farmer.order('created_at DESC').first(4)
    @recipes = Recipe.order('created_at DESC').first(4)
    @events = Event.order('created_at DESC').first(4)
  end

  def about
  end
end
