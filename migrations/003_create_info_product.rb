Sequel.migration do
	change do
		create_table(:info_product) do
			primary_key :ipid
			Integer :uid
			Integer :itid
			Integer :picture
			String :name
			String :description
			Datetime :created
		end
	end
end
