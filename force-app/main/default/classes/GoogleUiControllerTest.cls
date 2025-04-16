@isTest 
public class GoogleUiControllerTest {
    static testMethod void TestGoogleUiController() {
    
    /*Google_OAuth2__mdt GOA = new Google_OAuth2__mdt();
    GOA.Label = 'Google BigQuery';
    GOA.DeveloperName ='Google_BigQuery'  ;
    GOA.Issuer__c = 'glific-sf@whats-next-v1.iam.gserviceaccount.com';
    GOA.PKCS8__c = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmDablER+qG6RI\nz2y82DM/DBAObY6sPjHfdPbo/CnbgZ24F75GKUVL0egCLjEZFgfLGZxzHRgBvAtm\ngukel8S5qf8Ex2qYqKCyiCxv9DfzKOhsOUDWv6X1PfFcUTPXPX6VWDkFI15CtCEA\n75nUcljz3ApjKuwLUFm6gBcq8XjZ8Ae9QYMUfOITRpm3yYF8MzC41RIMhBxx3OGw\niubYrIhdQUpYjCRljFyCDJ9X1BGY50BKZboB0npSX5Lj1bfDFADuzR226VN33q2s\nYubf2Ek+DIRGSyZuT9yxuLcRhWnLKq6TnePpflOqyUGjPS7dURG2ePV4LdgIuFPX\nL7XTOy5LAgMBAAECggEAQmv9kW1rFBlgert2DIgS36pMlejfBCkQvAjGZ2XOvH45\nf5UHyHrjvDNnsc+WVimIzoYdHbLKko8MpGHDLDibOYU1fEzkZ9I0DZYI6HNxGfQI\nHJo+RGh+0v2HGV1l9jgj9UtH67U9FEOHXB97kg53ZHxlL0vRBamLat2n5saWh94l\n16v6OkKAP86aDI5RLXzpatUYg5+NXiumCjEQijAvqepmPaBJVidB9eb3qZvACeBp\nGoVpFTatu5a8SMbmpC1PggLo/qn53dG4nn4akuBpO5N4tgCI+q43aIh1EZ9lysQl\nlbjvYMOY7Ej9DYObV5P9f/4AGuITU0mv0GSSNizY+QKBgQDPAZ8jA+gW/xNHO+AF\nm/tNprLfbo+HCWjP1gdJH3lX4DP6rbnyNS+piqhuBolyZbjm5mxlkEx1EOmVn4fb\nvpRejIpUPWEUXN3uc790nPF+KSalckFcodX4K8hsOWwFcj5Hj+tSZRdA6YFz/gCY\ni0+mBYZzcK24TEwkq68+AaqS7QKBgQDNWrbksjYGXJVFRRhjxFjTnV0ZZ848J6to\ngOfhTqv/ppVo+pvpGbDYsEVKFjTvtaR2P3nCLlICsc6pEIQzJ0sM+tTZGoFgUdH0\n5kofHnALgQ154PIY+/kgDjdUbFfbcdDozEOX6p4JNyFVhq8eAj+OoclYhwjs6c/j\nVL9DcIGHFwKBgQDMiUqnO23wgvqWcPfqMvQ9BpBJKqIQiGCSs2ShgMLR7EsPzuYj\nByBgAgxoIndenFn1dAn41HpnVV2npGiF3KoXPgBUOg2ZJCV5Pc8Xtxb6VEjGQr2I\nfLPBsekn3hj4zKfy56ZZ1F8EmXR6mqgWEdiSL3VozRYpOuIlfan6t4TGBQKBgCF0\nlvlZQ030BWmcoSWX1nTbXVCHReUs/VLwNVbSj1j+FbddpMrsIZCb3x370jH/YMTX\nAIovK7M+rpGCnFcNHsAFmWmpVMyRZ+hDIG5DcjOdmclyaV7Cpkqfpkn9wK6Cs2tJ\n4/U7BvYvYiHh6GO2MA6XswrWLRET4oeBxgtBqAiPAoGAL4LHJ9BpFsV60ql4jITu\nn5a/QApP4o3hkFLexJId4c4sUmFZdCFJJwGcJ3HIqIq9Y2u1I2NMyuo7Ii4VR/yl\nSHtd+trd7gWeXXp7gsxET9a5S84BQO8RWCwJuA40vj/IQPLLj8XyNxAddfLcRoFs\n6/OdF1qAr23v6aXIR4P/GO4=';
    Insert goa;*/
    
    //List<Google_Oauth2__mdt> mdts = [SELECT Issuer__c, PKCS8__c FROM Google_Oauth2__mdt LIMIT 1];
    
    Test.StartTest();
        
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockTokenForBigQuery');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        StaticResourceCalloutMock mock1 = new StaticResourceCalloutMock();
        mock1.setStaticResource('mockResponseForBigQuery');
        mock1.setStatusCode(200);
        mock1.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock1);
        
    GoogleUiController.runBigQuerySql('select * from [917208473080.flow_results] limit 5'); 
    
    Test.stopTest();
    }
    
    
    }