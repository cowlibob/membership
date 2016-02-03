module ScopedByYear

  def self.included(mod)
    mod.scope :by_year, Proc.new{|year| where(["DATE_PART('year', created_at) = ?", year]) }
  end

  def recent_scopes
    (Date.today.year-3..Date.today.year).to_a.reverse.each {|year| scope(year.to_s) { |scope| scope.by_year(year)} }
  end
end
