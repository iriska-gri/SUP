import uf from '@/utils/universal_functions'
import { createNamespacedHelpers } from "vuex";
const  projectstate=createNamespacedHelpers("projectstate");

export  default  {

    title:"ui",

    mixins:[uf],
  
    computed: {
        ...projectstate.mapGetters(['allpersons']), 

        checkALL() {
          return true
          },

    },

    methods:{
        searchid(id) {
            try{
                return this.allpersons.find(t=>t.role.id===id).user.id
            }
            catch{
                return 0
            }
        },

        respons(id) {
            let role = this.searchid(id) 
            if (role>0){
            let dir = this.searchUserFullName(role, this.allpersons)
            return dir}
            
                return 0
            
        },

        exhibitor(id) {
            let only = this.allpersons.filter(t=>t.role.id === id)
            return only
          },

        //   userssearch(id) {
        //     return this.respons(id)
           
        //   },
    }

}