import java.util.HashMap;
import java.util.Map;

public class Example2 {
    public static void main(String[] args) {
        int[] nums=new int[]{3,2,4};
        int target=6;
        int[] results=getSum(nums,target);
        System.out.println(results[0] +""+ results[1]);
    }

    private static int[] getSum(int[] nums, int target) {
        Map<Integer,Integer>CheckedNums=new HashMap<>();
        for(int i=0;i<nums.length;i++){
          int compliment=target-nums[i];
          if(CheckedNums.containsKey(compliment)){
              return new int[]{i,CheckedNums.get(compliment)};
          }
          CheckedNums.put(nums[i],i);
        }
        return new int[]{-1,-1};
    }
}
