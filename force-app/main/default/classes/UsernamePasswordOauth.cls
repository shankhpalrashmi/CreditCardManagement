/*
 * This class is used by the client system in order to make a callout to the Server system
 */
public with sharing class UsernamePasswordOauth {

    public static void testAuthorisation() {
        //This is the end point where the username password flow directly hits the standard SFDC Oauth token API url
        String endpoint='https://login.salesforce.com/services/oauth2/token';
        String username = 'prashmi@march22.com';
        String password = 'Prashmi@10'; //add security token if all ip ranges are not whitelisted in your profile
        String ClientId= '3MVG9pRzvMkjMb6kcASn72SbbD0oB_JsKgCfmv5G_fAnU6zERQaNT2ZzGIKoDPIj6NDwnWmXwXSm3cTuzyvn0'; //from connected app
        String ClientSecret = 'E3E66D3B8BDF1BDA6BEF9B9477C243311A32F974E8FA38E47A8884F1D9C25732'; //from connected app
        Httprequest req = new HttpRequest();    
        req.setMethod('POST');    
        //Use this as a request header
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        //Set all the params of the request
        req.setBody('grant_type=password' + 
                    '&client_id=' + ClientId + 
                    '&client_secret=' + ClientSecret + 
                    '&username=' + username +
                    '&password=' + password
                   );    
        req.setEndpoint(endpoint);         
        Http http = new Http();
        HttpResponse res= http.send(req);                
        System.debug('The complete body from the response:'+res.getBody());  
        /* 
         * The response looks like:
         * 13:49:46:267 USER_DEBUG [27]|DEBUG|The complete body from the response:{"access_token":"SESSION_ID_REMOVED",
         * "instance_url":"https://confidential98-dev-ed.my.salesforce.com&quot;,
         * "id":"https://login.salesforce.com/id/00D5g000005UCwZEAW/0055g00000AK4I9AAL&quot;,"token_type":"Bearer",
         * "issued_at":"1638778787176","signature":"ssiJsjVCJL68M3HVvwKJUOpPhsBLtsNso/+7AV/3AGY="}
         */
        //This response can be used to create either a class, which you can use to deserialize and then look at the variables values
        //In this case, we are using the JSONParser class of Salesforce
        JSONParser parser = JSON.createParser(res.getBody());
        String aToken ;        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                System.debug('fieldName'+fieldName);
                if (fieldName == 'access_token') {
                    aToken = parser.getText(); //get the access token
                    System.debug('The access token retrieved from the response is:'+aToken);
                } 
            }
        }
    }
}