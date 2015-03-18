require "spec_helper"

describe ::SocialSnippet::Repository::Drivers::GitHubDriver do

  let(:driver_class) { ::SocialSnippet::Repository::Drivers::GitHubDriver }

  include_context :TestDriver

  context "handle example-repo" do
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
  end # url = example-repo

  describe ".target_url?" do
    context "target_url? git://github.com/user/repo" do
      subject { driver_class.target_url? "git://github.com/user/repo" }
      it { should be_truthy }
    end
    context "target_url? https://github.com/user/repo" do
      subject { driver_class.target_url? "https://github.com/user/repo" }
      it { should be_truthy }
    end
    context "target_url? http://github.com/user/repo" do
      subject { driver_class.target_url? "http://github.com/user/repo" }
      it { should be_truthy }
    end
    context "target_url? git://bitbucket.com/user/repo" do
      subject { driver_class.target_url? "git://bitbucket.com/user/repo" }
      it { should be_falsey }
    end
  end # .target_url?

  describe ".target_path?" do
    context "target_path? path/to/file" do
      subject { driver_class.target_path? "path/to/repo" }
      it { should be_falsey }
    end
  end # .target_path?

end

