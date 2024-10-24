<template>

    <v-row class="ma-0 ">
        <v-col class="flex-col ">

                <!-- <v-row class="styck">
                    <v-col> -->
                        <!-- {{orderdock.tasks[0].planning}}<hr> -->
                         <!-- {{this.getProject.history.find(e=> e.action.id==7 && e.level==2 )}}<br> 
                         {{editable}}<br> -->
                         <!-- {{toptable[0].planning}} -->
                  
                    <!-- </v-col>
                </v-row>     -->
            <v-row class="align-self-center py-2">
                ФНС России 
            </v-row>
            <v-row class="flex-grow-0 align-self-center text-center py-2 font-weight-bold">
                {{orderdock.longname}} 
            </v-row>
            <v-row class="flex-grow-0 align-self-center text-center py-2">
                Отчет о статусе проекта <br>
                на 
                <!-- ! TODO нормальную дату степпер?????????? -->
                {{momentext(orderdock.orderdate)}}                
                 

            </v-row>
            <v-row class="flex-grow-0 align-self-center text-center pb-5 pt-2">
                Исполнение контрольных событий
            </v-row>
            <v-row class="flex-grow-0 pl-3" v-if="orderdock.tasks[0].length>0">
                
            </v-row>
            <report-top-table
            :editable="editable"
            disable-sort
            :headers="headerstop.headers"
            :toptable="orderdock.tasks[0]"
            @changepicker="changepicker"
            > Статус исполнения контрольных событий</report-top-table>
           
 <report-top-table
    class="mt-3"
    disable-sort
    :editable="editable"
            :headers="headerstop.headersprognoz"
            :toptable="orderdock.tasks[1]"
            @changepicker="changepicker"
            > Прогноз исполнения контрольных событий на ближайшие 3 месяца</report-top-table>   
  

<report-bot-table
                :editable="editable"
                :headers="headersbottom.headerRisk"
                :items="problemsrisks"
                @remove="remove"
                @addrows="addrows"
                >
                
                Прочие проблемы и риски
</report-bot-table>
<hr>

<!--//! НЕ ВЫБРАСЫВАТЬ -->
<!-- <v-card
 class="mt-3"
>
<v-card-title>
Ключевые результаты, не вошедшие в план
 <v-spacer/>
 <v-autocomplete
 solo
 :items="selectTasks"
 v-model="selectedtask"
 >


 </v-autocomplete>
</v-card-title>




</v-card> -->

<!-- //!НЕ ВЫБРАСЫВАТЬ -->
                <report-bot-table
                                :editable="editable"
                                :headers="headersbottom.headerPlanresult"
                                :items="planresult"
                                @addrows="addrowsKR"
                                @remove="removeKR"
                                
                                
                                >
                                Ключевые результаты, не вошедшие в план
                </report-bot-table>
                 
        </v-col>
      </v-row>
</template>

<script>

import { createNamespacedHelpers } from "vuex";
import moment from "moment";
import datepicker from "@/utils/datepiker.js"
import { axiosInstance } from '@/utils/api'
import reportBotTable from './parts/reportBotTable.vue';
import reportTopTable from './parts/reportTopTable.vue';
import uf from '@/utils/universal_functions'
const  projectstate =createNamespacedHelpers("projectstate");

export default {
  components: { reportTopTable,reportBotTable },
name:"Report",
mixins:[datepicker, uf],

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
        selectedtask:'',
        toptable:[],
        beforew: (elem)=> this.isbefore(elem.dateend) || elem.status.id==5,
        afterew:(elem)=>!this.isbefore(elem.dateend) && elem.status.id<5,
        lastdock:null,
        approvedtext:['_______________________', 'На утверждении', 'Отклонено', 'Утверждено'],
    flagnew: false,   
    approved: 0, 
    // search: '',
    // pickero:[],
    // picker:[],
    orderdock:{
            orderdate: moment().format("YYYY-MM-DD"),
            confirmation: "",
            name: "",
            datestart:'',
            dateend:"",    
            tasks:[[],[]],          
           
            problemsrisks: [],
            planresult: [],
            
        
    },



    

    problemsrisks: [],
    planresult: [],
    dialog: false,
    
        

    }
},
mounted(){
    // this.orderdock.tasks.forEach(el=>el.new={deteend:""})
    // this.orderdock.tasks.sort((a,b)=>(moment(a.deteend)>moment(b.deteend))?-1:((moment(b.deteend)>moment(a.deteend))?1:0))
    // При загрузке страницы если документ создался
    if ('id' in this.dialogdata){      
        this.approved=this.dialogdata.approved
        this.orderdock = this.dialogdata.vrersion
        
        this.orderdock.tasks.sort((a,b)=>(new Date(a.dateend)>new Date(b.dateend))?1:((new Date(b.dateend)>new Date(a.dateend))?-1:0))
        // console.log("ssss",new Date(this.orderdock.tasks[0].dateend)<new Date(this.orderdock.tasks[1].dateend) );
        
        // this.orderdock['tabler']={docnumber:this.dialogdata.docnumber, approvedtime:this.dialogdata.approvedtime}
        this.problemsrisks = this.orderdock.problemsrisks 
        this.planresult= this.orderdock.planresult
        // this.orderdock.tasks.forEach(el => {this.planresult.push(el.planresult)})
        this.flagnew = true
        // this.pickermaker()
        // this.toptablemaker()
        }
    else {
        console.log("ORDERDOCK");
        this.problemsrisks =[]
        
        this.orderdock= JSON.parse(JSON.stringify(this.getProject))
        this.orderdock.tasks.sort((a,b)=>(new Date(a.dateend)>new Date(b.dateend))?1:((new Date(b.dateend)>new Date(a.dateend))?-1:0))
        this.orderdock.orderdate=moment().format("YYYY-MM-DD")
        
        this.preparing()
        this.toptablemaker()
        this.obcleaner()
        // this.pickermaker()
        // this.buildnew()
    }
       
    },

