class Settings < Settingslogic
	source File.expand_path("../../config.yml", __FILE__)
	namespace ENV['TEST_ENV'] || 'development'
end

