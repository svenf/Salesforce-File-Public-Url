public with sharing class FilePublicUrlController {
    @AuraEnabled
    public static String generatePublicUrl(String contentDocumentId) {

        String resultingUrl = '';
        contentDocumentId = String.escapeSingleQuotes(contentDocumentId);
        
        List<ContentVersion> lsContentVersions = Database.query('SELECT Id, ContentBodyId, FileType FROM ContentVersion WHERE ContentDocumentId = \'' + contentDocumentId + '\'', AccessLevel.USER_MODE);        
        
        if(!lsContentVersions.isEmpty()) {            
            
            List<ContentDistribution> lsContentDistributions = Database.query('SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId = \'' + lsContentVersions[0].Id + '\'', AccessLevel.USER_MODE);

            if(lsContentDistributions.isEmpty()) {
                ContentDistribution cdl = new ContentDistribution();
                cdl.ContentVersionId = lsContentVersions[0].Id;
                cdl.Name = lsContentVersions[0].Id;
                cdl.PreferencesAllowViewInBrowser = true;
                Database.insert(cdl, AccessLevel.USER_MODE);
                lsContentDistributions = Database.query('SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId = \'' + lsContentVersions[0].Id + '\'', AccessLevel.USER_MODE);
            }

            String fileType = lsContentVersions[0].FileType.toLowerCase().capitalize();
            String cVersionId = lsContentVersions[0].Id;
            String cBodyId = lsContentVersions[0].ContentBodyId;
            String originalUrl = String.valueOf(lsContentDistributions[0].DistributionPublicUrl);
            String cDistParam = originalUrl.substring(originalUrl.indexOf('/a/'));
            String orgId = UserInfo.getOrganizationId();
            String baseDomain = Url.getOrgDomainUrl().toExternalForm();
            baseDomain = baseDomain.substringBefore('.') + '--c.documentforce.com';
            resultingUrl = baseDomain + '/sfc/dist/version/renditionDownload?rendition=ORIGINAL_' +
            fileType + '&versionId=' + cVersionId + '&operationContext=DELIVERY&contentId=' + cBodyId +
            '&page=0&d=' + cDistParam + '&oid=' + orgId + '&dpt=null&viewId=';
        }   
        return resultingUrl;     
    }
}