watch:{

dialogdata: async function(val, newval ){    
    console.log(val, newval,"CHANGED");
    
    if ('id' in val){
        this.orderdock = val.vrersion
        this.problemsrisks=this.orderdock.problemsrisks
        this.planresult = this.orderdock.planresult
        this.approver=val.approver
        this.approved=val.approved
        // this.toptablemaker()
    }
    else
    {
       this.orderdock={}
        this.orderdock={orderdate: moment().format("YYYY-MM-DD"),...JSON.parse(JSON.stringify(this.getProject)), docnumber:''}
        this.orderdock.tasks.sort((a,b)=>(new Date(a.dateend)>new Date(b.dateend))?1:((new Date(b.dateend)>new Date(a.dateend))?-1:0))
        this.problemsrisks = [] 
        this.planresult= []
        
        this.preparing()
        this.toptablemaker()
        this.obcleaner()
       
        
        
                
    }
    
    }

},
computed:{
    ...projectstate.mapGetters(["getProject"]),
    planr(){
        return this.planresult.some((e)=>e.length>0)
    },
    selectTasks(){
        console.log(this.orderdock);
        return ['1']
    },
    headerstop(){
        return { headers: [
          {text: '№', align: 'start', value: 'keyy',cellClass:this.editable?'text--disabled':'',width:"5%" },
          { text: 'Блок/контрольное событие', value: 'name',cellClass:this.editable?'text--disabled':'' },
          { text: 'Плановый срок', value: 'dateend',cellClass:this.editable?'text--disabled':'',width:"9%" },
          { text: 'Факт/прогноз', value: 'planning',width:"9%" },
          { text: 'Ответсвенный', value: 'responsible',cellClass:this.editable?'text--disabled':'',width:"15%" },
          { text: 'Комментарий', value: 'comment',width:"40%" },
        ],    
        headersprognoz:[
         {text: '№', align: 'start', value: 'keyy',cellClass:this.editable?'text--disabled':'',width:"5%" },
          { text: 'Блок/контрольное событие', value: 'name',cellClass:this.editable?'text--disabled':'' },
          { text: 'Плановый срок', value: 'dateend',cellClass:this.editable?'text--disabled':'',width:"9%" },
          { text: 'Прогнозный срок', value: 'planning',width:"9%" },
          { text: 'Ответсвенный', value: 'responsible',cellClass:this.editable?'text--disabled':'',width:"15%" },
          { text: 'Комментарий', value: 'comment',width:"40%" },
        ],
        }
    },
    headersbottom(){
        let foredit = { text: 'Удаление', value: 'actions',width:"5%" }
        let headerRisk=[{text: '№', align: 'start', value: 'index',cellClass:this.editable?'text--disabled':'',width:"5%" },
                        { text: 'Наименование проблемы/риска', value: 'problem',cellClass:this.editable?'text--disabled':'',width:"45%" },
                        { text: 'Комментарий', value: 'comment',cellClass:this.editable?'text--disabled':'',width:"45%"  }]
          
        let headerPlanresult=[
            {text: '№', align: 'start', value: 'index',cellClass:this.editable?'text--disabled':'',width:"5%" },
              { text: 'Ключевые достигнутые результаты', value: 'problem',cellClass:this.editable?'text--disabled':'',width:"45%"  },
            { text: 'Ключевые запланированные результаты', value: 'comment',cellClass:this.editable?'text--disabled':'',width:"45%"  }]

         if(this.editable) {headerRisk.push(foredit)
                            headerPlanresult.push(foredit)
         }
           return {headerRisk, headerPlanresult}
    }
    

},

