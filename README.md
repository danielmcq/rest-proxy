rest-proxy
=========

A very simple ColdFusion app to create a REST proxy objects to silently forward traffic between two hosts.
Useful for web apps which rely on REST API calls on a different domain but where it's not possible to use JSONP or change the Access-Control-Allow-Origin header. Use case is atypical as ColdFusion is out of style. However, for those working in an enterprise environment where migration to something other than ColdFusion isn't likely in within the next decade, this little app might save you time.

# Usage
Simply place this folder on the same server from which you serve your other web app assets (HTML, CSS, JS/ES, etc) and where ColdFusion is already configured to run. In your XHR calls, instead point the URL to the path to this app, and add the HTTP header 'X-Proxy-URL' with the value of the URL that needs to be communicated with. All Cookies, HTTP headers, URL query params, data, etc is automatically forwarded to the proxied server. Likewise the response details are forwarded back to the client.
