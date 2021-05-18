class SearchesController < ApplicationController

	def search
		@model = params[:model]
		if @model == 'recipe'
			@content = params[:content]
			@records = Recipe.search_for(@content)
		elsif @model == 'Tag'
			@content = params[:content]
			@records = Tag.search_for(@content)
		elsif @model == 'event'
			@content = params[:content]
			@records = Event.search_for(@content)
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