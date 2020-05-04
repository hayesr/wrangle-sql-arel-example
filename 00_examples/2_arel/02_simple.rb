# ActiveRecord
User.where("created_at < ?", Date.new(2020)).to_sql

# Arel
table = User.arel_table
# or Arel::Table.new(:posts)

table
  .project(table[Arel.star])
  .where(table[:created_at].lt(Date.new(2020)))
  .to_sql

# Compare the SQL

# ActiveRecord => SELECT "users".* FROM "users" WHERE (created_at < '2020-01-01')
# Arel         => SELECT "users".* FROM "users" WHERE "users"."created_at" < '2020-01-01'
