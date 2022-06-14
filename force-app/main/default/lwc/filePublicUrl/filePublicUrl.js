import { LightningElement, api } from "lwc";
import generatePublicUrl from "@salesforce/apex/FilePublicUrlController.generatePublicUrl";
import FilePublicLink from '@salesforce/label/c.File_Public_Link';
import Generate from '@salesforce/label/c.Generate';

export default class LavaPublicUrl extends LightningElement {
    @api recordId;
    publicURL = "";

    label = {
        FilePublicLink,
        Generate
    };

    handleGenerateLink() {
        generatePublicUrl({contentDocumentId : this.recordId})
        .then(result =>{
            this.publicURL = result;
        })
        .catch(error =>{
            this.errorMsg = error;
        })
    }
}