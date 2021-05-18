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
				@records = Farmer.search_for(params[:prefecture], 'forward')
			else
				@records = Farmer.search_for(params[:name], 'partial')
			end
		end
	end
end