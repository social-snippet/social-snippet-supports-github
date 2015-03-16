require "spec_helper"

describe ::SocialSnippet::Repository::Drivers::GitHubDriver do

  let(:driver_class) { ::SocialSnippet::Repository::Drivers::GitHubDriver }

  include_context :TestDriver

  context "url = git://github.com/social-snippet/example-repo.git", :current => true do
    let(:repo_url) { "git://github.com/social-snippet/example-repo.git" }
    let(:driver) { ::SocialSnippet::Repository::Drivers::GitHubDriver.new repo_url }
    context "parse_github_owner" do
      subject { driver.send :parse_github_owner }
      it { should eq "social-snippet" }
    end
    context "parse_github_repo" do
      subject { driver.send :parse_github_repo }
      it { should eq "example-repo" }
    end
  end

end

