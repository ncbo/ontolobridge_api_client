require 'test_helper'

class OntolobridgeControllerTest < ActionDispatch::IntegrationTest

  test "term status retrieval" do
    params = { term_id: 4, request_method: "post" }
    post "/term_status", params: params
    assert_response :success
    params[:request_method] = "get"
    post "/term_status", params: params
    assert_response :success
  end

  test "term creation" do
    params = { label: "Test Class 11", description: "Unit test dedicated class", superclass: "http://dev3.ccs.miami.edu:8080/ontolobridge#ONTB_000000008" }
    post "/request_term", params: params
    assert_response :success
  end

end
