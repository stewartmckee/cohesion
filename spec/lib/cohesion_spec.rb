require 'spec_helper'

describe Cohesion do
  before(:each) do
    @cohesion = Cohesion::Check.new
  end

  it "should be a Check class" do
    @cohesion.should be_an_instance_of Cohesion::Check
  end
  it "should run a check"

  context "site" do
    it "should crawl the site"
    it "should return error pages"
    it "should exclude urls given as external"
    it "should default to accept one level of external"
    it "should not allow one level external for excluded urls"
    it "should detect 400 level errors"
    it "should detect 500 level errors"
    it "should write valid json file"
    it "should not write to file if not requested"
    it "should start the web stats when requested"
    it "should return data when --help requested"
    it "should return help when invalid params are passed"
    it "should return help when no params are passed"
    it "should print out success links with tick"
    it "should print out failed links with cross"
    it "should print out report at end of crawl"
    it "should default to full cache"
  end

  context "rails" do
  end

  context "rake" do
  end

end
