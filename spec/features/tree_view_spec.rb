require 'rails_helper'

RSpec.describe 'tree_view', type: :feature do
  describe 'ajax tree render', js: true do
    let(:target_selector) { '#tree_view_target' }

    def find_parent(node)
      node.find(:xpath, './..', visible: false)
    end

    def ancestry(node, size)
      result = []
      size.times do
        result.unshift(node)
        node = find_parent(node)
      end
      result
    end

    it 'renders empty tree' do
      # node_a = WebNode.create(name: 'Name A', path: 'path_a')
      visit '/web_nodes/tree_view'
      target = page.find(target_selector, visible: false)
      expect(target.text).to be_empty
    end

    it 'renders tree' do
      node_a = WebNode.create(name: 'Name A', path: 'path_a')
      node_b = WebNode.create(name: 'Name B', path: 'path_b', parent: node_a)

      visit '/web_nodes/tree_view'

      dom_b = page.find_by_id('name_a.name_b')
      expect(dom_b.text).to eq(node_b.name)
      uri = URI(dom_b[:href])
      expect(uri.path).to eq('/path_a/path_b')

      parent_tags = ancestry(dom_b, 6).map(&:tag_name)
      expect(parent_tags).to eq(%w[div ul li ul li a]) # proper nesting
    end
  end
end
