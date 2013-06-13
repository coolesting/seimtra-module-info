Sequel.migration do
	change do
		create_table(:info_type) do
			primary_key :itid
			String :name
			Integer :order, :default => 100
		end
	end
end
