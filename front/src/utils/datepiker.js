
import moment from "moment";
import { createNamespacedHelpers } from "vuex";
const  projectstate =createNamespacedHelpers("projectstate");
const taskstate = createNamespacedHelpers("taskstate");
const workstate = createNamespacedHelpers("workstate");
export  default  {

    methods:{
      ...workstate.mapMutations(["setWorkdatestart","setWorkdateend"]),
      ...taskstate.mapMutations(["setTaskdatestart","setTaskdateend"]),
      ...projectstate.mapMutations(["setProjectdatestart","setProjectdateend"]),

    
      
    formatDate (date) {
    try {
 
            if (!date) return null
            if (date.split('-').length==3){
            const [year, month, day] = date.split('-')
            return `${day}.${month}.${year}`
            }
        }
    catch{return date}
        
      },
formatDateRev (date) {
                    
                   
                    if (!date) return null
                    const [day, month, year] = date.split('.')
                    if (date.split('.').length==3){
                    return `${year}-${month}-${day}`
                    }
                },

    









      oninput(val,value,storiter,min,max){
        console.log(min,max);
        console.log(storiter,"storiter");
        let minmax = false
        if (min.length) {
          minmax = true
          min = moment(min)
          max = moment(max)
        }
       
        
        try{
        let str=this.formatDateRev(val)
        const newdate=moment(str)
      
        if ((newdate.isValid()) && minmax){
      
           if (newdate>=min && newdate<=max){
              console.log("???");
                this[`set${storiter}`](str)
           }

        }
        else if(newdate.isValid() && (!minmax))
              { this[`set${storiter}`](str)}
        }catch(e){
          console.log(e);
        }
        
      },



    },

}