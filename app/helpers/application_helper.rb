module ApplicationHelper
  
  def sort_by(_column, _title=nil)
    title ||= _column.titleize # ||= assigns if there's no existing value
    dir = (_column==sort_column && sort_direction=="asc") ? "desc" : "asc"
    link_to title, :sort => _column, :direction => dir
    # http://asciicasts.com/episodes/228-sortable-table-columns
  end
  
end
