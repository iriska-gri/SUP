
import {axiosInstance} from '@/utils/api'
export  default  {
    methods:{
        async getFilters(settingsFilt){  
                      
            try {
                let res = await axiosInstance.post(
                "/filters/",
                settingsFilt
                );
            // if (role){
            //      console.log(res,"ress");
            // }
            return res
        }catch(e){
            console.log(e);
        }
        },
}
}