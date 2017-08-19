require "rails_helper"

RSpec.describe ShipmentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/shipments").to route_to("shipments#index")
    end

    it "routes to #index" do
      expect(:get => "/shipments").to route_to("shipments#index")
    end

    it "routes to #show" do
      expect(:get => "/shipments/1").to route_to("shipments#show", :id => "1")
    end

    it "routes to #next_unboxed_radio" do
      expect(:get => "/shipments/1/next_radio").to route_to("shipments#next_unboxed_radio", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/shipments").to route_to("shipments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shipments").to route_to("shipments#update")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shipments").to route_to("shipments#update")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shipments/1").to route_to("shipments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shipments/1").to route_to("shipments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shipments/1").to route_to("shipments#destroy", :id => "1")
    end

  end
end
