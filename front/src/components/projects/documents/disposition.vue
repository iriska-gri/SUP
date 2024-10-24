<template>
<v-row class="ma-0 disposition">
    <v-col>
        <!-- <v-row class="styck">
            <v-col>
                 <pre>
                <br>{{orderdock.globaltasks}}
                </pre> 
            </v-col>
        </v-row> -->
        <v-row class="justify-space-between ma-0">
            <v-col xl=2 class=" pa-0">
                <v-menu
                    v-if="editable"
                    v-model="picker0"
                    :close-on-content-click="false"
                    transition="scale-transition"
                    offset-y
                    min-width="auto"
                >
                    <template
                        v-slot:activator="{on, attrs}"
                        class="ma-0 align-self-start "
                    >
                        <v-text-field
                            dense
                            :value="formatDate(orderdock.orderdate)"              
                            type="date-local"              
                            placeholder="дд.мм.гггг"
                            @input="event=>oninputnostore(event, ['orderdock','orderdate'], orderdock.datestart)"
                            v-bind="attrs"
                            hide-details
                            v-on="on"
                            class="pt-1 mb-2 inputext"
                        >
                        </v-text-field>
                    </template>
                    <v-date-picker
                        :first-day-of-week="1"                                         
                        v-model="orderdock.orderdate"
                        :max="orderdock.datestart"
                    >
                    </v-date-picker>
                </v-menu>
                <v-col class="text-nowrap px-0" v-else>
                    от {{momentext(orderdock.orderdate)}} года
                </v-col>
            </v-col>
            <v-col class="text-end">
                N
            </v-col>
            <v-col
                class="flex-grow-0 text-nowrap w-75 pa-0 align-self-center"
                xl=3
            >
                <v-text-field
                    v-if="editable"
                    v-model="orderdock.docnumber"
                    hide-details="auto"
                    dense
                >
                </v-text-field>
                    <span v-else>{{orderdock.docnumber}}</span>
            </v-col>
        </v-row>
        <v-row>
            <v-col class="text-center pa-0" :class="editable?'passiv_text--text':''">
                Об утверждении<br> Паспорта Проекта, плана контрольных событий Проекта и состава<br>Рабочей группы по реализации Проекта <br> "{{orderdock.longname}}"
            </v-col>
        </v-row>
        <v-row>
            <v-col class="px-0">
                <p class="test1 mb-0"
                :class="editable?'passiv_text--text':''"
                >
                    В целях контроля реализации направлений деятельности ФНС России в сфере   {{orderdock.info.project_sphere}}
                    
                </p>
            </v-col>
        </v-row>
        <v-row>
            <v-col class="px-0" :class="editable?'passiv_text--text':''">
                <p class="test1">
                    1. Утвердить:
                </p>
                <p class="test1">
                    Паспорт Проекта согласно приложению № 1 к настоящему распоряжению;
                </p>
                <p class="test1">
                    План контрольных событий Проекта согласно приложению № 2 к настоящему распоряжению;
                </p>
                <p class="test1">
                    состав Рабочей группы по реализации Проекта согласно приложению № 3 к настоящему распоряжению.
                </p>
                <p class="test1">
                    2. Контроль за исполнением настоящего распоряжения оставляю за собой.
                </p>
            </v-col>
        </v-row>
        <v-row class="mt-0" v-if="'approver' in orderdock">
            <v-col class="text-end pa-0" v-if="'approver' in orderdock">
                {{position(orderdock.approver)}} <br>{{initial(orderdock.approver)}}{{orderdock.approver.sn}}
            </v-col> 
            <v-col class="text-end pa-0" v-else>
                {{position(approver)}} <br>{{initial(approver)}}{{(approver&& 'sn' in approver)? approver.sn:""}}
            </v-col>
        </v-row>
        <v-row class="mt-5">
            <v-col class="text-end" :class="editable?'passiv_text--text':''">
                Приложение N 1
            </v-col>
        </v-row>
        <v-row class="flex-grow-0 align-self-end text-end pb-5 flex-col mt-4">
            <v-col class="pb-0" :class="editable?'passiv_text--text':''">
                {{approvedtext[approved].toUpperCase()}}
            </v-col>
            <v-col class="py-0" :class="editable?'passiv_text--text':''">
                распоряжением ФНС России
            </v-col>
            <v-col class="py-0" :class="editable?'passiv_text--text':''">
                от {{momentext(orderdock.orderdate)}} г.
            </v-col>
            <v-col class="py-0"
            :class="editable?'passiv_text--text':''"
            >
                N {{orderdock.docnumber=="" || orderdock.docnumber === null ?'__________________':orderdock.docnumber}}
            </v-col>
        </v-row>
        <v-row>
            <v-col class="text-center pa-0" :class="editable?'passiv_text--text':''">
                ПАСПОРТ проекта
            </v-col>
        </v-row>
        <v-row>
            <v-col class="pa-0">
                <p class="test1 mb-0 mt-2" :class="editable?'passiv_text--text':''">
                    ОСНОВНЫЕ ПОЛОЖЕНИЯ
                </p>
            </v-col>
        </v-row>
            <!-- --------------------------- Таблица ОСНОВНЫЕ ПОЛОЖЕНИЯ -->
        <v-row>
            <v-col class="planks flex-col">
                <table class="inmpline" v-if="generalposition.length>0">
                    <p-table v-for="(val,key) in generalposition" :key="key"
                    :dat="val"
                    :editable="editable"
                    >{{val.text}}</p-table>
                 
                </table>
            </v-col>
        </v-row>
        <v-row>
            <v-col class="pa-0">
                <p class="test1 mb-0 mt-2" :class="editable?'passiv_text--text':''">
                СОДЕРЖАНИЕ ПРОЕКТА
                </p>
            </v-col>
        </v-row>           
     <!-- --------------------------- Таблица СОДЕРЖАНИЕ ПРОЕКТА -->
        <v-row>
            <v-col class="planks flex-col">
                <table class="inmpline">
                     <p-table v-for="(val,key) in projectcontent" :key="key"
                    :dat="val"
                    :editable="editable"
                    >{{val.text}}</p-table>
               
                </table>
            </v-col>
        </v-row>
    <!-- --------------------------- Приложение 2 -->
        <v-row class="mt-10">
            <v-col class="text-end" :class="editable?'passiv_text--text':''">
                Приложение N 2
            </v-col>
        </v-row>
        <v-row class="flex-grow-0 align-self-end text-end pb-5 flex-col mt-4">
            <v-col class="pb-0" :class="editable?'passiv_text--text':''">
                {{approvedtext[approved].toUpperCase()}}
            </v-col>
            <v-col class="py-0" :class="editable?'passiv_text--text':''">
                распоряжением ФНС России
            </v-col>
            <v-col class="py-0" :class="editable?'passiv_text--text':''">
                от {{momentext(orderdock.orderdate)}} г.
            </v-col>
            <v-col class="py-0" :class="editable?'passiv_text--text':''">
                N {{orderdock.docnumber=="" || orderdock.docnumber === null ?'__________________':orderdock.docnumber}}
            </v-col>
        </v-row>

        <v-row>
            <v-col class="text-center pa-0" :class="editable?'passiv_text--text':''">
                План контрольных событий проекта
            </v-col>
        </v-row>
        <v-row>
            <v-col class="text-center" :class="editable?'passiv_text--text':''">
            
                    {{orderdock.longname && orderdock.longname.length>0?orderdock.longname:orderdock.name}}
              
            </v-col>
        </v-row>  
           <v-row>
            <v-col class="planks flex-col">
                <table class="inmpline" :class="editable?'passiv_text--text':''" >
                    <tr>
                        <td  class="font-weight-regular pa-2 w-7" >
                            №
                        </td>
                        <td class="font-weight-regular pa-2">
                            Наименование задачи/контрольного события 
                        </td>
                        <td class="font-weight-regular pa-2">
                            Ответственный исполнитель
                        </td>
                        <td class="font-weight-regular pa-2">
                            Дата решения/наступления контрольного события
                        </td>
                    </tr>
                    <tr>
                        <td v-for="i in 4" class="font-weight-regular pa-2" :key="i">
                            {{i}}
                        </td>
                       
                    </tr >
                     <tr v-for="(val,key) in taskworks" :key="key"  >
                        <td  class="font-weight-regular pa-2" :class="'task_work' in val?'font-weight-bold':''">
                            <!-- task_work -->

                           {{key+1}}
                        </td>
                        <td  class="font-weight-regular pa-2" :class="'task_work' in val?'font-weight-bold':''" >
                           {{val.longname  && val.longname.length>0?val.longname:val.name}}
                        </td>
                         <td  class="font-weight-regular pa-2" :class="'task_work' in val?'font-weight-bold':''" >
                            {{val.responsible.sn}}
                        </td>
                         <td  class="font-weight-regular pa-2" :class="'task_work' in val?'font-weight-bold':''" >
                          {{momentext(val.dateend)}}
                        </td> 
                                              
                    </tr>

                   
                </table>
            </v-col>
        </v-row> 
         <v-row class="mt-10">
            <v-col class="text-end"  :class="editable?'passiv_text--text':''" >
                Приложение N 3
            </v-col>
        </v-row>
        <v-row class="flex-grow-0 align-self-end text-end pb-5 flex-col mt-4">
            <v-col class="pb-0"  :class="editable?'passiv_text--text':''" >
                {{approvedtext[approved].toUpperCase()}}
            </v-col>
            <v-col class="py-0"  :class="editable?'passiv_text--text':''" >
                распоряжением ФНС России
            </v-col>
            <v-col class="py-0"  :class="editable?'passiv_text--text':''" >
                от {{momentext(orderdock.orderdate)}} г.
            </v-col>
            <v-col class="py-0"  :class="editable?'passiv_text--text':''" >
                N {{orderdock.docnumber=="" || orderdock.docnumber === null ?'__________________':orderdock.docnumber}}
            </v-col>
        </v-row>

        <v-row>
            <v-col class="text-center pa-0"  :class="editable?'passiv_text--text':''" >
                Состав рабочей группы по реализации проекта
            </v-col>
        </v-row>
        <v-row>
            <v-col class="text-center"  :class="editable?'passiv_text--text':''" >
            
                    {{orderdock.longname}}
              
            </v-col>
        </v-row>  
           <v-row>
            <v-col class="planks flex-col">
                <table class="inmpline"  :class="editable?'passiv_text--text':''" >
                    <tr>
                        <td  class="font-weight-regular pa-2 w-7">
                            №
                        </td>
                        <td class="font-weight-regular pa-2">
                            Наименование проектной роли 
                        </td>
                        <td class="font-weight-regular pa-2">
                            Процент загрузки на проекте
                        </td>
                        <td class="font-weight-regular pa-2">
                            ФИО должностного лица
                        </td>
                        <td class="font-weight-regular pa-2">
                            Наименование подразделения и должности
                        </td>
                    </tr>
                    
                     <tr v-for="(val,key) in sortedusers" :key="key">
                        <td  class="font-weight-regular pa-2" >
                            {{key+1}}
                        </td>
                        <td  class="font-weight-regular pa-2" >
                      
                            {{"role" in val ? val.role.name:''}}
                        </td>
                         <td  class="font-weight-regular pa-2" >
                       
                            {{val.percent}}
                            
                        
                        </td>
                         <td  class="font-weight-regular pa-2" >
                            {{"user" in val ?val.user.fullname:val}}
                        </td>
                        <td  class="font-weight-regular pa-2" v-if="'user' in val">
                            {{val.user.organization.name}}<br>{{val.user.department.name}}<br>{{val.user.otdel.name}}<br>{{val.user.position.name}}
                        </td>
                       <td v-else></td>
                    </tr>

                   
                </table>
            </v-col>
        </v-row> 


    </v-col>
    
