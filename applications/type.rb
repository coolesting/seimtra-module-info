
get '/info/type' do
	_tpl :info_type
end

#show the records by info_type
get '/info/type/:itid' do
	@res = DB[:info].filter(:itid => params[:itid])
	_tpl :info_list
end


#show a record by id
get '/info/view/:iid' do
	ds = DB[:info].filter(:iid => params[:iid]) if params[:iid]
	@info = ds.first ? ds.first : {}
	_tpl :info_view
end

#display by uid
get '/info/user/:uid' do
	@res = {} 
	@res = DB[:info].filter(:uid => params[:uid]) if params[:uid]
	_tpl :info_list
end
