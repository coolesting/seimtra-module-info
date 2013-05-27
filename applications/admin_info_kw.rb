#display
get '/admin/info_kw' do

	@rightbar += [:new, :search]
	ds = DB[:info_kw]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:ikid => 'ikid', :itid => 'itid', :key => 'key', :value => 'value', :changed => 'changed', }
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
 	@info_kw = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @info_kw.page_count

	_tpl :admin_info_kw

end

#new a record
get '/admin/info_kw/new' do

	@title = L[:'create a new one '] + L[:'info_kw']
	@rightbar << :save
	info_kw_set_fields
	_tpl :admin_info_kw_form

end

post '/admin/info_kw/new' do

	info_kw_set_fields
	info_kw_valid_fields
	
	@fields[:changed] = Time.now
	
	DB[:info_kw].insert(@fields)
	redirect "/admin/info_kw"

end

#delete the record
get '/admin/info_kw/rm/:ikid' do

	_msg L[:'delete the record by id '] + params[:'ikid']
	DB[:info_kw].filter(:ikid => params[:ikid].to_i).delete
	redirect "/admin/info_kw"

end

#edit the record
get '/admin/info_kw/edit/:ikid' do

	@title = L[:'edit the '] + L[:'info_kw']
	@rightbar << :save
	@fields = DB[:info_kw].filter(:ikid => params[:ikid]).all[0]
 	info_kw_set_fields
 	_tpl :admin_info_kw_form

end

post '/admin/info_kw/edit/:ikid' do

	info_kw_set_fields
	info_kw_valid_fields
	@fields[:changed] = Time.now
	
	DB[:info_kw].filter(:ikid => params[:ikid]).update(@fields)
	redirect "/admin/info_kw"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def info_kw_set_fields
		
		default_values = {
			:itid		=> 1,
			:key		=> '',
			:value		=> ''
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def info_kw_valid_fields
		
		#_throw(L[:'the field cannot be empty '] + L[:'itid']) if @fields[:itid] != 0
		
		_throw(L[:'the field cannot be empty '] + L[:'key']) if @fields[:key].strip.size < 1
		
		_throw(L[:'the field cannot be empty '] + L[:'value']) if @fields[:value].strip.size < 1
		
	end

end
