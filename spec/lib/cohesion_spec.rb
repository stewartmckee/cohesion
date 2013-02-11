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
  end

  context "rails" do
  end

  context "rake" do
  end

end
