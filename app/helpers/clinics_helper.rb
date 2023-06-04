module ClinicsHelper
  def calculate_age(birthdate)
    now = Time.now.utc.to_date
    age = now.year - birthdate.year
    age -= 1 if now.month < birthdate.month || (now.month == birthdate.month && now.day < birthdate.day)
    age
  end
end