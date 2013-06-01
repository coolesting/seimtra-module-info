
get '/info/type' do
	_tpl :info_type
end

#show the records by info_type
get '/info/type/:itid' do
	@res = DB[:info].filter(:itid => params[:itid])
	_tpl :info_list
end
