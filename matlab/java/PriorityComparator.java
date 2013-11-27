import java.util.Comparator;

public class PriorityComparator implements java.util.Comparator<Object[]>
{
	public PriorityComparator() {}
	
    public int compare(Object[] obj1, Object[] obj2) {
    	Double cost1 = (Double) (obj1[0]);
    	Double cost2 = (Double) (obj2[0]);

    	return Double.compare(cost1, cost2);
    }
    
} // end of class