Sequel.migration do
	change do
		create_table(:info_box) do
			primary_key :ibid
			Integer :order, :default => 0
			Integer :uid
			String :name
			String :description
			String :picture
			String :link
		end
	end
end
