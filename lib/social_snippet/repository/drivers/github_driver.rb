module SocialSnippet::Repository::Drivers

  GITHUB_CLIENT_ID      = ENV["SOCIAL_SNIPPET_GITHUB_CLIENT_ID"]
  GITHUB_CLIENT_SECRET  = ENV["SOCIAL_SNIPPET_GITHUB_CLIENT_SECRET"]

  class GitHubDriver < DriverBase

    attr_reader :api_client
    attr_reader :github_owner
    attr_reader :github_repo

    def fetch
      @github_owner ||= parse_github_owner
      @github_repo ||= parse_github_repo
      @api_client ||= ::Octokit::Client.new(
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

    def each_file(ref, &block)
      files(ref).each &block
    end

    def each_directory(ref, &block)
      directories(ref).each &block
    end

    private

    def rev_hash_map
      @rev_hash_map ||= refs_api.inject(::Hash.new) do |hash, info|
        ref = info[:ref].gsub(/^refs\/[a-z]+\//, "")
        hash[ref] = info[:object][:sha]
        hash
      end
    end

    def refs_api
      @refs_api ||= api_client.refs("#{github_owner}/#{github_repo}")
    end

    def repo
      @repo ||= api_client.repo(repo_name)
    end

    def files(ref)
      tree(ref).select do |item|
        item.type === "blob"
      end.map do |item|
        Entry.new item.path, blob(item.sha)
      end
    end

    def blob(hash)
      blob = api_client.blob(repo_name, hash)
      if blob.encoding === "base64"
        ::Base64.decode64(blob.content)
      elsif blob.encoding === "utf-8"
        blob.content
      end
    end

    def directories(ref)
      tree(ref).select do |item|
        item.type === "tree"
      end.map do |item|
        Entry.new item.path, nil
      end
    end

    def tree(ref)
      tree_hash = rev_hash(ref)
      res = api_client.tree(repo_name, tree_hash, :recursive => true)
      res[:tree]
    end

    def repo_name
      @repo_name ||= "#{github_owner}/#{github_repo}"
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

