package attachment;

/**
 *
 * @author rchumarin
 */
public class H2hDoLength {
    
    public static byte[] h2hDoLength(int len) {
        byte[] bar = new byte[4];
        bar[0] = (byte) (len & 0x000000FF);
//        System.out.println(String.format("%02X ",len & 0x000000FF));
        bar[1] = (byte) ((len & 0x0000FF00) >> 8);
//        System.out.println(String.format("%02X ",(len & 0x0000FF00)>>8));
        bar[2] = (byte) ((len & 0x00FF0000) >> 16);
//        System.out.println(String.format("%02X ",len & 0x00FF0000>>16));
        bar[3] = (byte) ((len & 0xFF000000) >> 24);
//        System.out.println(String.format("%02X ",len & 0xFF000000>>24));
        //return DatatypeConverter.printHexBinary(bar);
        return bar;
    }
    
}