</v-row >
</template>


<script>
import { createNamespacedHelpers } from "vuex";
import moment from "moment";
import datepicker from "@/utils/datepiker.js"
import { axiosInstance } from '@/utils/api'
import pTable from '@/components/projects/documents/parts/pTable';

const  projectstate =createNamespacedHelpers("projectstate");
export default {
  components: { pTable },
name:"disposition",
mixins:[datepicker],

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
        lastdock:null,
        approvedtext:['_______________________', 'На утверждении', 'Отклонено', 'Утверждено'],
    flagnew: false,   
    approved: 0, 
    picker0:false,
    picker:false,
    // roles:["Директор","Руководитель","Координатор","Секретарь"],
    involveeRules: [ 
                    
                    v => ( v && v > 0 ) || "Значение должно быть больше 0",
                    v => ( v && v <= 100 ) || "Значение должно быть меньше или равно 100",
                ],
    
    orderdock:{
            orderdate: moment().format("YYYY-MM-DD"),
            confirmation: "",
            // name: "",
            users:[{role:{id:0},user:{percent:0,organization:{name:""},department:{name:""},otdel:{name:""},position:{name:""}}}],
            info:{grounds:"",project_sphere:""},
            tasks:[],  
         
            
    },
    generalposition:[],
    projectcontent:[],
    
    dialog: false

    }
},
computed:{
    ...projectstate.mapGetters(["getProject","getprojectuniquePersons"]),
taskworks(){
    let odtw =[] 
    this.orderdock.tasks.forEach((el)=>{odtw.push(el); odtw.push(...el.task_work)})
 return odtw
},


sortedusers(){
    let u = this.orderdock.users
    let a = u.sort((a,b)=>(a.user.sn>b.user.sn)?1:((b.user.sn>a.user.sn)?-1:0))
    
    return a.sort((a,b)=>(a.role.id>b.role.id)?1:((b.role.id>a.role.id)?-1:0))
},
projectusersdepartments(){
    let u = this.orderdock.users.filter(el=>el.role.id==5)
    let deps = new Set()
    u.forEach(e=>deps.add(e.user.department))
    return Array.from(deps)
}
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
    this.buildtables()   
    },

