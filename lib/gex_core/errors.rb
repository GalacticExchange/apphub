module GexCore
  class Errors
=begin
    @@errors = nil


    def self.errors
      return @@errors unless @@errors.nil?

      # load from file
      txt = File.read('data/errors.json')
      data = JSON.parse(txt, :quirks_mode => true)

      @@errors = data

    end
=end

    def self.find_by_name(name)
      #r = errors.fetch(name, nil)
      #r
      # r = Errors.where(name: name).first
      # r
    end

  end

end
