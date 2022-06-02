@isTest
public class HttpMock implements HttpCalloutMock {
    private List<HttpResponse> responseList;

    public HttpMock(HttpResponse response) {
        this.responseList = new List<HttpResponse>{ response };
    }

    public HttpMock(List<HttpResponse> responseList) {
        this.responseList = responseList;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = responseList.get(0);
        responseList.remove(0);
        return res;
    }
}