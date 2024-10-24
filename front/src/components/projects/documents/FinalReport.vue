<template>
    <v-row class="ma-0 ">
        <v-col class="flex-col">
            <v-row class="flex-grow-0 align-self-center text-center py-5">
                ИТОГОВЫЙ ОТЧЕТ<br>
                по проекту/этапу проекта
            </v-row>
         
           
            <v-row>
                <v-col class="planks flex-col">
                    <table class="inmpline">
                        <tr>
                            <td class="font-weight-regular pa-2" style="width: 20%">Наименование проекта/этапа проекта</td>
                            <td class="font-weight-regular pa-2" style="width: 80%">
                                <v-textarea v-if="editable"
                                v-model="orderdock.longname"
                                rows="3"
                                placeholder="Наименование проекта в случае завершения всего проекта или наименование проекта и этапа проекта в случае завершения этапа проекта"
                            ></v-textarea>
                            <span v-else>{{orderdock.longname}}</span>
                            
                            </td>
                            
                        </tr>
                        <tr v-for="(x, i) in ['Директор', 'Руководитель']" :key="x" >
                            <td class="font-weight-regular pa-2" style="width: 20%">{{x}} проекта</td>
                            <td class="font-weight-regular pa-2" style="width: 80%">{{getProject.users.find(e=>e.role.id==i+1).user.fullname}}</td>
                        </tr>
                                                   
                    </table>
                </v-col>
            </v-row> 
    <div v-if="'result' in orderdock && orderdock.result.length>0">
            <h4 class="my-3">Достижение результатов проекта/этапа проекта</h4>
    <v-data-table
      :headers="result_headers"
      :items="orderdock.result"
      disable-pagination
      hide-default-footer
    >
      <template v-slot:[`item.index`]="{index}">
        {{index+1}}
       
      </template>
      
      <template v-slot:[`item.status`]="props">
        <v-select v-if="editable"
          :items="result_select"
          placeholder="Выберите..."
          dense
          :rules="[v=>!(v===null)||'Обязательно для заполнения']"
          v-model="props.item.status"
          @change="changeresult('result')"
        ></v-select>
         <div v-else>{{props.item.status}}</div>         
      
      </template>
       <template v-slot:[`item.comment`]="props">
        <v-textarea v-if="editable"
          rows="3"
          placeholder='Для статусов, отличающихся от "Получен", привести комментарий, объясняющий недостижение результата '
          dense
        
          v-model="props.item.comment"
        ></v-textarea>
         <div v-else>{{props.item.comment}}</div>         
      
      </template>
      <template v-slot:footer>
       
          <v-row>
            <v-col>Итого достигнуто результатов:</v-col>
            <v-col cols="3">
              <v-row v-if="editable && orderdock.result.filter(el=>el.status=='Получен частично').length>0">
               
                <v-col>
            
              <v-text-field
                        class="mt-0 pt-0"
                        v-model="orderdock.result_description.result.count"
                        dense
                        :rules="rules.resultrules"
                       
                        type="number"
                        
                      />
                       </v-col> 
                        <v-col
               >
                      <v-text-field
                      class="mt-0 pt-0"
                        v-model="orderdock.result_description.result.percent"
                        dense
                        :rules="rules.percentrules"
                        prefix="("
                        type="number"
                        suffix="%)"
                      />
                      </v-col>
                     
             </v-row>
             <span v-else>{{orderdock.result_description.result.count}}({{orderdock.result_description.result.percent}}%)</span>
              <!-- {{orderdock.result.filter(el=>el.status=="Получен").length}} 
              ({{100*orderdock.result.filter(el=>el.status=="Получен").length/orderdock.result.length}} %) -->
               </v-col>
            <v-col
           
            > 
          <v-textarea v-if="editable && orderdock.result.filter(el=>el.status=='Получен частично').length>0"
          rows="3"
          placeholder='В случае частичного получения некоторых результатов, необходимо привести комментарий, как вычислялось итоговое количество и процент'
          dense        
          v-model="orderdock.result_description.result.comment"
        ></v-textarea>
         <p v-else>{{orderdock.result_description.result.comment}}</p>    </v-col>


          </v-row>
            
       
      </template>


    </v-data-table>
    </div>
    <div v-if="'criteria' in orderdock && orderdock.criteria.length>0">
         <h4 class="my-3">Достижение качества результатов проекта/этапа проекта</h4>

         <v-data-table
      :headers="success_headers"
      :items="orderdock.criteria"
      disable-pagination
      hide-default-footer
    >
      <template v-slot:[`item.index`]="{index}">
        {{index+1}}
       
      </template>
      
      <template v-slot:[`item.status`]="props">
        <v-select v-if="editable"
          :items="success_select"
          placeholder="Выберите..."
          dense
           @change="changeresult('criteria')"
          :rules="[v=>!(v===null)||'Обязательно для заполнения']"
          v-model="props.item.status"          
          
        ></v-select>
         <div v-else>{{props.item.status}}</div>         
      
      </template>
       <template v-slot:[`item.comment`]="props">
        <v-textarea v-if="editable"
          rows="3"
          placeholder='Для статусов, отличающихся от "Достигнут", привести комментарий, объясняющий несоответствие критерию успеха '
          dense
        
          v-model="props.item.comment"
        ></v-textarea>
         <div v-else>{{props.item.comment}}</div>         
      
      </template>
      <template v-slot:footer>
       
          <v-row>
            <v-col>Итого достигнуто результатов:</v-col>
            <v-col cols="3">
              <v-row v-if="editable && orderdock.criteria.filter(el=>el.status=='Достигнут частично').length>0">
               
                <v-col>
            
              <v-text-field
                        class="mt-0 pt-0"
                        v-model="orderdock.result_description.criteria.count"
                        dense
                        :rules="rules.resultrules"
                       
                        type="number"
                        
                      />
                       </v-col> 
                        <v-col
               >
                      <v-text-field
                      class="mt-0 pt-0"
                        v-model="orderdock.result_description.criteria.percent"
                        dense
                        :rules="rules.percentrules"
                        prefix="("
                        type="number"
                        suffix="%)"
                      />
                      </v-col>
                     
             </v-row>
             <span v-else>{{orderdock.result_description.criteria.count}}({{orderdock.result_description.criteria.percent}}%)</span>
              <!-- {{orderdock.result.filter(el=>el.status=="Получен").length}} 
              ({{100*orderdock.result.filter(el=>el.status=="Получен").length/orderdock.result.length}} %) -->
               </v-col>
            <v-col
           
            > 
          <v-textarea v-if="editable && orderdock.criteria.filter(el=>el.status=='Достигнут частично').length>0"
          rows="3"
          placeholder='В случае частичного недостижения некоторых критериев успеха, необходимо привести комментарий, как вычислялось итоговое количество и процент'
          dense        
          v-model="orderdock.result_description.criteria.comment"
        ></v-textarea>
         <p v-else>{{orderdock.result_description.criteria.comment}}</p>    </v-col>


          </v-row>
            
       
      </template>
    </v-data-table>
    </div>

  <h4 class="my-3">Соблюдение сроков проекта/этапа проекта</h4>

     <v-simple-table>
    <template v-slot:default>
      <thead>
        <tr>
          <th class="text-left">
            Плановая длительность проекта/этапа проекта
          </th>
          <th class="text-left">
            Фактическая длительность проекта/этапа проекта
          </th>
          <th class="text-left">
            Отклонение
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>{{`${momentedDay(orderdock.datestart) } - ${momentedDay(orderdock.dateend)}/(${momentdiff(orderdock.datestart,orderdock.dateend)}д.)`}}</td>
          <td>
            <v-row>
                <v-col><v-menu 
            v-model="srokmenu[0]"
            :close-on-content-click="false"
            transition="scale-transition"
            offset-y
            min-width="auto"
            >
                <template
                    v-slot:activator="{on, attrs}"
                    
                >
                    <v-text-field
                        :readonly="!editable"
                        dense
                        :value="formatDate(orderdock.srok.fact.datestart)"            
                        type="date-local"              
                        placeholder="Факт начало"
                            flat
                            solo
                        @input="event=>orderdock.srok.fact.datestart=oninputnostore(event)"
                        v-bind="attrs"
                        hide-details
                        v-on="on"
                        class="ma-0 align-self-center"
                    >
                    </v-text-field>
                    
                </template>
                <v-date-picker
                  v-if="editable"
                    :first-day-of-week="1"
                                                        
                    v-model="orderdock.srok.fact.datestart"
                    
                >
            </v-date-picker>
            </v-menu>
            
            
            </v-col>
                <v-col>
