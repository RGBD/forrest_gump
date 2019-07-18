require 'rails_helper'

RSpec.describe WebNodesController, type: :controller do
  describe 'GET #sitemap' do
    it 'returns http success with empty node list' do
      WebNode.destroy_all
      get :sitemap
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq({ node: nil, children: [] }.with_indifferent_access)
    end

    it 'returns http success with single node' do
      WebNode.create(name: 'Foo', path: 'foo')
      get :sitemap
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response[:children].size).to eq(1)

      node = json_response[:children].first[:node]

      expect(node[:name]).to eq('Foo')
      expect(node[:path]).to eq('foo')
      expect(node[:full_path]).to eq('/foo')
    end

    it 'returns http success with deep_node' do
      node_foo = WebNode.create(name: 'Foo Name', path: 'foo')
      WebNode.create(name: 'Bar Name', path: 'bar', parent: node_foo)
      get :sitemap
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response[:children].size).to eq(1)

      node = json_response[:children].first[:children].first[:node]

      expect(node[:name]).to eq('Bar Name')
      expect(node[:path]).to eq('bar')
      expect(node[:full_path]).to eq('/foo/bar')
      expect(node[:full_id]).to eq('foo_name.bar_name')
    end
  end

  describe 'GET #tree_view' do
    it 'returns http success for tree view' do
      get :tree_view
      expect(response).to have_http_status(:success)
    end
  end
end
