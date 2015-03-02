class Utils

  def self.generate_random_string
    (0...20).map { (65 + rand(26)).chr }.join.downcase
  end

end