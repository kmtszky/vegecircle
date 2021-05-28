class SearchesController < ApplicationController

	def search
		@model = params[:model]
		if @model == 'recipe'
			@content = params[:content]
			if farmer_signed_in?
				@records = current_farmer.recipes.search_for(@content)
			else
				@records = Recipe.search_for(@content)
			end
			tags = Tag.search_for(@content)
			if tags.present?
				recipe_tags = RecipeTag.where(tag_id: tags.ids).pluck(:recipe_id)
				taged_recipes = Recipe.where(id: recipe_tags)
				all_records = @records + taged_recipes
				deduped_records_ids = all_records.pluck(:id).uniq
				if farmer_signed_in?
					@records = current_farmer.recipes.where(id: deduped_records_ids)
				else
					@records = Recipe.where(id: deduped_records_ids)
				end
			end
		elsif @model == 'event'
			if params.has_key?(:prefecture)
				@content = params[:prefecture]
				@records = Event.search_for(@content, 'forward')
			elsif params.has_key?(:event_date)
				@content = params[:event_date]
				if farmer_signed_in?
					@records = current_farmer.events.search_all_for_date(@content)
				else
					@records = Event.search_for_date(@content)
				end
			else
				@content = params[:content]
				if farmer_signed_in?
					@records = current_farmer.events.search_all_for(@content)
				else
					@records = Event.search_for(@content, 'partial')
				end
			end
		else
			if params.has_key?(:prefecture)
				@content = params[:prefecture]
				@records = Farmer.search_for(@content, 'forward')
			else
				@content = params[:content]
				@records = Farmer.search_for(@content, 'partial')
			end
		end
	end

	def sort
		@model = params[:model]
		@method = params[:keyword]
		if farmer_signed_in?
			@farmer = current_farmer
		end
		if @model == 'recipe'
			if farmer_signed_in?
				@records = current_farmer.recipes.sorts(@method)
			else
				@records = Recipe.sorts(@method)
			end
		elsif @model == 'event'
			if farmer_signed_in?
				@records = current_farmer.events.sort_all(@method)
			else
				@records = Event.sorts(@method)
			end
		else
			@records = Farmer.sorts(@method)
		end
	end
end