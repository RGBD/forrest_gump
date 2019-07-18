class WebNodesController < ApplicationController
  def sitemap
    sitemap = BuildSitemap.call(WebNode.all)
    render json: sitemap
  end

  def tree_view; end
end
