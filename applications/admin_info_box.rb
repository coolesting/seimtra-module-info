#display
get '/admin/info_box' do

	@rightbar += [:new, :search]
	ds = DB[:info_box]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:ibid => 'ibid', :order => 'order', :name => 'name', :description => 'description', :picture => 'picture', :link => 'link', :uid => 'uid'}
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
 	@info_box = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @info_box.page_count

	_tpl :admin_info_box

end

#new a record
get '/admin/info_box/new' do

	@title = L[:'create a new one '] + L[:'box']
	@rightbar << :save
	info_box_set_fields
	_tpl :admin_info_box_form

end

post '/admin/info_box/new' do

	info_box_set_fields
	info_box_valid_fields
	DB[:info_box].insert(@fields)
	redirect "/admin/info_box"

end

#delete the record
get '/admin/info_box/rm/:ibid' do

	_msg L[:'delete the record by id '] + params[:'ibid']
	DB[:info_box].filter(:ibid => params[:ibid].to_i).delete
	redirect "/admin/info_box"

end

#edit the record
get '/admin/info_box/edit/:ibid' do

	@title = L[:'edit the '] + L[:'box']
	@rightbar << :save
	@fields = DB[:info_box].filter(:ibid => params[:ibid]).all[0]
 	info_box_set_fields
 	_tpl :admin_info_box_form

end

post '/admin/info_box/edit/:ibid' do

	info_box_set_fields
	info_box_valid_fields
	DB[:info_box].filter(:ibid => params[:ibid]).update(@fields)
	redirect "/admin/info_box"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def info_box_set_fields
		
		default_values = {
			:order			=> 0,
			:uid			=> _user[:uid],
			:name			=> '',
			:description	=> '',
			:picture		=> '',
			:link			=> ''
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def info_box_valid_fields
		
		#_throw(L[:'the field cannot be empty '] + L[:'order']) unless @fields[:order] > 0
		
		_throw(L[:'the field cannot be empty '] + L[:'name']) if @fields[:name].strip.size < 1
		
		#_throw(L[:'the field cannot be empty '] + L[:'description']) if @fields[:description].strip.size < 1
		
		#_throw(L[:'the field cannot be empty '] + L[:'picture']) if @fields[:picture].strip.size < 1
		
		#_throw(L[:'the field cannot be empty '] + L[:'link']) if @fields[:link].strip.size < 1
		
	end

end
