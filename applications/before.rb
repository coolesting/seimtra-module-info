
configure do
	set :home_page, '/info/box'
end

before '/info/*' do

	@title 			= _var(:website_title, :info)
	@keywords		= _var(:website_keywords, :info)
	@description	= _var(:website_description, :info)
	@footer			= _var(:website_footer, :info)

	@_path_of_login = '/info/login'

	#@menu = DB[:_menu].filter(:type => 'info').all
	#@top_menu = DB[:info_type].all
	@top_menu = {
		#:home 	=> '/info/box',
		#:forum => '/info/forum',
	}

end

