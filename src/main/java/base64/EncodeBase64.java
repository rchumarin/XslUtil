package base64;


import org.apache.commons.codec.binary.Base64;

/**
 *
 * @author rchumarin
 */
public class EncodeBase64 {
    public static byte[] encodeBase64(String encodeString) {        
        // Get bytes from string
        byte[] byteArray = Base64.encodeBase64(encodeString.getBytes());
        return byteArray;
    }
    
}
