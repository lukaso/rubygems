# frozen_string_literal: true

require "spec_helper"

RSpec.describe "bundle install with a gemfile that overrides the ruby version" do
  it "works" do
    build_repo4 do
      build_gem "rack", "9001.0.0" do |s|
        s.required_ruby_version = "> 9000"
      end
    end

    install_gemfile <<-G
      ruby "#{RUBY_VERSION}"
      source "#{file_uri_for(gem_repo4)}"
      gem 'rack', :override_ruby_version => true
    G

    expect(out).to_not include("rack-9001.0.0 requires ruby version > 9000")
    expect(out).to include("[ruby version overridden]")
    expect(the_bundle).to include_gems("rack 9001.0.0")
  end
end

RSpec.describe "bundle install with a gemfile that overrides the rubygems version" do
  it "works" do
    build_repo4 do
      build_gem "rack", "9001.0.0" do |s|
        s.required_rubygems_version = "> 9000"
      end
    end

    install_gemfile <<-G
      source "#{file_uri_for(gem_repo4)}"

      gem 'rack', :override_rubygems_version => true
    G

    expect(out).to_not include("rack-9001.0.0 requires rubygems version > 9000")
    expect(out).to include("[rubygems version overridden]")
    expect(the_bundle).to include_gems("rack 9001.0.0")
  end
end
