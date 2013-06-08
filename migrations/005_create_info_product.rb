Sequel.migration do
	change do
		create_table(:info_product) do
			primary_key :ipid
			Integer :uid
			Integer :picture
			String :description
			Datetime :created
		end
	end
end
