<template>

    <v-row class="ma-0 ">
        <v-col class="flex-col">
            <v-row class="flex-grow-0 align-self-center py-5">
                ПЛАН-ГРАФИК ПРОЕКТА
            </v-row>
            <v-row class="flex-grow-0 align-self-end text-end pb-5 flex-col">
                <v-col class="pb-0">
                    {{approvedtext[approved].toUpperCase()}}
                </v-col>
                <v-col class="text-end py-0" v-if="'approver' in orderdock">
                    {{position(orderdock.approver)}} <br>{{initial(orderdock.approver)}}{{orderdock.approver.sn}}
                    
                </v-col> 
                <v-col class="text-end py-0" v-else>
                    {{(approver&& 'sn' in approver)?position(approver):"_______________________"}} <br>{{initial(approver)}}{{(approver&& 'sn' in approver)?approver.sn:"_______________________"}}
                </v-col>               
                <v-col class="py-0" v-if="orderdock.orderdate">
                    от {{momentext(orderdock.orderdate, format="DD MMMM YYYY")}} г.
                </v-col>
            </v-row>
            <v-row>
        <v-col class="planks flex-col">
<v-simple-table>
    <template v-slot:default>
    <tr >
        <th colspan="9" class="pa-1 text-center">
            {{orderdock.longname}}
            </th>
    </tr>
  <tr>

    <th rowspan="2" class=" pa-2" style="width: 3%">N п/п</th>
    <th rowspan="2" class=" pa-2" style="width: 15%">Наименование задачи/контрольного события</th>
    <th rowspan="2" class=" pa-2" style="width: 8%">Ответсвенный исполнитель</th>
    <th rowspan="2" class="pa-2" style="width: 25%;">Ожидаемый результат реализации мероприятия</th>
    <th rowspan="2" class="pa-2" style="width: 7%">Начало</th>
    <th rowspan="2" class=" pa-2" style="width: 7%">Окончание</th>
    <th colspan="2" class=" pa-2" style="width: 10%">Объем ресурсного обеспечения</th>
    <th rowspan="2" class="pa-2">Примечание</th>
  </tr>
  <tr>
    <td class="text-center  pa-1">единица измерения</td>
    <td class=" text-center pa-1">значение</td>
  </tr>
  <tr>
    <th class="font-weight-regular pa-1"></th>
    <th v-for="x in 8" :key="x" class="font-weight-regular pa-1">{{x+1}}</th>
   
  </tr>

  <tbody  v-for="(val, key) in orderdock.tasks" :key="key">
    <tr  >
        <td class="text-center">{{key+1}}</td>
        <td class="font-weight-bold pa-1" > {{val.name}} </td>
        <td class="r pa-1"> {{getPersonShortFromId(val.responsible.id)}}</td>
    
    <td
      
    >
    
        <v-textarea 
            
            v-model="orderdock.tasks[key].expected_result"
            auto-grow
            rows=1
            dense
            :readonly="!editable "
            flat
            solo
            hide-details
            :placeholder="editable?'<Документ>':''"
            class="text-center "
        ></v-textarea>


        </td>
        <td class="pa-1 text-center">{{momentext(val.datestart)}}</td>
        <td class="pa-1 text-center">{{momentext(val.dateend)}}</td>
        <td class="pa-1">          
                <v-textarea 
                    v-model="orderdock.tasks[key].unit_measurement"
                    auto-grow
                    rows=1
                    dense
                    :readonly="!editable "
                    flat
                    solo
                    hide-details
                    :placeholder="editable?'...':''"
                    class="text-center"
                ></v-textarea>
          
        </td>
        <td>
          
                <v-textarea 
                    v-model="orderdock.tasks[key].meaning"
                    auto-grow
                    rows=1
                    dense
                    :readonly="!editable "
                    flat
                    solo
                    hide-details
                    :placeholder="editable?'...':''"
                    class="text-center"
                ></v-textarea>
          
        </td>
        <td>
            <v-textarea 
                v-model="orderdock.tasks[key].remark"
                auto-grow
                rows=1
                dense
                :readonly="!editable "
                flat
                solo
                hide-details
                :placeholder="editable?'...':''"
                class="text-center"
               
        ></v-textarea>
        </td>
    </tr>

    <tr v-for="(i, k) in val.task_work" :key="k" >
        <td class="px-1">{{key+1}}.{{k+1}}</td>
        <td class="pa-1">{{i.name}}</td>
        <td class="pa-1">{{getPersonShortFromId(i.responsible.id)}}</td>
        <td
        >
       
            <v-textarea 
                v-model="orderdock.tasks[key].task_work[k].expected_result"
                auto-grow
                rows=1
                dense
                :readonly="!editable "
                flat
                solo
                hide-details
                :placeholder="editable?'<Документ>':''"
                class="text-center"
            ></v-textarea>
       

        </td>
        <td class="pa-1 text-center">{{momentext(i.datestart)}}</td>
        <td class="pa-1 text-center">{{momentext(i.dateend)}}</td>
        <td class="pa-1" style="max-width: 0px">
            
                <v-textarea 
                    v-model="orderdock.tasks[key].task_work[k].unit_measurement"
                    auto-grow
                    rows=1
                    dense
                    :readonly="!editable "
                    flat
                    solo
                    hide-details
                    :placeholder="editable?'...':''"
                    class="text-center"
                ></v-textarea>
       
        </td>
        <td>
          
                <v-textarea 
                    v-model="orderdock.tasks[key].task_work[k].meaning"
                    auto-grow
                    rows=1
                    dense
                    :readonly="!editable "
                    flat
                    solo
                    hide-details
                    :placeholder="editable?'...':''"
                    class="text-center"
                ></v-textarea>
          
        </td>
        <td>
            <v-textarea 
                v-model="orderdock.tasks[key].task_work[k].remark"
                auto-grow
                rows=1
                dense
                :readonly="!editable "
                flat
                solo
                hide-details
                :placeholder="editable?'...':''"
                class="text-center"
            ></v-textarea>
        </td>
    </tr>
   
 
    </tbody>
    </template>
