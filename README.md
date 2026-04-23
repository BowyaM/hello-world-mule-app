# Hello World MuleSoft Application

This is a MuleSoft application demonstrating common framework patterns including:

## Features
- HTTP Listener endpoint on port 8079
- Global error handling with standardized error responses
- Centralized logging with correlation IDs
- Configuration management via YAML
- DataWeave transformations for logging and error handling
- Common framework integration

## Project Structure
```
src/main/mule/
├── hello-world.xml          # Main application flow
├── global.xml               # Global configurations
└── common/
    ├── global-error-handler.xml  # Error handling
    └── logger.xml               # Logging utilities

src/main/resources/
├── config.yaml              # Application configuration
├── log4j2.xml              # Logging configuration
├── errorCodeToTypeMapping.json
└── dwl/                     # DataWeave scripts
    ├── error-response.dwl
    └── log.dwl
```

## Getting Started
1. Clone this repository
2. Import the project into Anypoint Studio
3. Configure your environment properties in config.yaml
4. Run the application
5. Access the endpoint at http://localhost:8079/api/helloWorld

## API Endpoints
- **GET** `/api/helloWorld` - Returns a hello world message with timestamp and correlation ID

## Testing
See TESTING_GUIDE.md for detailed testing instructions.

## Dependencies
- Mule Runtime 4.11.2
- HTTP Connector 1.11.1
- Common Framework 1.0.4

## Configuration
- **Port**: 8079
- **Base Path**: /api
- **Error Message Exposure**: Controlled via config.yaml

## Response Format

### Successful Response
```json
{
  "message": "Hello World flow started",
  "timestamp": "2026-04-23T06:41:31.123Z",
  "correlationId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

### Error Response
```json
{
  "success": false,
  "event": "ERROR",
  "apiName": "helloWorld",
  "correlationId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "path": "/api/helloWorld",
  "method": "GET",
  "timestamp": "2026-04-23T06:41:31.123Z",
  "error": {
    "code": "500",
    "type": "MULE:ANY",
    "message": "An unexpected error occurred"
  }
}
```

## Logging
The application uses structured JSON logging with correlation IDs for traceability:
- **START**: Flow initialization
- **INFO**: Processing messages
- **END**: Flow completion
- **ERROR**: Error handling

## Development
To run locally:
1. Ensure you have Mule Runtime 4.11.2 or compatible version
2. Import project into Anypoint Studio
3. Run as Mule Application
4. Test endpoints using curl or Postman

## Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request
