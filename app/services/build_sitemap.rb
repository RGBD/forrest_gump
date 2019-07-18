class BuildSitemap
  class Error < StandardError; end

  def self.call(*args)
    new(*args).call
  end

  def initialize(records)
    @records = records.map { |x| x.slice(:id, :parent_id, :path, :name) }
  end

  def call
    @lookup = @records.map { |x| [x[:id], x] }.to_h
    @tree = { node: nil, children: {} }
    @lookup.each_value do |record|
      chain = ancestry_chain(record)
      add_full_paths(chain)
      add_full_ids(chain)
      add_to_result(chain)
    end
    arrayify_children(@tree)
  end

  def arrayify_children(tree)
    {
      node: tree[:node],
      children: tree[:children].values.map { |x| arrayify_children(x) },
    }
  end

  def add_to_result(chain)
    target = @tree
    chain.each do |node|
      target[:children][node[:id]] ||= { node: node, children: {} }
      target = target[:children][node[:id]]
    end
    chain
  end

  def ancestry_chain(record)
    result = []
    seen_ids = Set.new
    while record
      raise Error, "circular parents: id = #{record[:id]}" if record[:id].in? seen_ids

      seen_ids.add record[:id]
      result.unshift(record)
      record = @lookup[record[:parent_id]]
    end
    result
  end

  def add_full_paths(chain)
    full_path = []
    chain.each do |node|
      full_path.push node[:path] if node[:path]
      node[:full_path] = '/' + full_path.join('/')
    end
  end

  def add_full_ids(chain)
    full_path = []
    chain.each do |node|
      full_path.push node[:name].downcase.tr(' ', '_')
      node[:full_id] = full_path.join('.')
    end
  end
end
