class DoctorQuery
  def initialize(relation = Doctor.all)
    @relation = relation
  end

  def sort(field, direction = :asc)
    @relation = @relation.order("#{field} #{direction}")
    self
  end

  def search(field, term)
    @relation = @relation.where("#{field} LIKE ?", "%#{term}%")
    self
  end

  def result
    @relation
  end
end