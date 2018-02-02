require 'rest-client'
require 'multi_json'

class OntolobridgeController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'main'

  def index
    render action: "index"
  end

  def term_status
    term_id = params["term_id"]
    method = params["request_method"]
    response = {"term_id" => term_id, "method" => method}
    endpoint = "/TermStatus"

    begin
      sleep 1
      response_raw = nil

      if method.upcase == "POST"
        response_raw = RestClient.post("#{ONTOLOBRIDGE_BASE_URL}#{endpoint}", {id: term_id})
      else
        response_raw = RestClient.get("#{ONTOLOBRIDGE_BASE_URL}#{endpoint}", {params: {id: term_id}})
      end

      response.merge!(MultiJson.load(response_raw))
    rescue Exception => e
      response["error"] = "Problem querying #{endpoint}: #{e.class} - #{e.message}"
    end

    render json: response
  end

  def request_term
    sleep 1
    response = {}
    endpoint = "/RequestTerm"
    h_params = {}

    begin
      params.delete("controller")
      params.delete("action")
      params.each { |k, v|
        if v === "on"
          h_params[k] = true
        else
          h_params[k] = v
        end
      }

      response_raw = RestClient.post("#{ONTOLOBRIDGE_BASE_URL}#{endpoint}", h_params)
      response.merge!(MultiJson.load(response_raw))
    rescue Exception => e
      response["error"] = "Problem creating a new term #{endpoint}: #{e.class} - #{e.message}"
    end

    render json: response
  end
end