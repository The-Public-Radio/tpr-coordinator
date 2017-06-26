require "rails_helper"

RSpec.describe RadiosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/radios").to route_to("radios#index")
    end


    it "routes to #show" do
      expect(:get => "/radios/1").to route_to("radios#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/radios").to route_to("radios#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/radios/1").to route_to("radios#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/radios/1").to route_to("radios#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/radios/1").to route_to("radios#destroy", :id => "1")
    end

  end
end
