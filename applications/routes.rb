
get '/admin/info' do
	_tpl :_default
end

get '/info/s' do
	@home_menu = {
		:info => '/info/type/1',
#		:news => '/info/news',
		:public => '/info/new'
	}
	_tpl :info_search, :layout
end

get '/info/login' do
	_tpl :info_login
end

get '/info/box' do
	_tpl :info_box
end


# get '/info/news' do
# 
# 	require 'nokogiri'
# 	require 'open-uri'
# 
# 	@news = {}
# 
# 	path = 'http://www.zc173.com'
# 	doc = Nokogiri::HTML(open(path))
# 	doc.css('#frameAUaxju a').map { | link |
# 		@news[link.text] = link['href']
# 	}
# 
# 	_tpl :info_news
# 
# end
# 
