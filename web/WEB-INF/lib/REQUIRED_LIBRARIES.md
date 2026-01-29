# Thư viện cần thiết cho SQL Server JDBC với Java 11+

## Cách 1: Sử dụng driver mới (KHUYẾN NGHỊ)

Tải driver SQL Server JDBC phiên bản mới:
- mssql-jdbc-12.6.1.jre11.jar
- Link: https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/12.6.1.jre11/mssql-jdbc-12.6.1.jre11.jar

## Cách 2: Thêm JAXB dependencies (nếu dùng driver cũ)

Nếu muốn giữ driver cũ, cần thêm các file JAR sau:
1. jaxb-api-2.3.1.jar
   https://repo1.maven.org/maven2/javax/xml/bind/jaxb-api/2.3.1/jaxb-api-2.3.1.jar

2. jaxb-runtime-2.3.9.jar
   https://repo1.maven.org/maven2/org/glassfish/jaxb/jaxb-runtime/2.3.9/jaxb-runtime-2.3.9.jar

3. jakarta.activation-api-1.2.2.jar
   https://repo1.maven.org/maven2/jakarta/activation/jakarta.activation-api/1.2.2/jakarta.activation-api-1.2.2.jar

## Hướng dẫn
1. Tải các file JAR cần thiết
2. Copy vào thư mục: g:\CRM\web\WEB-INF\lib\
3. Restart Tomcat
