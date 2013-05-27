Sequel.migration do
	change do
		create_table(:info) do
			primary_key :iid
			Integer :uid
			Integer :itid
			String :title
			Text :body
			Datetime :changed
		end
	end
end
