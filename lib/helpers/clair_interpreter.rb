module Helpers
  class Clair_interpreter

    def self.interpret(report)
      if report.include? '(High)' or report.include? '(Critical)'
        :low
      elsif report.include? '(Medium)'
        :medium
      elsif !report.include? 'No features have been detected in the image'
        :high
      else
        :unknown
      end
    end

  end

end