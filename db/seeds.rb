clinic1 = Clinic.create(name: "Clinic A", address: "7 Top St")
clinic2 = Clinic.create(name: "Clinic B", address: "3 Bottom St")

department1 = Department.create(name: "Cardiology", clinic: clinic1)
department2 = Department.create(name: "Dermatology", clinic: clinic2)

specialty1 = Specialty.create(name: "Cardiologist")
specialty2 = Specialty.create(name: "Dermatologist")

doctor1 = Doctor.create(name: "James Aaa", specialty: specialty1, department: department1)
doctor2 = Doctor.create(name: "Jane Bbb", specialty: specialty2, department: department2)

patient1 = Patient.create(name: "Aaa Johnson", birthdate: "2010-10-10")
patient2 = Patient.create(name: "Bbb Williams", birthdate: "2005-05-05")

PatientCard.create(patient: patient1, clinic: clinic1, code: "PC1234")
PatientCard.create(patient: patient2, clinic: clinic2, code: "PC4321")