<template>
<v-row class="ma-0">
   <v-col >
                <v-row class="styck">
                    <!-- <v-col>
                         {{orderdock}}
                         -----------------------
                         {{dialogdata}}
                         <br>
                    </v-col> -->
                </v-row>
<v-row class="justify-space-between ma-0">

   <v-col xl=2 class=" pa-0">
       <v-menu v-if="editable"
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

    <v-col class="text-nowrap px-0" v-else>от {{momentext(orderdock.orderdate)}} года</v-col>
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
   <v-col class="text-center pa-0"
   :class="editable?'passiv_text--text':''"
   >
      Об организации Проекта <br> "{{orderdock.longname}}"
   </v-col>
</v-row>
<v-row>
   <v-col class="px-0">
    <p class="" :class="editable?'passiv_text--text':''">
        В целях контроля реализации направлений деятельности ФНС России в сфере "{{orderdock.info.project_sphere}}", приказываю:
    </p>
   </v-col>
</v-row>
<v-row>
   <v-col class="px-0">
    <p class="" :class="editable?'passiv_text--text':''">
       1.Провести Проект "{{orderdock.longname}}"
    </p>
    
    <p class="" :class="editable?'passiv_text--text':''">
      2. Установить период проведения Проекта  {{momentext(orderdock.datestart)}} - {{momentext(orderdock.dateend)}}
    </p>
    <p class="" :class="editable?'passiv_text--text':''">
       3. Назначить директором Проекта  {{fullname(orderdock.users.find(e=>e.role.id==1) )}}
    </p>
    <p class="" :class="editable?'passiv_text--text':''">
     4. Назначить руководителем Проекта  {{fullname(orderdock.users.find(e=>e.role.id==2) )}}, координатором Проекта {{fullname(orderdock.users.find(e=>e.role.id==4)) }}
    </p>

     <p class="">
       5. Директору проекта утвердить паспорт проекта в срок не позднее 
        
        <v-menu
            v-if="editable"
            v-model="picker"
            :close-on-content-click="false"
            transition="scale-transition"
            offset-y
            min-width="auto"
        >
        <template
            v-slot:activator="{on, attrs}"
          
        >
            <v-text-field
                dense
                :value="formatDate(orderdock.info.passport_last_date)"              
                type="date-local"              
                placeholder="Введите дату утверждения паспорта"
               
               @input="event=>oninputnostore(event, ['orderdock','confirmation'], orderdock.datestart)"
                v-bind="attrs"
                hide-details
                v-on="on"
                class="pt-1 mb-2 inputext inpcent ma-0 align-self-start "
            >
            </v-text-field> 
            
         </template>
        <v-date-picker
            :first-day-of-week="1"                                         
            v-model="orderdock.info.passport_last_date"
            :min="getProject.datestart"
           
        >
        </v-date-picker>
       
    </v-menu>
    <span v-else>{{momentext(orderdock.info.passport_last_date)}}</span>

    </p>
    <p class="">
       6. Финансовое обеспечение расходных обязательств, связанных с реализацией настоящего приказа, осуществляется  {{orderdock.info.financial_support}}
    </p>
    
    <!-- <span class="text-center
" v-else>
     <v-textarea 
     v-model="orderdock.finance"
     auto-grow
     rows="1"
     dense
     placeholder="Введите финансовое обеспечение расходных обязательств"
     class="inputext inpcent"
    ></v-textarea>
    </span> -->
    <p class="">
      7. Контроль за исполнением настоящего приказа возложить на   
    <span v-if="!editable">{{'controller' in orderdock.info?orderdock.info.controller.fullname:""}}</span>
     <v-autocomplete v-else
            v-model="orderdock.info.controller"
            :items="getprojectuniquePersons"
            item-text="fullname"
            dense
            return-object
            class="inputext inpcent iconsh"
            placeholder="Выберите ответсвенное лицо"
          ></v-autocomplete>
           </p>
   </v-col>
