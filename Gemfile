source 'https://rubygems.org'

# Specify your gem's dependencies in social_snippet-supports-github.gemspec
gemspec

group :test do
  if ::Dir.exists? "../social-snippet"
    gem "social_snippet", :path => "../social-snippet"
  else
    gem "social_snippet", :github => "social-snippet/social-snippet"
  end
end