</v-simple-table>
</v-col>
    </v-row>
   </v-col>
</v-row>
                
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import moment from "moment";
import datepicker from "@/utils/datepiker.js"
const  projectstate =createNamespacedHelpers("projectstate");
import uf from '@/utils/universal_functions'
export default {
name:"Planks",
mixins:[uf,datepicker,],
props:{
    editable: {
        type:Boolean,
        default:false},
        
    dialogdata:{
        type: Object,
        default:()=>{return{}}
    },
    approver:{
        type: Object,
        default:()=>{return {position:{name:""}}}
    }
},
data(){
    return{

    approvedtext:['_______________________', 'На утверждении', 'Отклонено', 'Утверждено'],
    approved: 0, 
    picker0:false,
    picker:false,
    orderdock:{
            orderdate: moment().format("YYYY-MM-DD"),
           ...this.getProject


    },
    headers:[],
    

    }
},
computed:{
...projectstate.mapGetters(["getProject","getprojectuniquePersons"]),
},
mounted(){
    this.orderdock= JSON.parse(JSON.stringify(this.getProject))
    this.orderdock.orderdate=moment().format("YYYY-MM-DD")
    if (!("docnumber" in this.orderdock.info)){
        this.orderdock.docnumber = ""
    }


    if ('id' in this.dialogdata){        
       
        this.orderdock = this.dialogdata.vrersion
        
        

        }
    this.obcleaner()
       
    },
watch:{
dialogdata: function(val, newval ){    
    console.log(val, newval,"CHANGED");
    if ('id' in val){
        console.log("!!!!!!!!!!!!!!");
        this.orderdock = val.vrersion
        this.approver=val.approver
        this.approved=val.approved
       
    }
    else
    {
        this.approved=0
         this.orderdock={orderdate: moment().format("YYYY-MM-DD"),...JSON.parse(JSON.stringify(this.getProject)), docnumber:''}
        this.obcleaner()
        console.log("НОВЫЯ ШТУКА", this.orderdock);
            // orderdate: moment().format("YYYY-MM-DD"),
            // confirmation: "",
            // name: this.getProject.name,
            // datestart:this.getProject.datestart,
            // dateend:this.getProject.dateend,    
            // tasks:this.getProject.tasks,          
            // tabler:{docnumber:"", approvedtime:""}
                
    // }
    
    }
}
},

methods:{
    obcleaner(){
     this.orderdock = {longname:this.orderdock.longname,
                       tasks: this.orderdock.tasks,
                       orderdate:this.orderdock.orderdate}
       
       console.log("НОВЫЯ ШТУКА", this.orderdock);
    },
    
    // saveit(){
        
    //     this.editable=false
    //     this.$emit("saver",this.orderdock, false)
    // },
    // getPersonShortFromId(it){
    //   let person={}
    //   this.getprojectuniquePersons.forEach(el => {if(el.id==it)person=el});
    //   let init = person.givenName.split(" ")
    //   return `${person.sn} ${init[0][0]}.${init[1][0]}.` 
    // },

    position(ob){ 
        try{
            return ob.position.name
        }
        catch{
            return ""
        }
    },
    initial(ob){
        try{
        let init = ob.givenName.split(" ")
        return `${init[0][0]}.${init[1][0]}. `}
        catch {
            return ""
        }
    },
    momentext (value, format="DD.MM.YYYY") {
            if (value) {
                return moment(value).locale('Ru').format(format)
            }
        },

  
     
      oninputnostore(val,value,max){
        // console.log(min,max);
        // console.log(storiter,"storiter");
        let minmax = false
        if (max.length) {
          minmax = true
         
          max = moment(max)
        }
       
        
        try{
        let str=this.formatDateRev(val)
        const newdate=moment(str)
      
        if ((newdate.isValid()) && minmax){
      
           if (newdate<=max){
              
                this[value[0]][value[1]]=str
           }

        }
        else if(newdate.isValid() && (!minmax))
              { this[value[0]][value[1]]=str}
        }catch(e){
          console.log(e);
        }
        
      }

}
}
</script>

<style>
.test1 { text-indent: 25px; text-align: justify;}



.planks table, .planks td, .planks th {
  border: 1px solid black;
}

.planks table {
  border-collapse: collapse;
  width: 100%;
}

.planks th {
  height: 10px;
}

.bt1, .bt2 {
    border-left: 0px!important;
    border-right: 0px!important; 
    border-bottom: 0px solid black!important;
}

.bt2 {
    border-left: 1px solid black!important;
}

/* table {
    table-layout: fixed;
 
}*/
/* tr {
    word-wrap:break-word;
}  */
/* table.fixed { table-layout:fixed; width: 100%; }
table.fixed td { overflow: hidden; } */

/* .inmpline .v-textarea textarea {
    line-height: 1.5rem!important;
} */

</style>