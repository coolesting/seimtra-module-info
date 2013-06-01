
#display by searching
get '/info/result' do
	@result = []
	@result = info_search params[:sc] if params[:sc] and params[:sc].strip.size > 0
	_tpl :info_result
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
