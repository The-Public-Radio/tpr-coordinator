require "rails_helper"

RSpec.describe RadiosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/shipments/1/radios").to route_to(:controller => "radios", :action => "index", shipment_id: "1" )
    end

    it "routes to #show" do
      expect(:get => "/shipments/1/radios/1").to route_to("radios#show", :id => "1", shipment_id: "1")
    end


    it "routes to #create" do
      expect(:post => "/shipments/1/radios").to route_to("radios#create", shipment_id: "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shipments/1/radios/1").to route_to("radios#update", :id => "1", shipment_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shipments/1/radios/1").to route_to("radios#update", :id => "1", shipment_id: "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shipments/1/radios/1").to route_to("radios#destroy", :id => "1", shipment_id: "1")
    end

  end
end
