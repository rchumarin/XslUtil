package factory;

import attachment.MyFilter;
import attachment.MyFilter1;
import attachment.Filter;

/**
 *
 * @author rchumarin
 */
public class Factory {
    
    public Filter getFilter(int num) {  
        
        if(num == 0) return new MyFilter();
    
        else if(num == 1) return new MyFilter1();
        
        else return null;
    }
    
}
