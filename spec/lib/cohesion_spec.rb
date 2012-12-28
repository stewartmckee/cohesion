require 'spec_helper'
require 'rake'

describe Cohesion do
  before(:each) do
    @cohesion = Cohesion::Check.new
  end

  it "should be a Check class" do
    @cohesion.should be_an_instance_of Cohesion::Check
  end

  it "should run a check" do

    Rake::Task['check'].invoke
  end

end
