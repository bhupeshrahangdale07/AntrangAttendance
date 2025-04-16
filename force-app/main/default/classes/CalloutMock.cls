/*
    Class is created for test class to create fake response.
*/
@isTest
public class CalloutMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;
    protected string url;

    public CalloutMock (string url,Integer code, String status,string body,
                                     Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.bodyAsString = body;
        this.bodyAsBlob = null;
        this.responseHeaders = responseHeaders;
        this.url = url;
    }

    public CalloutMock (string url,Integer code, String status, Blob body,
                                     Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.bodyAsBlob = body;
        this.bodyAsString = null;
        this.responseHeaders = responseHeaders;
        this.url = url;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setStatus(status);
        if (bodyAsBlob != null) {
            resp.setBodyAsBlob(bodyAsBlob);
        } else {
            resp.setBody(bodyAsString);
        }

        if (responseHeaders != null) {
             for (String key : responseHeaders.keySet()) {
                 resp.setHeader(key, responseHeaders.get(key));
             }
        }
        return resp;
    }
}