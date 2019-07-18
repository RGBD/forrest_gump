/* global $ */
const renderTreeService = (() => {
  const service = {
    renderTree: (tree) => {
      if (!tree) {
        return '';
      }
      return $('<li>')
        .append(service.renderNode(tree.node))
        .append(service.renderChildren(tree.children));
    },
    renderNode: (node) => {
      if (!node) {
        return '';
      }
      return $('<a>').attr('href', node.full_path).text(node.name).attr('id', node.full_id);
    },
    renderChildren: (children) => {
      if (!children || Object.getOwnPropertyNames(children).length === 0) {
        return '';
      }
      const result = $('<ul>');
      children.forEach((tree) => { result.append(service.renderTree(tree)); });
      return result;
    },
  };
  return service;
})();

$.ajax({
  url: '/web_nodes/sitemap',
  success: (result) => {
    console.log(result);
    const childrenList = renderTreeService.renderChildren(result.children);
    $('#tree_view_target').empty().append(childrenList);
    console.log(childrenList);
  },
});
