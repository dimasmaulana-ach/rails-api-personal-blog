class CreateSlug

    def self.generate_slug(payload)
        payload.gsub(' ', '-')
    end

end