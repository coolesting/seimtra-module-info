
# =========================
# 	show the product
# =========================
# display by search
get '/info/product/s' do
	@res = []
	@box = {}

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
	_tpl :info_product_view
end

#display by uid
get '/info/product/view/:uid' do
	@res = []
	@box = {}
	@page_size = 35

	#info of box
	ds = DB[:info_box].filter(:uid => params[:uid])
	unless ds.empty?
		@box = ds.first
		@title = @box[:name] + " - " +  @title
		@keywords = @box[:name]
		@description = @box[:description]
	end

	#product
	ds = DB[:info_product].filter(:uid => params[:uid])
	unless ds.empty?
		Sequel.extension :pagination
		@res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = @res.page_count
	end
	_tpl :info_product_view
end


# =========================
# 	delete the product
# =========================
get '/info/product/rm/:ipid' do
	info_product_rm params[:ipid]
	redirect back
end


# =========================
# 		user center
# =========================
# display user box and products
get '/info/user' do
	_login?
	@title = L[:'user center']
	@res = []
	uid	= _user[:uid]

	#info of box
	info_box_set_fields
	@box = @fields
	ds = DB[:info_box].filter(:uid => uid)
	@box = ds.first unless ds.empty?

	#product
	ds = DB[:info_product].filter(:uid => uid)
	unless ds.empty?
		Sequel.extension :pagination
		@res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = @res.page_count
	end

	_tpl :info_product_edit
end

# box update
post '/info/box/edit' do
	ds = DB[:info_box].filter(:uid => _user[:uid])

	#create a box
	if ds.empty?

		info_box_set_fields
		if params[:upload] and params[:upload][:tempfile] and params[:upload][:filename]
			@fields[:picture] = _file_save params[:upload], :fid
		else
			_throw L[:'the file is null']
		end
		DB[:info_box].insert(@fields)

	#update the box info
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

# =========================
# 	create a product
# =========================
# get '/info/shop/new' do
# 	_login? '/info/login'
# 	@title = L[:'Create a new product']
# 	info_product_set_fields
# 	_tpl :info_product_edit
# end


post '/info/product/new' do
	info_product_new params
	_msg L[:'public complete']
	redirect _url('/info/user')
end
