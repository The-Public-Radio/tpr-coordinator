require "rails_helper"

RSpec.describe OrdersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/orders").to route_to("orders#index")
    end


    it "routes to #show" do
      expect(:get => "/orders/1").to route_to("orders#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/orders").to route_to("orders#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/orders/1").to route_to("orders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/orders/1").to route_to("orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/orders/1").to route_to("orders#destroy", :id => "1")
    end

  end
end
