class SearchesController < ApplicationController

	def search
		@model = params[:model]
		if @model == 'recipe'
			@content = params[:content]
			@records = Recipe.search_for(@content)
			tags = Tag.search_for(@content)
			if tags.present?
				recipe_tags = RecipeTag.where(tag_id: tags.ids).pluck(:recipe_id)
				taged_recipes = Recipe.where(id: recipe_tags)
				sub_records = @records + taged_recipes
				sub_records_ids = sub_records.pluck(:id).uniq
				@records = Recipe.where(id: sub_records_ids)
			end
		elsif @model == 'event'
			if params.has_key?(:prefecture)
				@content = params[:prefecture]
				@records = Event.search_for(@content, 'forward')
			elsif params.has_key?(:event_date)
				@content = params[:event_date]
				@records = Event.search_for_date(@content, 'partial')
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
end