<v-menu 
            v-model="srokmenu[1]"
            :close-on-content-click="false"
            transition="scale-transition"
            offset-y
            min-width="auto"
            >
                <template
                    v-slot:activator="{on, attrs}"
                    
                >
                    <v-text-field
                        :readonly="!editable"
                        dense
                        :value="formatDate(orderdock.srok.fact.dateend)"            
                        type="date-local"              
                        placeholder="Факт окончания"
                            flat
                            solo
                        @input="event=>orderdock.srok.fact.dateend=oninputnostore(event)"
                        v-bind="attrs"
                        hide-details
                        v-on="on"
                        class="ma-0 align-self-center"
                    >
                    </v-text-field>
                    
                </template>
                <v-date-picker
                  v-if="editable"
                    :first-day-of-week="1"
                                                        
                    v-model="orderdock.srok.fact.dateend"
                    
                >
            </v-date-picker>
            </v-menu>
            









                </v-col>

            </v-row>

            
            <span>({{momentdiff(orderdock.srok.fact.datestart,orderdock.srok.fact.dateend)}}д.)</span></td>
          <td>{{((momentdiff(orderdock.srok.fact.datestart,orderdock.srok.fact.dateend)-momentdiff(orderdock.datestart,orderdock.dateend))*100/momentdiff(orderdock.datestart,orderdock.dateend)).toFixed(2)}} %</td>
        
        
        
        
        
        
        
        
        
        
        
        </tr>
         <tr>
          <th colspan="3"> 
            Дополнительные комментарии к соблюдению сроков завершения проекта
         </th>          
        </tr>
         <tr>
          <td colspan="3"> 
            
             <v-textarea v-if="editable"
          rows="3"
          placeholder='Указать дополнительные комментарии к соблюдению сроков завершения проекта в случае необходимост, например, указав зафиксированные сроки начала и завершения проекта или причины отклонения'
          dense
        
          v-model="orderdock.srok.comment"
        ></v-textarea>
            
            
            
            </td>          
        </tr>
      </tbody>
    </template>
  </v-simple-table>
  








        </v-col>
    </v-row>
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import uf from '@/utils/universal_functions'
import moment from "moment";
import datepicker from "@/utils/datepiker.js"
const  projectstate =createNamespacedHelpers("projectstate");