methods:{
    obcleaner(){
     this.orderdock = {longname:this.orderdock.longname,
                       tasks: this.orderdock.tasks,
                       orderdate:this.orderdock.orderdate}
       
       console.log("НОВЫЯ ШТУКА", this.orderdock);
    },


    preparing(){
        
        this.orderdock.tasks.forEach((el)=>{
            // this.planresult.push([])
        
            let comment = this.getProject.history.find(e=> e.action.id==7 && e.level==2 && e.work==null && e.task==el.id)
            console.log(comment);
                 comment=comment==undefined?{text:"Не предоставлен", datet:""}:{text:comment.comment, datet:comment.crerateddate,author:comment.author}
                el.comment = comment
                let planning = this.getProject.history.find(e=> e.action.id==4 && e.level==2 && e.work==null && e.task==el.id && e.info.status.id==5 && e.info.status.id==el.status.id)
            // console.log(planning, "planning",el.dateend);
                console.log(planning);
                  planning= planning===undefined?moment(el.dateend).isAfter()?el.dateend:undefined:planning.createdate.split(" ")[0]
                  
                el['planning']= planning
                console.log(el.planning,planning, "planning",el.dateend);
            el.task_work.forEach((n)=>{
          
                let wcomment =  this.getProject.history.find(e=> e.action.id==7 && e.level==3  && e.work==n.id)                
                
                wcomment=wcomment==undefined?{text:"Не предоставлен", datet:""}:{text:wcomment.comment, datet:wcomment.creratedate, author:wcomment.author}
                n.comment = wcomment
                let planningw = this.getProject.history.find(e=> e.action.id==4 && e.level==3 && e.work==n.id && e.task==el.id && e.info.status.id==5 && e.info.status.id==n.status.id)
                console.log(planningw,"planningw");
              
                planningw= planningw===undefined?moment(n.dateend).isAfter()?n.dateend:undefined:planningw.createdate.split(" ")[0]
                n.planning= planningw
            })



        } )
      
    },
    // orderdock.tasks.filter(el=>(!isbefore(el.dateend) && el.status.id<5 || el.task_work.some(afterew))).length>0
    toptablemaker(){
        let mixed = []
        let mixedprognoz=[]
        this.orderdock.tasks.filter(elem => ((this.isbefore(elem.dateend) || elem.status.id==5) || elem.task_work.some(this.beforew))).forEach(
            (ele,indx) => {
                            mixed.push({...ele,keyy:indx+1,picker:false}) 
                            ele.task_work.filter(el=>this.isbefore(el.dateend)||el.status.id==5).forEach(
                                (e,i)=> {
                                        mixed.push({...e,keyy:`${indx+1}.${i+1}`,picker:false})
                                }
                            )
            }
        )   
        this.orderdock.tasks.filter(elem => ((!this.isbefore(elem.dateend) && elem.status.id<5) || elem.task_work.some(this.afterew))).forEach(
            (ele,indx) => {
               
                            mixedprognoz.push({...ele,keyy:indx+1,picker:false}) 
                            ele.task_work.filter(el=>this.thremonth(el.dateend)&&el.status.id<5).forEach(
                                (e,i)=> {
                                        mixedprognoz.push({...e,keyy:`${indx+1}.${i+1}`,picker:false})
                                }
                            )
            }
        )   

        this.orderdock.tasks=[mixed,mixedprognoz]
    },
 
    changepicker(item){
        if('task_work' in item){
            let ind=this.orderdock.tasks.findIndex(e=>e.id==item.id)
            this.orderdock.tasks[ind].planning=item.planning
            for (let n=0;n<2;n++){
                 try{          
            this.toptable[n][this.toptable[n].findIndex(el=>el.id==item.id && "task_work" in el)].planning=item.planning}
            catch{
            }
            }        

        }
        else{
            let ind=this.orderdock.tasks.findIndex(e=>e.id==item.parent.id)
            let indw=this.orderdock.tasks[ind].task_work.findIndex(e=>e.id==item.id)
            this.orderdock.tasks[ind].task_work[indw].planning=item.planning
          
        }
    },

    remove(key){
        this.problemsrisks.splice(key,1)




    },

    removeKR(key){
        this.planresult.splice(key,1)
        // this.planresult[key].splice(k,1)
    },

    addrows() {     
            this.problemsrisks.push({problem:"",comment:""})
          },
    addrowsKR(){
         this.planresult.push({problem:"",comment:""})
        // console.log(this.orderdock.tasks[key].planresult.length)
        // this.planresult[key].push({noplanned:"", noplanned_result:""})
    },
    
    thremonth(d){
      return !this.isbefore(d) &&  moment().diff(moment(d),'days')<90

    },

    isbefore(d){
        
       return moment(d).isBefore()
    },

    position(ob){ 
        try{
            return ob.position.name
        }
        catch{
            return ""
        }
    },  
  

  
  


}
}
</script>
