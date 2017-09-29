module Helpers
  class GithubAccessor

    def self.get_client
      Octokit::Client.new(:access_token => "ac2028d7c63f4fc49558573c141fe889f00cd060")
    end

    def self.get_readme user_repo
      begin
        puts "REPO URL = #{user_repo}"
        client = get_client
        readme = client.readme user_repo, :accept => 'application/vnd.github.html'
        readme.gsub! 'id="user-content-', 'id="'
        readme.gsub! /href="(?!\s|#)(?!http)(?!mailto:)/, 'href="https://github.com/'+ user_repo +'/blob/master/'
        readme.gsub! /<img src="(?!http)/, '<img src="https://github.com/'+ user_repo +'/blob/master/'

      rescue Octokit::NotFound
        readme = ''
      end

      readme.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''})
    end

    def self.get_repo(repo)
      get_client.repository(repo).encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''})
    end

  end
end