export default {

name:"FinalReport",

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
    },
},
data(){
    return{
    srokmenu:[false,false],
    approvedtext:['_______________________', 'На утверждении', 'Отклонено', 'Утверждено'],
    rules:{resultrules: [val=> val<=this.orderdock.result.length||"Количество полуенных результатов не может превышать их количество в паспорте"   ,
                         val=>val>=0||"Количество полуенных результатов не может быть меньше 0"],
            percentrules: [val=> val>=0 && val<=100||"Процент должен быть между значениями 0 и 100"]
                        },
    approved: 0, 
   
    orderdock:{
            orderdate: moment().format("YYYY-MM-DD"),
            confirmation: "",
            ... this.getProject,  

            tabler:{docnumber:"", approvedtime:""},
            result:[],
            srok:{comment:"",fact:{datestart:"",dateend:""}}

    
    },
        result_select:["Получен","Не получен","Получен частично"],
        success_select:["Достигнут","Не достигнут","Достигнут частично"],
        result_headers: [
          { text: '№', align: 'start', sortable: false,  value: 'index'},
          { text: 'Запланированные результаты', value: 'name' },
          { text: 'Окончательный статус', value: 'status' },
           { text: 'Комментарий', value: 'comment' },
          
        ],
        success_headers: [
          { text: '№', align: 'start', sortable: false,  value: 'index'},
          { text: 'Установленные критерии успеха', value: 'name' },
          { text: 'Окончательный статус', value: 'status' },
           { text: 'Комментарий', value: 'comment' },
          
        ],
    
      }
    

    
},
mounted(){
    moment.locales('ru')    
    if ('id' in this.dialogdata){      
        this.approved=this.dialogdata.approved
        this.orderdock = this.dialogdata.vrersion
        // this.orderdock['tabler']={docnumber:this.dialogdata.docnumber, approvedtime:this.dialogdata.approvedtime}

        }
         else{
             this.orderdock={orderdate: moment().format("YYYY-MM-DD"),...JSON.parse(JSON.stringify(this.getProject)), docnumber:'',srok:{comment:"",fact:{datestart:this.getProject.datestart,
                                                                                                                                                              dateend:this.getProject.dateend}}}
            this.getresultobj()
        }
       
       
    },

