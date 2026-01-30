# Campaign Management - Required Libraries

## Gson Library for JSON Processing

The CampaignServlet uses Google Gson library for JSON serialization/deserialization.

### Download Gson
Download from: https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar

### Installation
1. Download `gson-2.10.1.jar`
2. Copy to `g:\CRM\web\WEB-INF\lib\`
3. Rebuild and redeploy the application

### Alternative: Maven Coordinates
If using Maven:
```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.10.1</version>
</dependency>
```

## Note
The project already has JSTL libraries installed. Only Gson is needed for Campaign Management feature.