watch:{

dialogdata: async function(val, newval ){    
    console.log(val, newval,"CHANGED");
    
    if ('id' in val){
        console.log("ИД ИН ВАЛ")
        this.orderdock =  val.vrersion
        // this.orderdock = "vrersion" in val? val.vrersion:{
        //                 orderdate: moment().format("YYYY-MM-DD"),
        //                 confirmation: "",
        //                 name: this.getProject.name,
        //                 datestart:this.getProject.datestart,
        //                 dateend:this.getProject.dateend,                        
        //                 users:this.getProject.users,
        //                 tasks:this.getProject.tasks,          
        //                 tabler:{docnumber:"", approvedtime:""},
        //                 workField:'',
        //                 grounds:[],
        //                 target:[],
        //                 resultat:[],
        //                 criteria:[],
        //                 risks:[],
        //                 influence:[],
        //                 interaction:[],
        //                 additional:[]
                    // }
        // console.log(val.vrersion,"VLVLV");
        // this.approver='approver' in val? val.approver:{}
        // this.orderdock['tabler']={docnumber:"docnumber" in val? val.docnumber:"tabler" in val.vrersion?val.vrersion.tabler.docnumber:"" }
        // this.approved=val.approved
        // this.orderdock['tabler']={docnumber:val.docnumber}
        this.flagnew = true
    }
    else
   {
        this.orderdock={orderdate: moment().format("YYYY-MM-DD"),...JSON.parse(JSON.stringify(this.getProject)), docnumber:''}
        this.obcleaner()
        console.log("НОВЫЯ ШТУКА", this.orderdock);
                this.buildtables()
    }   
    
    }

},


