require 'json'

class ClairReportConverter

  attr_accessor :result_hash

  def initialize(report_lines)
    split_report(report_lines)
    @result_hash = {
        counter: {total: 0, critical: 0, high: 0, medium: 0, low: 0, negligible: 0},
        vulnerabilities: []
    }
  end

  def split_report(report_lines)
    @vulnerabilities = []
    buffer = []
    skip = false
    report_lines.each do |line|
      if skip
        skip = false
        next
      end
      line.strip!
      if line.start_with?('Layer:')
        @vulnerabilities << buffer
        buffer = []
        skip = true
        next
      end
      buffer << line
    end
  end

  def convert_vulnerability(vulnerability)
    # puts vulnerability
    # sleep(1)
    hash = {}
    type = vulnerability[0][/\((\w+)\)/].gsub(/[\( \)]/,'').downcase
    hash[:type] = type
    hash[:name] = vulnerability[0][/[\w\-\:]+/]
    vulnerability.delete_at(0)
    hash[:text] = ''
    remember_index = 0
    vulnerability.each_with_index do |line, index|
      if line.empty?
        remember_index = index+1
        break
      end
      hash[:text] << line + ' '
    end
    vulnerability[remember_index..vulnerability.length-1].each do |line|
      if line.start_with? 'Package:'
        hash[:package] = line.gsub(/Package:\s+/,'')
        next
      end
      if line.start_with? 'Link:'
        hash[:link] = line.gsub(/Link:\s+/,'')
        next
      end
      if line.start_with? 'Fixed version:'
        hash[:fixed_version] = line.gsub(/Fixed version:\s+/,'')
        next
      end
    end
    hash[:text].strip!
    add_vulnerability(hash, type)
  end

  def add_vulnerability(vulnerability, type)
    type = type.to_sym
    @result_hash[:counter][type] += 1
    @result_hash[:vulnerabilities] << vulnerability
    @result_hash[:counter][:total] += 1
    #   puts vulnerability
    #   puts
    #   puts @result_hash
    #   puts
  end

  def get_hash
    @vulnerabilities.each do |vul|
      convert_vulnerability(vul)
    end
    @result_hash[:vulnerabilities].sort! {|a,b|
      case a[:type]
        when 'critical'
          b[:type] == 'critical' ? 0 : -1
        when 'high'
          case b[:type]
            when 'critical'
              1
            when 'high'
              0
            else
              -1
          end
        when 'medium'
          case b[:type]
            when 'critical'
              1
            when 'high'
              1
            when 'medium'
              0
            else
              -1
          end
        when 'low'
          case b[:type]
            when 'critical'
              1
            when 'high'
              1
            when 'medium'
              1
            when 'low'
              0
            else
              -1
          end
        when 'negligible'
          b[:type] == 'negligible' ? 0 : 1
      end
    }
    @result_hash
  end

  def self.convert(report)
    return Hash.new.to_json if report.nil? or report.include? 'Success! No vulnerabilities were detected in your image' or \
      report.include? 'No features have been detected in the image.'
    converter = ClairReportConverter.new(report.gsub(/Clair report for image.*$/, '')[1..-1].split("\n"))
    converter.get_hash.to_json
  end
end