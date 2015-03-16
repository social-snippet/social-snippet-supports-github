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
        :client_secret => GITHUB_CLIENT_SECRET,
      )
    end

    def refs
      refs_api.map {|info| info[:ref].gsub /^refs\/[a-z]+\//, "" }
    end

    def rev_hash(ref)
      rev_hash_map[ref]
    end

    private

    def rev_hash_map
      @rev_hash_map = refs_api.inject(::Hash.new) do |hash, info|
        ref = info[:ref].gsub(/^refs\/[a-z]+\//, "")
        hash[ref] = info[:object][:sha]
        hash
      end
    end

    def refs_api
      @refs_api ||= api_client.refs("#{github_owner}/#{github_repo}")
    end

    def repo
      api_client.repo(repo_name)
    end

    def repo_name
      "#{github_owner}/#{github_repo}"
    end

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

