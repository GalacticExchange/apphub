module Helpers
  class DockerfileParser

    require 'json'

    def initialize hash
      @path = hash[:path]
      @dockerfile_lines = hash[:lines]
      @result = Hash.new
      @result[:env] = []
      @result[:expose] = []
      @remembered_pathes = Hash.new
      @remembered_pathes['PATH'] = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
    end

    def start
      get_lines if @dockerfile_lines.nil?
      parse_lines
    end

    def write_to_file
      File.open(@path.gsub('test_dockerfiles', 'result'), 'w') do |f|
        f.puts @result
      end
    end

    def to_json
      @result.to_json
    end

    def make_code
      code = ''
      code << %Q(--change "WORKDIR #{@result[:workdir]}" ) unless @result[:workdir].nil?
      code << %Q(--change "CMD #{@result[:cmd]}" ) unless @result[:cmd].nil?
      code << %Q(--change "ENTRYPOINT #{@result[:entrypoint]}" ) unless @result[:entrypoint].nil?
      unless @result[:expose].nil? or @result[:expose].empty?
        code << "--change \"EXPOSE "
        @result[:expose].each do |entry|
          code << "#{entry} "
        end
        code << "\" "
      end
      unless @result[:env].nil? or @result[:env].empty?
        code << "--change \"ENV "
        @result[:env].each do |entry|
          code << "#{entry} "
        end
        code << "\" "
      end
      code
    end

    def get_lines
      if @path.start_with? 'https://'
        uri = URI @path
        dockerfile = Net::HTTP.get uri
        @dockerfile_lines = dockerfile.split "\n"
      else
        @dockerfile_lines = File.readlines @path
      end
    end

    def parse_lines
      tmp_line = ''
      lines = @dockerfile_lines.clone
      @end_with_slash = false
      @where_to_write = nil
      buffer = ''
      lines.each do |line|
        line.strip!
        DockerfileParser.strip_string line
        if @end_with_slash
          @result[@where_to_write.to_sym] << prepare_line(line.clone)
          unless line.end_with? '\\'
            @end_with_slash = false
            @where_to_write = nil
          end
        end
        if line.start_with? 'WORKDIR'
          tmp_line = prepare_line line.clone
          @result[:workdir] = tmp_line
        end
        if line.start_with? 'ENV'
          tmp_line = prepare_line line.clone
          @result[:env] << tmp_line
        end
        if line.start_with? 'CMD'
          tmp_line = prepare_line line.clone
          @result[:cmd] = tmp_line
        end
        if line.start_with? 'ENTRYPOINT'
          tmp_line = prepare_line line.clone
          @result[:entrypoint] = tmp_line
        end
        if line.start_with? 'EXPOSE'
          tmp_line = prepare_line line.clone
          if tmp_line.include? ' '
            tmp_line = tmp_line.split ' '
            tmp_line.each do |expose_line|
              @result[:expose] << expose_line
            end
          else
            @result[:expose] << tmp_line
          end

        end
      end
      tmp_env = []
      @result[:env].each do |entry|
        if entry.include? ' ' and entry.include? '='  and entry.scan(/[A-Z\d]=/).size >= 2
          new_array = entry.split(' ')
          new_array.each do |new_entry|
            tmp_env << new_entry
          end
        else
          tmp_env << entry.gsub(' ', '=')
        end
      end
      @result[:env] = tmp_env
      repair_options_first
      repair_options_second
    end

    def convert_env_variable(string)
      # puts string
      result = []
      if string.include? '='
        result << string[0..string.index('=')-1]
        result << string[string.index('=')+1..string.length]
      else
        result << 'GEX_ERROR'
        result << string
      end
      result
    end

    def prepare_line(line)
      if line.end_with? '\\' and @where_to_write.nil?
        @where_to_write = line.split(' ').first.downcase.to_sym
        @end_with_slash = true
      end
      line.gsub! /(ENTRYPOINT)|(WORKDIR)|(ENV)|(CMD)|(EXPOSE)|(\\)/, ''
      line.gsub! /[",\[\]]/, ''
      line.strip!
      line
    end

    def self.strip_string string
      string.gsub! /\A\s*/, ''
      string.gsub! /\s*\z/, ''
      string.gsub! /\s{2,}/, ' '
    end

    def repair_options_second
      new_env = []
      @result[:env].each do |entry|
        if entry.include? '$'
          variables = entry.scan /(\$\w*)/
          variables.each do |var|
            begin
              entry.gsub! var.first, @remembered_pathes[var.first.gsub '$', ''] unless var.first.eql? '$PYTHONPATH'
            rescue
              # puts 'omg'
            end
          end
        end
        result =  convert_env_variable entry
        @remembered_pathes[result.first] = result.last
        new_env << entry
      end
      @result[:env] = new_env

      new_expose = []
      @result[:expose].each do |entry|
        if entry.include? '$'
          variables = entry.scan /(\$\w*)/
          variables.each do |var|
            entry.gsub! var.first, @remembered_pathes[var.first.gsub '$', '']
          end
        end
        new_expose << entry
      end
      @result[:expose] = new_expose

      unless @result[:cmd].nil?
        new_cmd = ''
        entry = @result[:cmd]
        if entry.include? '$'
          variables = entry.scan /(\$\w*)/
          variables.each do |var|
            entry.gsub! var.first, @remembered_pathes[var.first.gsub '$', '']
          end
        end
        new_cmd << entry.first

        @result[:cmd] = new_cmd
      end

      unless @result[:entrypoint].nil?
        new_entrypoint = ''
        entry = @result[:entrypoint]
        if entry.include? '$'
          variables = entry.scan /(\$\w*)/
          variables.each do |var|
            entry.gsub! var.first, @remembered_pathes[var.first.gsub '$', '']
          end
        end
        new_entrypoint << entry
        @result[:entrypoint] = new_entrypoint
      end

      unless @result[:workdir].nil?
        new_workdir = ''
        entry = @result[:workdir]
        if entry.include? '$'
          new_cmd = []
          variables = entry.scan /(\$\w*)/
          variables.each do |var|
            begin
              entry.gsub! var.first, @remembered_pathes[var.first.gsub '$', '']
            rescue
              # puts 'ALO'
            end
          end
        end
        new_workdir << entry
        @result[:workdir] = new_workdir
      end


      @remembered_pathes
      new_cmd = []
    end

    def repair_options_first

      @result[:env].each do |entry|
        variables = entry.scan(/\${(\w*)}/)
        if variables.any?
          variables.each do |var|
            begin
              entry.gsub! "${#{var.first}}", @remembered_pathes[var.first]
            rescue
              puts "${#{var.first}}"
              puts @remembered_pathes[var.first]
            end
          end
        end
        result =  convert_env_variable entry
        @remembered_pathes[result.first] = result.last
      end
      new_cmd = []


      @result[:expose].each do |entry|
        variables = entry.scan(/\${(\w*)}/)
        if variables.any?
          variables.each do |var|
            entry.gsub! "${#{var.first}}", @remembered_pathes[var.first]
          end
        end
      end


      unless @result[:cmd].nil?
        new_cmd = []
        entry = @result[:cmd]
        variables = entry.scan(/\${(\w*)}/)
        if variables.any?
          variables.each do |var|
            begin
              entry.gsub! "${#{var.first}}", @remembered_pathes[var.first]
            rescue
              # puts 'eh?'
            end
          end
        end
        new_cmd << entry

        @result[:cmd] = new_cmd
      end

      unless @result[:entrypoint].nil?
        new_entrypoint = ''
        entry = @result[:entrypoint]
        variables = entry.scan(/\${(\w*)}/)
        if variables.any?
          variables.each do |var|
            entry.gsub! "${#{var.first}}", @remembered_pathes[var.first]
          end
        end
        new_entrypoint << entry
        @result[:entrypoint] = new_entrypoint
      end

      unless @result[:workdir].nil?
        new_workdir = ''
        entry = @result[:workdir]
        variables = entry.scan(/\${(\w*)}/)
        if variables.any?
          variables.each do |var|
            entry.gsub! "${#{var.first}}", @remembered_pathes[var.first]
          end
        end
        new_workdir << entry
        @result[:workdir] = new_workdir
      end


    end
  end

end
