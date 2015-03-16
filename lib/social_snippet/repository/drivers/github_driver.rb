module SocialSnippet::Repository::Drivers

  GITHUB_CLIENT_ID      = ENV["SOCIAL_SNIPPET_GITHUB_CLIENT_ID"]
  GITHUB_CLIENT_SECRET  = ENV["SOCIAL_SNIPPET_GITHUB_CLIENT_SECRET"]

  class GitHubDriver < DriverBase

    attr_reader :api_client
    attr_reader :github_owner
    attr_reader :github_repo

    def fetch
      @github_owner = parse_github_owner
      @github_repo = parse_github_repo
      @api_client = ::Octokit::Client.new(
        :client_id => GITHUB_CLIENT_ID,
        :client_id => GITHUB_CLIENT_SECRET,
      )
    end

    def refs
      api_client.refs("#{github_owner}/#{github_repo}")
        .map {|info| info[:ref] }
        .map {|ref| ref.gsub /^refs\/[a-z]+\//, "" }
    end

    private

    def parse_github_owner
      /^\/(.+)\/.+/.match(::URI.parse(url).path)[1]
    end

    def parse_github_repo
      uri_path = ::URI.parse(url).path
      if /\.git$/ === uri_path
        /^.+\/([^\/]+)/.match(uri_path)[1].gsub /\.git$/, ""
      else
        /^.+\/([^\/]+)/.match(uri_path)[1]
      end
    end

  end

end

