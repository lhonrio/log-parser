require 'rails_helper'

RSpec.describe LogsController, type: :controller do
  describe "POST #analyze" do
    context "with a valid log file" do
      let(:valid_file) { fixture_file_upload('./spec/fixtures/logs/valid.log', 'text/plain') }

      it "returns a successful response" do
        post :analyze, params: { file: valid_file }
        expect(response).to have_http_status(:success)
      end

      it "returns the analyzed reports in JSON format" do
        post :analyze, params: { file: valid_file }
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with an invalid log file" do
      let(:invalid_file) { './spec/fixtures/logs/invalid.jpg' }
      

      it "returns an unprocessable entity response" do
        post :analyze, params: { file: invalid_file }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error message in JSON format" do
        post :analyze, params: { file: invalid_file }
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end
end
