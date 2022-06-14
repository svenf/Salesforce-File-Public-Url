@IsTest
public with sharing class FilePublicUrlControllerTest {
    @TestSetup
    static void createTestData()
    {
        ContentVersion cv = new Contentversion();
        cv.title = 'ABC';
        cv.PathOnClient ='test';
        Blob b = Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;

        ContentDistribution cdl = new ContentDistribution();
        cdl.ContentVersionId = cv.Id;
        cdl.Name = cv.Id;
        cdl.PreferencesAllowViewInBrowser = true;
        insert cdl;
    }

    @IsTest
    private static void testGeneratePublicUrlNoDist()
    {
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = 'ABC' LIMIT 1];
        ContentDistribution cdl = [SELECT Id FROM ContentDistribution WHERE ContentVersionId = :cv.Id LIMIT 1];
        delete cdl;

        Test.startTest();
        String result = LAVA_FilePublicUrlController.generatePublicUrl(cv.ContentDocumentId);
        Test.stopTest();
        System.assertNotEquals(null, result, 'URL must be populated');
    }

    @IsTest
    private static void testGeneratePublicUrlDist()
    {
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = 'ABC' LIMIT 1];
        Test.startTest();
        String result = LAVA_FilePublicUrlController.generatePublicUrl(cv.ContentDocumentId);
        Test.stopTest();
        System.assertNotEquals(null, result, 'URL must be populated');
    }
}
