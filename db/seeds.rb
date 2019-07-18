WebNode.connection.truncate(WebNode.table_name)

datas = [
  { id: 1, parent_id: nil, path: nil, name: 'Home' },
  { id: 2, parent_id: 1, path: 'settings', name: 'Settings' },
  { id: 3, parent_id: 2, path: 'company_profile', name: 'Company Profile' },
  { id: 4, parent_id: 2, path: 'switches', name: 'Switches' },
  { id: 5, parent_id: 1, path: 'help', name: 'Help' },
  { id: 6, parent_id: 5, path: 'tickets', name: 'Tickets' },
  { id: 7, parent_id: 6, path: 'create', name: 'Create A Ticket' },
  { id: 8, parent_id: 5, path: 'faqs', name: 'FAQ' },
]

datas.each { |x| WebNode.create(x) }
