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
