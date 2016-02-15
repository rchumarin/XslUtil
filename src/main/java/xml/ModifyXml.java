package xml;

/**
 *
 * @author rchumarin
 */
public class ModifyXml {
    
    public static void modifyXml(String input, String h2hDigestAttachment) {
        String fullString = input;
        String beginTag = "<Attachment>";
        String endTag = "</Attachment>";        
        int first = input.indexOf(beginTag);
        int last = input.lastIndexOf(endTag);
        input = input.substring(first, last + endTag.length());        
        System.out.println(fullString.replaceAll(input, h2hDigestAttachment));
    }
    
}
