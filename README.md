# Online Store Analytics

## Описание проекта

**Online Store Analytics** — учебный проект, моделирующий информационную систему интернет-магазина.

Проект демонстрирует полный цикл работы системного аналитика: анализ требований, проектирование базы данных, моделирование бизнес-процессов, разработку технической документации, написание аналитических SQL-запросов и тестирование REST API.

---

## Цели проекта

- разработать структуру реляционной базы данных интернет-магазина;
- спроектировать ER-диаграмму;
- описать структуру данных;
- подготовить бизнес-требования;
- разработать пользовательскую документацию;
- реализовать аналитические SQL-запросы;
- протестировать REST API с помощью Postman.

---

## Технологии

- MS SQL Server
- SQL
- Draw.io
- Postman
- REST API
- JSON
- Git
- GitHub

---

## Структура базы данных
База данных включает следующие сущности:

- Categories
- Products
- Customers
- Orders
- OrderItems
- Payments
- Deliveries

### ER-диаграмма

![ER Diagram](docs/images/er_diagram.png)

---

## Бизнес-процесс

Процесс оформления заказа описан с использованием BPMN.

![BPMN](docs/images/bpmn.png)

---

## SQL

В проекте реализовано **20 аналитических SQL-запросов**, включая:

- JOIN
- LEFT JOIN
- GROUP BY
- HAVING
- Common Table Expressions (CTE)
- CASE
- оконные функции (ROW_NUMBER, DENSE_RANK, SUM OVER)
- агрегатные функции
- анализ продаж
- анализ покупателей
- анализ категорий товаров
- анализ выручки

Файл:

```text
sql/analytics_queries.sql
```

---

## REST API тестирование

Для демонстрации работы с REST API использован публичный сервис **Fake Store API**.

Выполнено тестирование основных CRUD-операций:

- GET
- POST
- PUT
- DELETE

Документация:

```text
docs/API_Documentation.md
```

Коллекция Postman:

```text
api/postman_collection.json
```

---

## Документация

Проект содержит следующую документацию:

- Business Requirements
- User Guide
- Data Dictionary
- API Documentation
- SQL Report

---

## Project Structure

```text
OnlineStoreAnalytics
│
├── api
│   └── postman_collection.json
│
├── database
│   ├── create_database.sql
│   ├── insert_data.sql
│   └── database_diagram.png
│
├── docs
│   ├── API_Documentation.md
│   ├── Business_Requirements.md
│   ├── Data_Dictionary.md
│   ├── SQL_Report.pdf
│   ├── User_Guide.md
│   └── images
│
├── sql
│   └── analytics_queries.sql
│
└── README.md
```

---

## Как запустить проект

1. Создать базу данных в MS SQL Server.
2. Выполнить `create_database.sql`.
3. Выполнить `insert_data.sql`.
4. Запустить `analytics_queries.sql`.
5. При необходимости импортировать коллекцию Postman.
6. Ознакомиться с документацией проекта.

---

## Repository Contents

- SQL database
- Test data
- Analytical SQL queries
- ER Diagram
- BPMN Diagram
- Data Dictionary
- Business Requirements
- User Guide
- REST API Documentation
- Postman Collection

---

## Author

Проект выполнен в рамках формирования портфолио по направлению Системная Аналитика.

GitHub:
https://github.com/tiltarisha