</v-row>
<v-row class="mt-0">
    <v-col class="text-end pa-0" v-if="'approver' in orderdock">
      {{position(orderdock.approver)}} <br>{{initial(orderdock.approver)}}{{orderdock.approver.sn}}
   </v-col> 
   <v-col class="text-end pa-0" v-else>
      {{position(approver)}} <br>{{initial(approver)}}{{(approver&& 'sn' in approver)? approver.sn:""}}
   </v-col>
</v-row>
 </v-col>
</v-row >
  
<!-- <div>

    
<div>
 
</div>

<div>ОБ   </div>
<div></div>
 <div></div> 
 <div></div>
<div></div>
<div></div>
<v-row>
    <v-col
    cols=4
    ></v-col>
    <v-col
    cols=2
    > 


    <v-menu v-if="editable"
    v-model="picker"
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
                :value="formatDate(orderdock.confirmation)"              
                type="date-local"              
                placeholder="дд.мм.гггг"
               
               @input="event=>oninputnostore(event, ['orderdock','confirmation'], orderdock.datestart)"
                v-bind="attrs"
                hide-details
                v-on="on"
                class="pt-1 mb-2 inputext"
            >
            </v-text-field>
            
        </template>
        <v-date-picker
            :first-day-of-week="1"                                         
            v-model="orderdock.confirmation"
            :max="getProject.datestart"
           
        >
        </v-date-picker>
       
    </v-menu>
    <span v-else>{{momentext(orderdock.confirmation)}}</span>
               </v-col>
               </v-row>

    <v-row><v-col> </v-col></v-row>
       <v-row><v-col></v-col></v-row>
      

<v-row class="mt-2">
    <v-col v-if="editable">
        <v-btn
        @click="saveit"
        >Сохранить</v-btn></v-col> </v-row>
<v-row class="mt-2">
    <v-col>
<v-btn>Отправить на согласование</v-btn>
</v-col>
<v-col><v-btn>Отправить на утверждение</v-btn></v-col>
</v-row>
</div> -->
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import moment from "moment";


import datepicker from "@/utils/datepiker.js"
const  projectstate =createNamespacedHelpers("projectstate");
export default {
name:"Order",
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
    },
},
data(){
    return{
    
    picker0:false,
    picker:false,
    // orderdock:{}
    orderdock: {orderdate: moment().format("YYYY-MM-DD"),
                users:[{role:{id:0},user:{id:0, fullname:""}}],
                info:{docnumber:""}


    }
  
    

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
        console.log("ИД ИН ВАЛ")
        this.orderdock =  val.vrersion
    // if ( !(val.path===null)&& val.path.length){
    //     console.log(val.path);
    // }else{
    //      this.orderdock =  val.vrersion

    //         this.approver='approver' in val? val.approver:{}
    //         this.orderdock['tabler']={docnumber:"docnumber" in val? val.docnumber:"tabler" in val.vrersion?val.vrersion.tabler.docnumber:"" }
    // }  
   
    }
    else
    {
        
        this.orderdock={orderdate: moment().format("YYYY-MM-DD"),...JSON.parse(JSON.stringify(this.getProject)), docnumber:''}
        this.obcleaner()
        console.log("НОВЫЯ ШТУКА", this.orderdock);
       
     
        
            
   
    
    }
}
},

methods:{
    obcleaner(){
     for (let x of ["history","author","datachat","difficult", "project_files","status","tasks","project_checkpoint",]){
          
          delete this.orderdock[x]
        }
        for (let x in this.orderdock.info){
            if(["criteria","dop_info","grounds","influence","interactions","result","risks","target"].includes(x)) delete this.orderdock.info[x]


        }
       console.log("НОВЫЯ ШТУКА", this.orderdock);
    },
    // saveit(){
        
    //     this.editable=false
    //     this.$emit("saver",this.orderdock, false)
    // },
    fullname(ob){
        try{
        return `${ob.user.fullname}`}
        catch(e){
            console.log(e);
        }
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
/* . { text-indent: 25px; text-align: justify;} */

.inpcent {
    text-align-last: center;
}
</style>