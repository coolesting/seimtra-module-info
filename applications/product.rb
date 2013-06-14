# =========================
# 	create a product
# =========================
# get '/info/shop/new' do
# 	_login? '/info/login'
# 	@title = L[:'Create a new product']
# 	info_product_set_fields
# 	_tpl :info_product_edit
# end

post '/info/shop/new' do
	info_product_new params
	_msg L[:'public complete']
	redirect _url("/info/user/#{_user[:uid]}")
end


# =========================
# 	delete the product
# =========================
get '/info/shop/rm/:ipid' do
	info_product_rm params[:ipid]
	redirect back
end


# =========================
# 	show the product
# =========================
# display by search
get '/info/shop' do
	@res = []
	@shop = {}

	if params[:sc] and params[:sc].strip.size > 0
		@title = params[:sc] + " - " +  @title
		@keywords = params[:sc]
		ds = DB[:info_product].where(Sequel.like(:description, "%#{params[:sc]}%"))
	else
		ds = DB[:info_product]
	end

	unless ds.empty?
		Sequel.extension :pagination
		@res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = @res.page_count
	end
	_tpl :info_shop
end

#display by uid
get '/info/shop/view/:uid' do
	@res = []
	@shop = {}
	@page_size = 20

	#info of shop
	ds = DB[:info_box].filter(:uid => params[:uid])
	unless ds.empty?
		@shop = ds.first
		@title = @shop[:name] + " - " +  @title
		@keywords = @shop[:name]
		@description = @shop[:description]
	end

	#product
	ds = DB[:info_product].filter(:uid => params[:uid])
	unless ds.empty?
		Sequel.extension :pagination
		@res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = @res.page_count
	end
	_tpl :info_shop
end


# =========================
# 		user center
# =========================
# display user shop and products
get '/info/user/:uid' do
	@title = L[:'user center']
	_login?
	@res = []
	info_box_set_fields
	@shop = @fields

	#info of shop
	ds = DB[:info_box].filter(:uid => params[:uid])
	@shop = ds.first unless ds.empty?

	#product
	ds = DB[:info_product].filter(:uid => params[:uid])
	@res = ds.all unless ds.empty?

	_tpl :info_product_edit
end

# shop update
post '/info/shop/edit' do
	ds = DB[:info_box].filter(:uid => _user[:uid])

	#create a shop
	if ds.empty?

		info_box_set_fields
		if params[:upload] and params[:upload][:tempfile] and params[:upload][:filename]
			@fields[:picture] = _file_save params[:upload], :fid
		else
			_throw L[:'the file is null']
		end
		DB[:info_box].insert(@fields)

	#update the shop info
	else

		fields 					= {}
		fields[:name] 			= params[:name] if params[:name] != ''
		fields[:description] 	= params[:description] if params[:description] != ''

		if params[:upload] and params[:upload][:tempfile] and params[:upload][:filename]
			fields[:picture] = _file_save params[:upload], :fid
			info_product_rm ds.get(:picture).to_i
		end

		ds.update(fields) unless fields.empty?

	end
	redirect back
end
