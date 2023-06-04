class PatientQuery
  include PatientsHelper
  def initialize(relation = Patient.all)
    @relation = relation
  end

  def sort(field, direction = :asc)
    @relation = @relation.order("#{field} #{direction}")
    self
  end

  def search(field, term)
    if field == :age
      age = term.to_i
      max_birthdate = age.years.ago.at_end_of_day
      min_birthdate = (age + 1).years.ago.at_beginning_of_day
      @relation = @relation.where(birthdate: min_birthdate..max_birthdate)
    else
      @relation = @relation.where("LOWER(#{field}) LIKE ?", "%#{term.downcase}%")
    end
    self
  end

  def result
    @relation
  end
end