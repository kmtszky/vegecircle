class SearchesController < ApplicationController

	def search
		@model = params[:model]
		case @model
		when 'recipe' then
			@content = params[:content]
			@records = Recipe.title_like(@content)
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
		when 'event' then
			if params.has_key?(:prefecture)
				@content = params[:prefecture]
				@records = Event.search_for(@content, 'forward').where('end_date >= ?', Date.current)
			elsif params.has_key?(:event_date)
				@content = params[:event_date]
				if farmer_signed_in?
					@records = current_farmer.events.search_for(@content, 'date')
				else
					@records = Event.search_for(@content, 'date').where('end_date >= ?', Date.current)
				end
			else
				@content = params[:content]
				if farmer_signed_in?
					@records = current_farmer.events.search_for(@content, 'partial')
				else
					@records = Event.search_for(@content, 'partial').where('end_date >= ?', Date.current)
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
		case @model
		when 'recipe'
			if farmer_signed_in?
				@records = current_farmer.recipes.sorts(@method)
			else
				@records = Recipe.sorts(@method)
			end
		when 'event'
			if farmer_signed_in?
				@records = current_farmer.events.sorts(@method)
			else
				@records = Event.sorts(@method).where('end_date >= ?', Date.current)
			end
		else
			@records = Farmer.sorts(@method)
		end
	end
end