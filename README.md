# Online Shopping Cart — Java / JSP

A **Semester III academic Java web project** in Aung Myo Pyae's UIT coursework collection. The application demonstrates an online store using Servlets, JSP, JDBC, and MySQL, with customer shopping flows and administrative product/stock management.

**Attribution:** this codebase includes the Apache-2.0-licensed [shopping-cart project by shashirajraja / Bitter Code](https://github.com/shashirajraja/shopping-cart). The upstream LICENSE and package names are retained. This portfolio copy does not claim sole authorship of the inherited implementation.

## Main features

- Customer registration, login, profile display, and logout.
- Product browsing with details and images.
- Cart addition, quantity updates, removal, and cart totals.
- Demonstration checkout, order records, and shipment status pages.
- Admin product creation, editing, removal, stock views, and shipment management.
- JDBC persistence and optional email notification code.

The payment screen is a demonstration; it does not process real card payments.

## How it works

1. JSP pages render the storefront and forms in the browser.
2. Form submissions and requests are handled by servlet classes in src/com/shashi/srv.
3. Servlets read request values, consult the service layer, set HTTP session values, and forward or redirect to the appropriate JSP.
4. Service implementations perform the catalog, account, cart, and order operations using JDBC.
5. DBUtil loads the local application.properties file and opens a MySQL connection.
6. Data is stored in product, user, usercart, user_demand, transactions, and orders tables. Product images are stored as database binary data.

Customer sign-in is database-backed. The inherited admin sign-in uses a hardcoded demonstration credential in LoginSrv.java; it is not a production authentication design.

## Repository guide

| Path | Purpose |
| --- | --- |
| WebContent/ | JSP pages, static assets, and web configuration |
| src/com/shashi/beans/ | Data objects for products, users, carts, and orders |
| src/com/shashi/srv/ | HTTP servlet request handlers |
| src/com/shashi/service/ | Service interfaces |
| src/com/shashi/service/impl/ | JDBC-backed service implementations |
| src/com/shashi/utility/ | Database, identifier, and email helpers |
| src/application.properties.example | Credential-free configuration template |
| databases/mysql_query.sql | MySQL schema |
| pom.xml | Maven dependencies and WAR build |

## Prerequisites

- JDK 8 or a compatible newer JDK; Maven compiles for Java 8.
- Maven.
- MySQL 8 (the SQL uses the utf8mb4_0900_ai_ci collation).
- A Tomcat version supporting javax.servlet, such as Tomcat 9. Tomcat 10+ uses the Jakarta namespace and needs a source migration.

## Local setup

1. Create a disposable MySQL database environment and import databases/mysql_query.sql using MySQL Workbench or the mysql client. The script creates the schema named shopping-cart and drops/recreates its tables; use it only in a fresh demo environment.
2. Copy src/application.properties.example to src/application.properties.
3. Set the JDBC configuration to match your local MySQL installation:

~~~properties
db.driverName=com.mysql.cj.jdbc.Driver
db.connectionString=jdbc:mysql://localhost:3306/shopping-cart
db.username=YOUR_LOCAL_DATABASE_USER
db.password=YOUR_LOCAL_DATABASE_PASSWORD
mailer.email=
mailer.password=
~~~

4. Build the WAR from the repository root:

~~~sh
mvn package -DskipTests
~~~

5. Deploy target/shopping-cart-0.0.1-SNAPSHOT.war into Tomcat's webapps directory and start Tomcat.
6. Open **http://localhost:8080/shopping-cart-0.0.1-SNAPSHOT/** (adjust for your Tomcat port/context).

The public SQL contains schema only: original account, order, and catalog seed rows have been removed. Register a disposable customer and use the admin pages to populate a demo catalog. The portfolio copy's inherited demo admin is **demo@example.test / Admin@123**; choose Admin in the login form. These are local sample values, not real account credentials.

Configure email only if you need to explore those flows. The Maven mail dependencies and the JavaMailUtil imports should be reviewed if your chosen toolchain reports a javax.mail / jakarta.mail compatibility error; a fresh source build has not been established for this portfolio copy.

## Suggested walkthrough

Create sample products as an admin, register a customer, browse products, modify cart quantities, complete the simulated checkout, and inspect order/shipping pages. Explore the service implementations to see how each action maps to SQL.

## Public-copy changes and limitations

Original database/mail settings and personal sample records are excluded. The original Workbench model is also omitted because its embedded data contains personal sample records; use the sanitized SQL schema instead. Generated WAR files, dependencies, and local configuration are not committed. This project retains legacy authentication/session patterns and is intended for local learning. Do not use it with real customer data or real payments.