watch:{
dialogdata: function(val, newval ){    
    console.log(val, newval,"CHANGED");
    if ('id' in val){
        
        this.orderdock = val.vrersion
        this.approver=val.approver
        this.approved=val.approved
        this.orderdock['tabler']={docnumber:val.docnumber}
    }
    else
    {
      
        this.approved=0
        this.orderdock={orderdate: moment().format("YYYY-MM-DD"),...JSON.parse(JSON.stringify(this.getProject)), docnumber:'',srok:{comment:"",fact:{datestart:this.getProject.datestart,
                                                                                                                                                              dateend:this.getProject.dateend}}}
            this.getresultobj()
                
    }
    
    }
}
,
computed:{
    ...projectstate.mapGetters(["getProject","getprojectuniquePersons"]),

},
methods:{
    momentdiff(datestart,dateend){
    return moment(dateend).diff(moment(datestart),'days')
    },
    changeresult(result='result'){
     let r = result=="result"?"Получен":"Достигнут"
      this.orderdock.result_description[result].count= this.orderdock[result].filter(el=>el.status==r).length
      this.orderdock.result_description[result].percent = 100*this.orderdock.result_description[result].count/this.orderdock[result].length
    },
    oninputnostore(val){
       
        try{
        let str=this.formatDateRev(val)
        console.log(str);
        const newdate=moment(str)
      
        if ((newdate.isValid())){   
              
                return str
           
            }
        }catch(e){
          console.log(e);
        }
        
      },
    // saveit(){
        
    //     this.editable=false
    //     this.$emit("saver",this.orderdock, false)
    // },
    obcleaner(){
      for (let x in this.orderdock){
          if (!['users','datestart','dateend','result','criteria','result_description', 'name','longname','info','srok'].includes(x)) delete this.orderdock[x]
          
        }
        for (let x in this.orderdock.info){
            if(!["criteria","result"].includes(x)) delete this.orderdock.info[x]
        }


    },
    getresultobj(){
            console.log("ORDERDOCK");
            console.log(this.orderdock);
            let criteria=[]
            let result=[]
            
            this.orderdock.result_description={result:{count:0,percent:0, comment:""},criteria:{count:0,percent:0, comment:""}}
            this.orderdock.info.result.forEach(el=>result.push({name:el, status:null,comment:"",index:result.length+1}))
            this.orderdock.info.criteria.forEach(el=>criteria.push({name:el, status:null,comment:"",index:criteria.length+1}))
            this.orderdock.result=result
            this.orderdock.criteria=criteria
            this.obcleaner()
            this.changeresult()
    },

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
    momentext (value) {
            if (value) {
                return moment(value).locale('Ru').format('DD MMMM YYYY')
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

.inpcent {
    text-align-last: center;
}

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

.inmpline textarea {
    text-align: center;
}
</style>