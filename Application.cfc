component name="Application" {
	public void function OnRequest ( required string TargetPage ) {
		var PROXY_HEADER = "X-Proxy-URL";

		var httpService = new http();
		var reqData = Duplicate(GetHttpRequestData());
		var responseHeaders = {};
		var responseBody = "";
		var responseStatus = 200;
		var httpResult = "";
		var pc = GetPageContext().getResponse();

		reqData["url"] = Duplicate(URL);

		if ( StructKeyExists(reqData.headers, PROXY_HEADER) ) {
			if ( StructKeyExists(reqData, "method") ) {
				httpService.setMethod(reqData.method);
			}
			// httpService.setCharset("utf-8");
			httpService.setUrl(reqData.headers[PROXY_HEADER]);
			StructDelete(reqData.headers, PROXY_HEADER);
			httpService.setResult("httpResult");

			for (headerName in reqData.headers) {
				httpService.addParam(type="header", name=headerName, value=reqData.headers[headerName]);
			}
			for (paramName in reqData.url) {
				httpService.addParam(type="URL", name=paramName, value=reqData.url[paramName]);
			}
			if ( StructKeyExists(reqData, "content") ) {
				httpService.addParam(type="body", value=reqData.content);
			}

			httpResult = httpService.send().getPrefix();

			if ( StructKeyExists( httpResult, "responseHeader" ) ) {
				for (headerName in httpResult.responseHeader) {
					responseHeaders[headerName] = httpResult.responseHeader[headerName];
				}
			}
			if ( StructKeyExists(httpResult, "fileContent") ) {
				try {
					responseBody = httpResult.fileContent.toString();
				} catch (any e) {
					// Do nothing
				}
			}
			if ( StructKeyExists(httpResult, "statusCode") ) {
				responseStatus = Val(httpResult.statusCode);
			}
		} else {
			responseHeaders["StatusCode"] = "400 Bad Request. Must include HTTP header '#PROXY_HEADER#'";
			responseStatus = 400;
		}

		for (headerName in responseHeaders) {
			pc.setHeader(headerName, responseHeaders[headerName]);
		}
		pc.getResponse().setStatus(responseStatus);

		WriteOutput(responseBody);
	}
}