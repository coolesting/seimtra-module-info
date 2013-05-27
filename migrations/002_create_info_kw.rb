Sequel.migration do
	change do
		create_table(:info_kw) do
			primary_key :ikid
			Integer :itid, :default => 0
			String :key
			String :value
			Datetime :changed
		end
	end
end
