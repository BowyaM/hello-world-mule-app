# Common Framework Implementation Testing Guide

## How to Test Your Implementation

### 1. **Start the Application**

Run your Mule application using one of these methods:

**Option A: Anypoint Studio (Recommended)**
- Open the project in Anypoint Studio
- Right-click on your project → Run As → Mule Application
- Wait for the application to start (you'll see "Started app 'hello-world'" in console)

**Option B: Standalone Mule Runtime**
1. First, package your application:
```bash
mvn clean package -DskipTests
```
2. Deploy the generated JAR to a Mule Runtime installation:
   - Copy `target/hello-world-1.0.0-SNAPSHOT-mule-application.jar` to `%MULE_HOME%/apps/` directory
   - Start Mule Runtime: `%MULE_HOME%/bin/mule.bat`

**Option C: Using MuleSoft's Local Deployment Tool (if available)**
```bash
# First package the application
mvn clean package -DskipTests
# Then use deployment tools provided by your organization
```

**Note:** The `mvn mule:run` goal is not available in mule-maven-plugin 4.7.0. Use Anypoint Studio for local development and testing.

### 2. **Test Successful Flow Execution**

Once the application is running (you'll see logs indicating the HTTP listener is started on port 8079):

**Test the Hello World Endpoint:**
```bash
# Using curl
curl -X GET http://localhost:8079/api/helloWorld

# Using PowerShell (Windows)
Invoke-RestMethod -Uri "http://localhost:8079/api/helloWorld" -Method GET
```

**Expected Response:**
```json
{
  "message": "Hello World flow started",
  "timestamp": "2026-04-23T05:44:31.123Z",
  "correlationId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

### 3. **Verify Framework Logging**

**Check Application Logs:**
Look for these log entries in your console or log files:

**A. Flow Start Logging (from init-subflow):**
```json
{
  "success": true,
  "event": "START",
  "apiName": "helloWorld",
  "correlationId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "path": "/api/helloWorld",
  "method": "GET",
  "timestamp": "2026-04-23T05:44:31.123Z"
}
```

**B. Info Logging (from info-subflow):**
```json
{
  "success": true,
  "apiName": "helloWorld",
  "correlationId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "path": "/api/helloWorld",
  "method": "GET",
  "timestamp": "2026-04-23T05:44:31.124Z",
  "message": "Hello World flow processing started"
}
```

**C. Flow End Logging (from exit-subflow):**
```json
{
  "success": true,
  "event": "END",
  "apiName": "helloWorld",
  "correlationId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "path": "/api/helloWorld",
  "method": "GET",
  "timestamp": "2026-04-23T05:44:31.125Z"
}
```

### 4. **Test Error Handling**

To test the global error handler, create an error scenario:

**Test Non-Existent Endpoint:**
```bash
curl -X GET http://localhost:8079/api/nonexistent
```

**Expected Error Response:**
```json
{
  "success": false,
  "event": "ERROR",
  "apiName": "helloWorld",
  "correlationId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "path": "/api/nonexistent",
  "method": "GET",
  "timestamp": "2026-04-23T05:44:31.126Z",
  "error": {
    "code": "404",
    "type": "HTTP:NOT_FOUND",
    "message": "The requested resource could not be found.",
    "technicalDetails": "No listener for endpoint: /api/nonexistent"
  }
}
```

### 5. **Test Configuration Properties**

Verify that the `config.yaml` property is loaded:

**Check Error Detail Exposure:**
The `exposeErrorMessage` property should control whether technical details appear in error responses. Since it's set to `"true"`, you should see the `technicalDetails` field in error responses.

### 6. **Verify Log Files**

**Check Log File Creation:**
Look for the log file at:
- Windows: `%MULE_HOME%\logs\hello-world.log`
- Or in your application directory: `logs\hello-world.log`

The log file should contain structured entries with correlation IDs and proper formatting.

### 7. **Test Different HTTP Methods**

Test unsupported methods to trigger error handling:

```bash
# This should trigger METHOD_NOT_ALLOWED error
curl -X POST http://localhost:8079/api/helloWorld
```

**Expected Response:**
```json
{
  "success": false,
  "event": "ERROR",
  "error": {
    "code": "405",
    "type": "HTTP:METHOD_NOT_ALLOWED",
    "message": "The request's HTTP method is not allowed for this endpoint."
  }
}
```

### 8. **Verification Checklist**

✅ **Application Starts Successfully**
- No compilation errors
- HTTP listener starts on port 8079
- All dependencies resolved

✅ **Logging Framework Works**
- JSON-formatted logs appear in console
- init-subflow logs flow start
- info-subflow logs processing messages  
- exit-subflow logs flow completion
- Correlation ID is consistent across logs

✅ **Error Handling Works**
- Global error handler catches all errors
- Standardized error response format
- Proper HTTP status codes
- Error messages from errorCodeToTypeMapping.json

✅ **Configuration Loading**
- config.yaml properties are accessible
- exposeErrorMessage setting works

✅ **DataWeave Integration**
- log.dwl functions work correctly
- error-response.dwl generates proper error format

### 9. **Performance Testing (Optional)**

Test with multiple concurrent requests:

```bash
# Send multiple requests quickly
for i in {1..10}; do curl -X GET http://localhost:8079/api/helloWorld & done
```

Each request should have a unique correlationId and proper logging.

### 10. **Troubleshooting**

**If the application doesn't start:**
- Check for compilation errors: `mvn clean compile`
- Verify all dependencies are resolved
- Check for XML syntax errors in flow files

**If logging doesn't appear:**
- Check log4j2.xml configuration
- Verify log file permissions
- Check console output for any DataWeave errors

**If error handling doesn't work:**
- Verify global-error-handler.xml is valid
- Check that global.xml references the error handler correctly
- Test with a simple error scenario first

This comprehensive testing approach will verify that your common-framework implementation is working correctly and providing all the expected enterprise-grade features.