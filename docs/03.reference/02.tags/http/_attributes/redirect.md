Boolean indicating whether to redirect execution or stop execution.

The default is Yes.

If set to No and throwOnError = "yes", execution stops if cfhttp fails, and the status code and associated error message are returned in the variable cfhttp.statuscode.

To see where execution would have been redirected, use the variable cfhttp.responseHeader[LOCATION]. The key LOCATION identifies the path of redirection.

Lucee will follow up to five redirections on a request. If this limit is exceeded, Lucee behaves as if redirect = "no".

If set to "Lax", filecontent for redirects for POST and DELETE requests will be returned, since **7.0.0.208**