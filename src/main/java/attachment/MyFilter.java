package attachment;

import base64.EncodeBase64;
import javax.xml.bind.DatatypeConverter;

/**
 *
 * @author rchumarin
 */
public class MyFilter implements Filter{

    @Override
    public String h2hDigestAttachment(String input) {
        String fullString = input;
        StringBuffer result = new StringBuffer();
        String[] attachment;
        String beginTag = "<Attachment>";
        String endTag = "</Attachment>";
        String fileTag = "<Field FieldName=\"FILENAME\" DataType=\"STRING\">";
        String valueTag = "<Field FieldName=\"VALUE\" DataType=\"STRING\">";
        String smallTag = "<Field FieldName=\"SMALLICON\" DataType=\"STRING\">";
        String bigTag = "<Field FieldName=\"BIGICON\" DataType=\"STRING\">";
        String endFieldTag = "</Field>";
        int first = input.indexOf(beginTag);
        int last_full = input.lastIndexOf(endTag);
        if (first == -1) {
            return "";
        }
        input = input.substring(first, input.length());
        int last = input.lastIndexOf(endTag);
        if (last == -1) {
            return "";
        }
        input = input.substring(0, last + endTag.length());
        input = input.replaceAll(endTag, "");
        attachment = input.split("<Attachment>");
        for (int i = 0; i < attachment.length; i++) {
            if (attachment[i].length() == 0) {
                continue;
            }
            String filename = attachment[i].substring(attachment[i].indexOf(fileTag) + fileTag.length(), attachment[i].indexOf(endFieldTag));
            attachment[i] = attachment[i].substring(attachment[i].indexOf(endFieldTag) + endFieldTag.length(), attachment[i].length());
            String value = attachment[i].substring(attachment[i].indexOf(valueTag) + valueTag.length(), attachment[i].indexOf(endFieldTag));
            byte[] valueBin = EncodeBase64.encodeBase64(value);
            String valueHex = DatatypeConverter.printHexBinary(valueBin);
            attachment[i] = attachment[i].substring(attachment[i].indexOf(endFieldTag) + endFieldTag.length(), attachment[i].length());
            String smallIcon = attachment[i].substring(attachment[i].indexOf(smallTag) + smallTag.length(), attachment[i].indexOf(endFieldTag));
            attachment[i] = attachment[i].substring(attachment[i].indexOf(endFieldTag) + endFieldTag.length(), attachment[i].length());
            byte[] smallBin = EncodeBase64.encodeBase64(smallIcon);
            String bigIcon = attachment[i].substring(attachment[i].indexOf(bigTag) + bigTag.length(), attachment[i].indexOf(endFieldTag));
            byte[] bigBin = EncodeBase64.encodeBase64(bigIcon);
            result.append(new String(H2hDoLength.h2hDoLength(filename.length())));
            result.append(filename);
            result.append(new String(H2hDoLength.h2hDoLength(smallBin.length)));
            result.append(new String(smallBin));
            result.append(new String(H2hDoLength.h2hDoLength(bigBin.length)));
            result.append(new String(bigBin));
            result.append(new String(H2hDoLength.h2hDoLength(valueBin.length)));
            result.append(new String(valueBin));           
        }
        String resultString = "STRING(" + String.valueOf(result.length()) + "): " + result.toString();                
        return resultString;
    }
    
}
