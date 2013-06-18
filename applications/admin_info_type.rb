#display
get '/admin/info_type' do

	@rightbar += [:new, :search]
	ds = DB[:info_type]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:itid => 'itid', :name => 'name', :order => 'order', }
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
 	@info_type = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @info_type.page_count

	_tpl :admin_info_type

end

#new a record
get '/admin/info_type/new' do

	@title = L[:'create a new one '] + L[:'info_type']
	@rightbar << :save
	info_type_set_fields
	_tpl :admin_info_type_form

end

post '/admin/info_type/new' do

	info_type_set_fields
	info_type_valid_fields
	
	
	
	DB[:info_type].insert(@fields)
	redirect "/admin/info_type"

end

#delete the record
get '/admin/info_type/rm/:itid' do

	_msg L[:'delete the record by id '] + params[:'itid']
	DB[:info_type].filter(:itid => params[:itid].to_i).delete
	redirect "/admin/info_type"

end

#edit the record
get '/admin/info_type/edit/:itid' do

	@title = L[:'edit the '] + L[:'info_type']
	@rightbar << :save
	@fields = DB[:info_type].filter(:itid => params[:itid]).all[0]
 	info_type_set_fields
 	_tpl :admin_info_type_form

end

post '/admin/info_type/edit/:itid' do

	info_type_set_fields
	info_type_valid_fields
	
	
	DB[:info_type].filter(:itid => params[:itid]).update(@fields)
	redirect "/admin/info_type"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def info_type_set_fields
		
		default_values = {
			:name		=> '',
			:order		=> 1
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def info_type_valid_fields
		
		_throw(L[:'the field cannot be empty '] + L[:'name']) if @fields[:name].strip.size < 1
		
		#_throw(L[:'the field cannot be empty '] + L[:'order']) if @fields[:order] != 0
		
	end

end
