class WindowQuery
  def query
    @query = begin
      manager
        .project(my_window_function)
        .from(other_query.table)

      manager.window('w')
        .partition(other_query.table[:donor_id])
        .order(other_query.table[:year])
        .order(other_query.table[:month])
    end
  end

  private

  def manager
    @manager ||= Arel::SelectManager.new(Arel::Table.engine)
  end
end
