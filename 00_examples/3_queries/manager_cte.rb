class CteQuery
  def query
    @query = begin
      manager
        .project(projection)
        .from(table_name)

      manager.with(cte)
    end
  end

  private

  def manager
    @manager ||= Arel::SelectManager.new(Arel::Table.engine)
  end
end
