fun log(details: Object) = 
{
   success: true,
   event: details.event,
   apiName: details.appName,
   correlationId: details.transactionId,
   path: details.path,
   method: details.method,
   timestamp: now()
}

fun log(details: Object, message: Any) = 
{
   success: true,
   apiName: details.appName,
   correlationId: details.transactionId,
   path: details.path,
   method: details.method,
   timestamp: now(),
   message: message
}