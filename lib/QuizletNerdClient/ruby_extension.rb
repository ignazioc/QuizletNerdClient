class Hash
	def filter(keys)
		self.select { |k, _v| keys.include?(k) }
	end
end