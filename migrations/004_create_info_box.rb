Sequel.migration do
	change do
		create_table(:info_box) do
			primary_key :ibid
			Integer :box_number
			String :name
			String :description
			String :picture
			String :link
		end
	end
end
