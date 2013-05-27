Sequel.migration do
	change do
		create_table(:info) do
			primary_key :iid
			Integer :uid
			String :title
			Text :body
			Integer :itid
			Datetime :changed
		end
	end
end
