
get '/info/box' do
	box_number = 100
	@boxs = (1..box_number).to_a
	@res = DB[:info_box].limit(box_number).to_hash :order

	_tpl :info_box
end
