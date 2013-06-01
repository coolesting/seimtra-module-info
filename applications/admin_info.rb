#display
get '/admin/infos' do

	@rightbar += [:new, :search]
	ds = DB[:info]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:iid => 'iid', :uid => 'uid', :title => 'title', :body => 'body', :itid => 'name', :changed => 'changed', }
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
 	@info = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @info.page_count

	_tpl :admin_infos

end

#new a record
get '/admin/info/new' do

	@title = L[:'create a new one '] + L[:'info']
	@rightbar << :save
	info_set_fields
	_tpl :admin_info_form

end

post '/admin/info/new' do

	info_set_fields
	info_valid_fields
	
	@fields[:changed] = Time.now
	
	DB[:info].insert(@fields)
	redirect "/admin/info"

end

#delete the record
get '/admin/info/rm/:iid' do

	_msg L[:'delete the record by id '] + params[:'iid']
	DB[:info].filter(:iid => params[:iid].to_i).delete
	redirect "/admin/info"

end

#edit the record
get '/admin/info/edit/:iid' do

	@title = L[:'edit the '] + L[:'info']
	@rightbar << :save
	@fields = DB[:info].filter(:iid => params[:iid]).all[0]
 	info_set_fields
 	_tpl :admin_info_form

end

post '/admin/info/edit/:iid' do

	info_set_fields
	info_valid_fields
	@fields[:changed] = Time.now
	
	DB[:info].filter(:iid => params[:iid]).update(@fields)
	redirect "/admin/info"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def info_set_fields
		
		default_values = {
			:uid		=> _user[:uid],
			:title		=> '',
			:body		=> '',
			:itid		=> 1
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def info_valid_fields
		
		#_throw(L[:'the field cannot be empty '] + L[:'uid']) if @fields[:uid] != 0
		
		_throw(L[:'the field cannot be empty '] + L[:'title']) if @fields[:title].strip.size < 1
		
		_throw(L[:'the field cannot be empty '] + L[:'body']) if @fields[:body].strip.size < 1
		
		field = _kv :info_type, :itid, :name
					
		_throw(L[:'the field does not exist '] + L[:'itid']) unless field.include? @fields[:itid].to_i
	end

end
