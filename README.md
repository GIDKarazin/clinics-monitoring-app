# Illia Havrylenko Ks-31
Hospital app

## HTTP Verbs
| HTTP METHOD | URL                       | Payload                                        | Description                                                             |
|-------------|---------------------------|------------------------------------------------|-------------------------------------------------------------------------|
| GET         | /clinics                  | {}                                             | Shows all clinics                                                       |
| GET         | /clinics/download_csv     | {}                                             | Downloads a csv file with all clinics and their patients info           |
| GET         | /clinics/download_pdf     | {}                                             | Downloads a pdf file with all clinics and their patients info           |
| GET         | /clinics/:id              | {id: 77}                                       | Shows info about clinic with specific id                                |
| GET         | /clinics/:id/download_pdf | {id: 77}                                       | Downloads a pdf file with clinic with specific id and its patients info |
| POST        | /clinics/new              | {name: 'Clnc1', email: 'aaa@aaa.com',          | Creates a new clinic with the payload                                   |
|             |                           | phone: 3801234567, address: '7 S St'}          |                                                                         |
| PUT/PATCH   | /clinics/:id/edit         | {name: 'Clnc2', email: 'bbb@bbb.com',          | Updates clinic with specific id with the payload                        |
|             |                           | phone: 3802345678, address: '8 S St'}          |                                                                         |
| DELETE      | /clinics/:id              | {id: 77}                                       | Deletes clinic with the given id                                        |
| GET         | /clinics/search           | {name: 'Clnc1'}                                | Searches for specific clinic                                            |
| GET         | /clinics/:id/searchshow   | {name: 'Ptnt1'}, {age: '18'},                  | Searches for specific patients with specific payload of                 |
|             |                           | {phone: '380987654321'}                        | the clinic with specific id                                             |
| GET         | /departments              | {}                                             | Shows all departments                                                   |
| GET         | /departments/:id          | {id: 77}                                       | Shows department with specific id                                       |
| POST        | /departments/new          | {name: 'Dprt1', description: '...'}            | Creates a new department with the payload                               |
| PUT/PATCH   | /departments/:id/edit     | {name: 'Dprt2', description: '!!!'}            | Updates department with specific id with the payload                    |
| DELETE      | /departments/:id          | {id: 77}                                       | Deletes department with the given id                                    |
| GET         | /departments/search       | {name: 'Dprt1'}                                | Searches for specific department                                        |
| GET         | /specialties              | {}                                             | Shows all specialties                                                   |
| GET         | /specialties/:id          | {id: 77}                                       | Shows specialty with specific id                                        |
| POST        | /specialties/new          | {name: 'Sclt1', description: '...'}            | Creates a new specialty with the payload                                |
| PUT/PATCH   | /specialties/:id/edit     | {name: 'Sclt2', description: '!!!'}            | Updates specialty with specific id with the payload                     |
| DELETE      | /specialties/:id          | {id: 77}                                       | Deletes specialty with the given id                                     |
| GET         | /specialties/search       | {name: 'Sclt1'}                                | Searches for specific specialty                                         |
| GET         | /doctors                  | {}                                             | Shows all doctors                                                       |
| GET         | /doctors/:id              | {id: 77}                                       | Shows doctor with specific id                                           |
| POST        | /doctors/new              | {name: 'Dctr1', email: 'ccc@ccc.com',          | Creates a new doctor with the payload                                   |
|             |                           | phone: 3803456789, biograhpy: '...'}           |                                                                         |
| PUT/PATCH   | /doctors/:id/edit         | {name: 'Dctr2', email: 'ddd@ddd.com'           | Updates doctor with specific id with the payload                        |
|             |                           | phone: 3804567890, biograhpy: '???'}           |                                                                         |
| DELETE      | /doctors/:id              | {id: 77}                                       | Deletes doctor with the given id                                        |
| GET         | /doctors/search           | {name: 'Dctr1'}                                | Searches for specific doctor                                            |
| GET         | /patients                 | {}                                             | Shows all patients                                                      |
| GET         | /patients/:id             | {id: 77}                                       | Shows patient with specific id                                          |
| POST        | /patients/new             | {name: 'Ptnt1', birthdate: '2005-05-05',       | Creates a new patient with the payload                                  |
|             |                           | email: 'eee@eee.com',  phone: 3805678901,      |                                                                         |
|             |                           | address: '9 S St'}                             |                                                                         |
| PUT/PATCH   | /patients/:id/edit        | {name: 'Ptnt2', birthdate: '2010-10-10',       | Updates patient with specific id with the payload                       |
|             |                           | email: 'fff@fff.com',  phone: 3806789012,      |                                                                         |
|             |                           | address: '1 S St'}                             |                                                                         |
| DELETE      | /patients/:id             | {id: 77}                                       | Deletes patient with the given id                                       |
| GET         | /patients/search          | {name: 'Ptnt1'}                                | Searches for specific patient                                           |
| GET         | /patient_cards            | {}                                             | Shows all patient cards                                                 |
| GET         | /patient_cards/:id        | {id: 77}                                       | Shows patient card with specific id                                     |
| POST        | /patient_cards/new        | {code: 'GH2468', description: '!?!'}           | Creates a new patient card with the payload                             |
| PUT/PATCH   | /patient_cards/:id/edit   | {code: 'HG8642', description: '?!?'}           | Updates patient card with specific id with the payload                  |
| DELETE      | /patient_cards/:id        | {id: 77}                                       | Deletes patient card with the given id                                  |
| GET         | /patient_cards/search     | {name: 'Clnc1'}                                | Searches for specific patient card                                      |
| GET         | /                         | {}                                             | Shows all main and authentication links                                 |
| POST        | /users/sign_up            | {email: 'example@gmail.com', password: 'pass'} | Creates a new user with the payload                                     |
| DELETE      | /users/                   | {}                                             | Deletes the current user with ending of user's session                  |
| POST        | /users/sign_in            | {email: 'example@gmail.com', password: 'pass'} | Starts a new session for the user with the payload                      |
| DELETE      | /users/sign_out           | {}                                             | Ends the session for the current user                                   |
| POST        | /users/password/new       | {email: 'example@gmail.com'}                   | Sends a password change message to the specific email                   |
| DELETE      | /users/sign_out           | {}                                             | Ends the session for the current user                                   |
| GET         | /users/download_pdf       | {}                                             | Downloads a pdf file with all users info                                |

