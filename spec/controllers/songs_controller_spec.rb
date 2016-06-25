require 'spec_helper'
require 'rails_helper'

describe SongsController, "#index" do
  it "returns a successful response" do
    get :search

    expect(response.status).to eq(200)
  end
end
