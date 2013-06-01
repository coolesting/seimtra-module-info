
configure do
	set :home_page, '/info/box'
end

before '/info/*' do

	@title = "Welcome to information system"

	#@menu = DB[:_menu].filter(:type => 'info').all
	#@top_menu = DB[:info_type].all
	@top_menu = {
		:home 	=> '/info/box',
		#:type	=> '/info/type',
		:forum 	=> '/info/forum',
	}

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
