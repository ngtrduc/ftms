class Admin::LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    add_breadcrumb_index "locations"
  end
end
