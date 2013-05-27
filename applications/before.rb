
configure do
	set :home_page, '/info/s'
end

before '/info/*' do

	@title = "Welcome to information system"
	#@menu = DB[:_menu].filter(:type => 'info').all
	@top_menu = DB[:info_type].all
	@sec_menu = {
		#:news => '/info/news',
		:public => '/info/new',
	}

end