## ERD diagram
 +-----------+       +-----------------+       +-----------------------+       +----------------+       +--------------------+       +----------------+ +--------------------+
 | Patients  |  1:1  | PatientCards    |  N:1  | Clinics               |  1:N  | Departments    |  1:N  | Doctors            |  N:1  | Specialties    | | Users              |
 +-----------+<----->+-----------------+------>+-----------------------+<------+----------------+<------+--------------------+------>+----------------+ +--------------------+
 | id (PK)   |       | id (PK)         |       | id (PK)               |       | id (PK)        |       | id (PK)            |       | id (PK)        | | id (PK)            |
 | name      |       | code            |       | name                  |       | name           |       | name               |       | name           | | email              |
 | birthdate |       | description     |       | email                 |       | description    |       | email              |       | description    | | encrypted_password |
 | email     |       | clinic_id (FK)  |       | phone                 |       | clinic_id (FK) |       | phone              |       +----------------+ +--------------------+
 | phone     |       | patient_id (FK) |       | address               |       +----------------+       | biography          |
 | address   |       | doctor_id (FK)  |       | year_of_establishment |                                | department_id (FK) |
 +-----------+       |                 |       | facility_type         |                                | specialty_id (FK)  |
                     |                 |       | city                  |                                |                    |
                     |                 |       | rating_mortality      |                                |                    |
                     |                 |       +-----------------------+                           N:1  |                    |
                     +-----------------+--------------------------------------------------------------->+--------------------+

### Labs
- [] Task 1 --> Створити моделі, що відповідають таким таблицям у базі даних додатку:
Клініки (поля на вибір)
Відділення (поля на вибір. Клініка може мати n відділень)
Лікарі (поля на вибір. Відділення може мати n лікарів)
Спеціальності (поля на вибір. Лікар належить до 1 спеціальністі)
Карти пацієнтів (поля на вибір У клініці може бути багато карток)
Пацієнти (поля на вибір У карті може бути 1 пацієнт)
- [] Task 2 --> Вставити 100 записів у таблиці. У 3 таблиці зробити методи, які будуть обгорткою на чистому SQL. У 3 інші таблиці просто на ОРМ. Зробити по 2 SQL VIEW.
- [] Task 3 --> Написати Readme.md файл. Зробити CRUD форми під кожну модель.
- [] Task 4 --> Додати гем Devise до вашого веб застосунку (повинна бути можливість зареєструватись/залогінитись/відновити пароль). Додати тести. Додати CSS/JS.
- [] Task 5 --> Зробити root_page (наповнення яке завгодно але повинне бути посилання на  вхід/реєстрацію). Пропрацювати інформацію про лікарні (треба додати рік створення, зв'язати пацієнта з доктором). Створити таблиці як на наданому зображені (кожна таблиця повинна мати пагінацію, якщо поле з "number of ... ", то це кількість моделей в асоціації і треба порахувати таке поле. Виконати з CSS. Створити сторінки під кожну модель. Додати логіку під Пошук та Сортування за допомогою QueryObject. Оновити тести.
- [] Task 6 --> Зробити rake-задачу, яка парсить сайт: https://www.hospitalsafetygrade.org/all-hospitals. З додаванням у БД назв цих лікарень (розроблено через створення нових лікарень з цими назвами). Використовувати гем: https://github.com/sparklemotion/nokogiri.
- [] Task 7 --> Додати поля facility_type, city, rating_mortality у таблицю лікарень. Додати файл hospitals.cvs у теку додатку. Розпарсити файл та зберігти дані за допомогою rake-задачі
- [] Task 8 --> Додати можливість завантажувати СSV та PDF файли. СSV має містити в одному файлі всю інформацію про всі лікарні та їх пацієнтів. PDF-файли повинні містити інформацію про всі лікарні та їх пацієнтів, інформацію про кожну окрему лікарню (стилізувати, додати зображення), інформація про користувачів (стилізувати, додати зображення). Оновити тести