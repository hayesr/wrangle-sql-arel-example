# In Rails 6.0.2.2
User.where.not(status: 0, role: 'admin')

# DEPRECATION WARNING: NOT conditions will no longer behave as NOR in Rails 6.1.
# To continue using NOR conditions, NOT each conditions manually
# (`.where.not(:status => ...).where.not(:role => ...)`). (called from ...

User.where.not(status: 0).where.not(role: 'admin')

# No warning
