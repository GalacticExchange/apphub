module ToHash
  extend ActiveSupport::Concern

  included do
    def to_hash_with_fields(fields, url)
      return_hash = Hash.new
      fields.flatten!
      fields.each do |entry|
        if entry.eql? :link_to_self
          tmp = {entry => self.public_send(entry, url)}
        else
          tmp = {entry => self.public_send(entry)}
        end
        return_hash.merge!(tmp)
      end
      return_hash
    end
  end
end
