package main;

import xml.ModifyXml;
import factory.Factory;
import attachment.Filter;
import java.io.File;
import java.io.StringWriter;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import net.sf.saxon.TransformerFactoryImpl;


public class Main {
 
    public static void main(String[] args) {
        
        String
            xslFile = null,    
            xslPath = "./src/main/resources/curconversion.xsl",
            xslPath1 = "./src/main/resources/curconversion1.xsl",
            xmlPath="./src/main/resources/CURCONVERSION.xml"; 
        
        try {
            TransformerFactory fact = new TransformerFactoryImpl();
            
            //подставить xslPath или xslPath1
//            xslFile = xslPath1;
            xslFile = xslPath;
            
            Transformer transformer = fact.newTransformer(new StreamSource(new File(xslFile)));            
            StringWriter outWriter = new StringWriter();
            transformer.transform(new StreamSource(new File(xmlPath)), new StreamResult(outWriter));  
            
            StringBuffer sb = outWriter.getBuffer(); 
            String finalstring = sb.toString();                                        
            
            Factory factory = new Factory();
            Filter filter = null;
            if (xslFile.equals(xslPath)) {
                filter = factory.getFilter(0);
            }
            else if (xslFile.equals(xslPath1)) {
                filter = factory.getFilter(1);
            }

            String digestAttachment = filter.h2hDigestAttachment(finalstring);
            ModifyXml.modifyXml(finalstring, digestAttachment);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}




