%dw 2.0
output application/json skipNullOn="everywhere"
var mapping = readUrl("classpath://errorCodeToTypeMapping.json", "application/json")
var httpResponse = (mapping[error.errorType.identifier])[0] default {
      "errorCode": error.errorMessage.attributes.statusCode,
      "errorDescription": "Failure occured. Please verify technicalDetails or logs for more info"
    }
--- 
{
    success: false,
    event: "ERROR",
    apiName: vars.initVar.appName default app.name,
    correlationId: vars.initVar.transactionId default correlationId,
    path: vars.initVar.path,
    method: vars.initVar.method,
    timestamp: now(),
    (errorCategory: vars.errorCategory) if(!isEmpty(vars.errorCategory)),
    (customMessage: vars.customMessage) if(!isEmpty(vars.customMessage)),
    error: {
        code: httpResponse.errorCode,
        "type": (error.errorType.namespace default "MULE") ++ ":" ++ (error.errorType.identifier default "ANY"),
        message: httpResponse.errorDescription,
        (technicalDetails: error.description) if(p('exposeErrorMessage') ~= "true")
    }
}