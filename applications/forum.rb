#post list

before do
	@_path[:cms_route] = '/info/forum'
end

get '/info/forum' do
	ctid = @qs.include?(:ctid) ? @qs[:ctid] : 1
	cms_get_posts ctid
end

get '/info/forum/view/:ctid/:cpid/:title' do
	cms_get_post params[:cpid]
end

get '/info/forum/edit' do
	cms_edit
end

