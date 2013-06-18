#display
get '/admin/info_product' do

	@rightbar += [:search]
	ds = DB[:info_product]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:ipid => 'ipid', :uid => 'uid', :name => 'name', :description => 'description', :picture => 'picture', }
	end

	#order
	if @qs[:order]
		if @qs.has_key? :desc
			ds = ds.reverse_order(@qs[:order].to_sym)
			@qs.delete :desc
		else
			ds = ds.order(@qs[:order].to_sym)
			@qs[:desc] = 'yes'
		end
	end

	Sequel.extension :pagination
 	@info_product = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @info_product.page_count

	_tpl :admin_info_product

end

#new a record
get '/admin/info_product/new' do

	@title = L[:'create a new one '] + L[:'info_product']
	@rightbar << :save
	info_product_set_fields
	_tpl :admin_info_product_form

end

post '/admin/info_product/new' do
	info_product_new params
	redirect "/admin/info_product"
end

#delete the record
get '/admin/info_product/rm/:ipid' do
	info_product_rm params[:ipid]
	redirect back
end

#edit the record
get '/admin/info_product/edit/:ipid' do

	@title = L[:'edit the '] + L[:'info_product']
	@rightbar << :save
	@fields = DB[:info_product].filter(:ipid => params[:ipid]).all[0]
 	info_product_set_fields
 	_tpl :admin_info_product_form

end

post '/admin/info_product/edit/:ipid' do

	info_product_set_fields
	info_product_valid_fields
	DB[:info_product].filter(:ipid => params[:ipid]).update(@fields)
	redirect "/admin/info_product"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def info_product_set_fields
		default_values = {
			:uid			=> _user[:uid],
			:name			=> '',
			:description	=> '',
			:picture		=> 1
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end
	end

	def info_product_valid_fields
		#_throw(L[:'the field cannot be empty '] + L[:'uid']) if @fields[:uid] != 0
		
		_throw(L[:'the field cannot be empty '] + L[:'description']) if @fields[:description].strip.size < 1

		_throw(L[:'the field cannot be empty '] + L[:'description']) if @fields[:description].strip.size < 1
	end

	def info_product_new field
		info_product_set_fields
		info_product_valid_fields
		@fields[:created] = Time.now

		if params[:picture] and params[:picture][:tempfile] and params[:picture][:filename]
			@fields[:picture] = _file_save params[:picture], :fid
		else
			_throw L[:'the file is null']
		end
		DB[:info_product].insert(@fields)
	end

	def info_product_rm ipid
		ds = DB[:info_product].filter(:ipid => params[:ipid].to_i)
		if ds.get(:uid) == _user[:uid] or _user[:uid] > 10
			_file_rm ds.get(:picture)
			ds.delete
		end
	end

end
