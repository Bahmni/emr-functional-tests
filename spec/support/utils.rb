class Utils

  def self.generate_random_string(length)
    (0...length).map { (65 + rand(26)).chr }.join.downcase
  end

end