methods:{
    obcleaner(){
     for (let x of ["history","author","datachat","difficult", "project_files","status","project_checkpoint",]){
          
          delete this.orderdock[x]
        }
       
       console.log("НОВЫЯ ШТУКА", this.orderdock);
    },
    buildtables(){
        
        this.generalposition=[
                                {text:"Наименование проекта", data:this.orderdock.longname},
                                {text:"Краткое наименование проекта", data:this.orderdock.name},
                                {text:"Директор", data:this.findrole(1)},
                                {text:"Руководитель", data:this.findrole(2)},
                                {text:"Координатор", data:this.findrole(4)},
                                {text:"Секретарь", data:this.findrole(3)},
                                {text:"Участники", data:this.departmentfilter()}],
        this.projectcontent=[{text:"Основание для инициации проекта", data:this.orderdock.info.grounds},
        {text:"Цель (цели) проекта", data:this.orderdock.info.target},
        {text:"Задачи проекта", data:this.orderdock.tasks.map((e)=>{return e.name})},
        {text:"Результат (результаты) проекта", data:this.orderdock.info.result},
        {text:"Критерии успеха проекта", data:this.orderdock.info.criteria},
        {text:"Период реализации проекта", data:`${this.momentext(this.orderdock.datestart) } - ${ this.momentext(this.orderdock.dateend)}`},
        {text:"Риски реализации проекта", data:this.orderdock.info.risks},
        {text:"Влияние результата проекта", data:this.orderdock.info.influence},
          {text:"Взаимосвязи с другими проектами и программами", data:this.orderdock.info.interactions},
          {text:"Дополнительная информация", data:this.orderdock.info.dop_info},


        
        
        
        
        
        
        
        ]
    },
    addRows(row) {        
        this.orderdock[row].push('')
    },

    remove(rem, key) {
        this.orderdock[rem].splice(key, 1)
    },

    departmentfilter(){
        let deps = new Set()
        let users = this.orderdock.users.filter(e=>e.role.id==5)
        users.forEach(e=> deps.add(e.user.department.name))
        console.log(Array.from(deps),"DEPS");
        return Array.from(deps)

    },

    findrole(id){
        try{
        return this.orderdock.users.find(e=>e.role.id==id).user.fullname
        }
        catch(e){
            return "Не назначен"
        }
    },
    findpos(id){
          try{
        return this.orderdock.users.find(e=>e.role.id==id).user
        }
        catch(e){
            return ""
        }
    },



    

    getPersonShortFromId(it){
      let person={}
      this.getprojectuniquePersons.forEach(el => {if(el.id==it)person=el});
      let init = person.givenName.split(" ")
      return `${person.sn} ${init[0][0]}.${init[1][0]}.` 
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
        
      },

 

}
}
</script>

<style>
.test1 { text-indent: 25px; text-align: justify;}

.inpcent {
    text-align-last: center;
}
/* 
.planks table, .planks td, .planks th {
  border: 1px solid black;
}

.planks table {
  border-collapse: collapse;
  width: 100%;
}

.planks th {
  height: 10px;
} */

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

.styck {
    position: sticky;
    top: 0;
    max-height: 350px;
    overflow: auto!important;
    background: lightpink;
    z-index: 1000;
}

.disposition .inpcent, .disposition .inmpline textarea{
    text-align: left!important;
    text-align-last: left!important;
    
}

.disposition  .v-input__slot {
    padding: 0!important;
}

.wicon {
    max-width: 70%;
    
}

.self-end {
    align-items: self-end;
}
</style>
