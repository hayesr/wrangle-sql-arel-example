class FirstDonationQuery
  # ...

  def month_trunc(expr)
    Arel::Nodes::NamedFunction.new(
      'date_trunc', [Arel::Nodes.build_quoted('month'), expr]
    )
  end
end
