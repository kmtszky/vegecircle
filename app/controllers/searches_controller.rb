class SearchesController < ApplicationController
  skip_before_action :set_prefectures

	def search
		@model = params[:model]
		case @model
		when 'recipe' then
			@content = params[:content]
			tags = Tag.tag_like(@content)
			if tags.present?
				@records = Recipe.search_for(@content, tags)
			else
				@records = Recipe.title_like(@content)
			end
			@records = @records.where(farmer_id: current_farmer.id) if farmer_signed_in?
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