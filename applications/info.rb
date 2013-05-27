#new a record
get '/info/new' do
	_login? '/info/login'
	@title = L[:'Create a new information']
	info_set_fields
	_tpl :info_form
end

post '/info/new' do
	info_set_fields
	info_valid_fields
	@fields[:changed] = Time.now
	DB[:info].insert(@fields)
	_msg L[:'public complete']
	redirect back
end

#the result of info for searching
get '/info/result' do
	@result = []
	@result = info_search params[:sc] if params[:sc] and params[:sc].strip.size > 0
	_tpl :info_result
end

#show a record of info
get '/info/view/:iid' do
	ds = DB[:info].filter(:iid => params[:iid]) if params[:iid]
	@info = ds.first ? ds.first : {}
	_tpl :info_view
end

#show the records by info_type
get '/info/type/:itid' do
	@info = DB[:info].filter(:itid => params[:itid])
	_tpl :info_list
end

helpers do
	
	def info_search condition
		result = []
		kw_ds = DB[:info_kw].filter(:key => condition)
		curtime = Time.now.strftime("%Y%m%d%H%M").to_i
		timeout = 30

		#get the content of db by keyword value as the condition 
		if kw_ds.get(:value) and (curtime - kw_ds.get(:changed).strftime("%Y%m%d%H%M").to_i) < timeout
			if kw_ds.get(:value).index ","
				result = DB[:info].where(:itid => kw_ds.get(:value).split(','))
			else
				result = DB[:info].filter(:itid => kw_ds.get(:value).to_i).all
			end

		#if no keyword, or timeout, get the content and save the keyword, 
		#then mark the record which has been searched it
		else
# 			@result = DB[:info].full_text_search([:title, :body], condition)
			result = DB[:info].where(Sequel.like(:title, "%#{condition}%"))

			#save keyword if the content exists
			keyword = []
			unless result.empty?
				#index value of table that has been searched
				keyword = result.map(:itid).join(',')

				mark = DB[:info].max(:itid)

				#save the keyword info
				DB[:info_kw].insert(:key => condition, :value => keyword, :changed => Time.now, :mark => mark)
			end
		end

		result
	end

end

