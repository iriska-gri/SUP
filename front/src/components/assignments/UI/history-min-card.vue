<template>
  <div>
   
     <row-pirow 
                title="История:"
                 >
            <template #leftcol>
        
              {{history.slice(0,5).length>0 ?'':'История отсутсвует'}}
            </template>
            </row-pirow>
        <div v-if="history.slice(0,5).length>0">
                <v-row 
                    class="flex-grow-0 mt-0" 
                >
                    <v-col>
                        <v-simple-table dense>
                        <template v-slot:default>
                            
                        <tbody>
                            <tr
                                v-for="(elm,index) in history.slice(0,5)"
                                :key="index"
                                @click.stop="historydetail = true"
                                class="pointer"
                            >
                                <td
                                    width="12%"
                                    height="1%"
                                    class="px-0"
                                >
                                    {{ momentdatetime(elm.new.createdate) }}
                                </td>
                                   <td v-if="indx==0"
                                    width="30%"
                                    height="1%"
                                >   
                                    {{factordict[elm.new.level]}}<br>                           
                                    {{ elm.new.info.name}}
                                </td>
                                 <td
                                    width="15%"
                                    height="1%"
                                >
                                    {{ elm.new.author.sn }}
                                </td>
                                <td
                                    width="20%"
                                    height="1%"
                                >
                                    {{ elm.new.action.name }}
                                </td>
                                <td
                                    
                                    id="td_history"
                                    height="1%"
                                >
                                    <v-textarea
                                        id ="something"
                                        class="unip"
                                        background-color="transparent"
                                        readonly
                                        hide-details
                                        auto-grow
                                        rows="1"
                                        solo
                                        flat
                                        :value="elm.new.comment"
                                    /> 
                                   
                                </td>
                              
                            </tr>
                        </tbody>
                        </template>
                        </v-simple-table>
                    </v-col>
                </v-row> 


</div>

  <v-dialog
      v-model="historydetail"
      
    >
      <v-card>
        <v-card-title class="text-h5">
          История {{todo.name}}
        </v-card-title>

        <v-card-text>
          <v-row v-for="x in history" :key="x.id">
          <v-col
          cols="2"
          >
          {{momentdatetime(x.new.createdate)}}
          </v-col>
          <v-col v-if="indx==0">
            {{factordict[x.new.level]}}:<br>
            <strong>{{x.new.info.name}}</strong>
          
          </v-col>
          <v-col>
            <span 
            class="pointer"
            @click="showuserinfo(x.new.author.id)">{{x.new.author.sn}}</span>
           
          </v-col>
          <v-col>
            {{x.new.action.name}}
           
          </v-col>
          <v-col>
            <div v-for="[k,v] of Object.entries(x.new.info)" :key="k">
             
              <div v-if="['status'].includes(k) && x.old!=undefined && v.id!=x.old.info[k].id">{{dictoffields[k]}}:{{x.old.info[k].name}} <v-icon color="btns" x-small>mdi-arrow-right</v-icon>{{v.name}}</div>
              <div v-else-if="['status'].includes(k) && x.old==undefined">{{dictoffields[k]}}: <v-icon color="btns" x-small>mdi-plus</v-icon> {{v==null?'НЕ СУЩЕСТВУЕТ':v.name}}</div>

              <div             
                v-else-if="['responsible'].includes(k) && x.old!=undefined  && v.id!=x.old.info[k].id ">{{dictoffields[k]}}:<span class="pointer" @click="showuserinfo(x.old.info[k].id)">{{x.old.info[k].sn}} </span>
               <v-icon color="btns" x-small>mdi-arrow-right</v-icon>
                <span class="pointer"  @click="showuserinfo(v.id)">{{v.sn}}
                </span>
              </div>
               <div             
              v-else-if="['responsible'].includes(k) && x.old==undefined ">{{dictoffields[k]}}:<v-icon color="btns" x-small>mdi-plus</v-icon><span class="pointer"  @click="showuserinfo(v.id)">{{v.sn}}</span>
              </div>
              <div             
              v-else-if="['datestart', 'dateend'].includes(k) && x.old!=undefined && v!=x.old.info[k]">{{dictoffields[k]}}:{{momentedDay(x.old.info[k])}}  <v-icon color="btns" x-small>mdi-arrow-right</v-icon> {{momentedDay(v)}}
              </div>
              <div             
              v-else-if="['datestart', 'dateend'].includes(k) && x.old==undefined ">{{dictoffields[k]}}: <v-icon color="btns" x-small>mdi-plus</v-icon> {{momentedDay(v)}}
              </div>
           
              <div
              v-else-if="(typeof v=='string'||typeof v=='number') && x.old!=undefined && v!=x.old.info[k]"
              >{{dictoffields[k]}}: {{x.old.info[k]}} <v-icon color="btns" x-small>mdi-arrow-right</v-icon>{{v}}</div>
              <div
              v-else-if="(typeof v=='string'||typeof v=='number') && x.old==undefined"
              >{{dictoffields[k]}}: <v-icon color="btns" x-small>mdi-plus</v-icon>{{v}}</div>

              <!-- <div v-else>{{k}}{{v}} {{typeof v=='string'}}{{x.old!=undefined}}{{v!=x.old.info[k]}}</div> -->
         </div>
           
          </v-col>
          
           <v-col>
            {{x.new.comment}}
           
          </v-col>
          
           
          </v-row>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>

         

          <v-btn
            color="green darken-1"
            text
            @click="historydetail = false"
          >
            Закрыть
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog> 





</div>
</template>

<script>

import { createNamespacedHelpers } from "vuex";
import moment from "moment";
import uf from '@/utils/universal_functions'
import rowPirow from '@/components/carddetails/pattern/row-pirow.vue';
const { mapGetters } = createNamespacedHelpers("auth");
const workstate = createNamespacedHelpers("workstate");
const taskstate= createNamespacedHelpers("taskstate")
const  projectstate =createNamespacedHelpers("projectstate");
export default {
name:"history-min-card",
        mixins:[uf],
        components:{        
        rowPirow     
  
    },
    props:{
        level:{
            type:Number,
            default:1
        },
        indx:{
            type:Number,
            default:0
        }
    },
    data()
    {return{
        todo:{},
        historydetail:false,        
        factordict:["","Проект","Задача","Работа","Поручение"],
        level_helper:[{},
          {text:"Проект",store:"getProject"},
           {text:"Задача",store:"gettasks"},
            {text:"Работа",store:"getworks"},
             {text:"Поручение",store:"getworks"}


        ],
        dictoffields:{
                      'longname':"Название",
                      "name":"Краткое название",
                      "responsible":"Ответственный",
                      'datestart':"Начало",
                      'dateend': 'Окончание',
                      'description': 'Описание',
                     'status':"Статус",
                    'filepath':"Загружен",
                    'filedel':"Удален",
                    'iditit': "Результат",
                    'difficult':'Сложность'
                }

    }

    },
    mounted(){
      moment.locale("ru")
        console.log(this.gettasks,"TATATASKS")
    },
    computed: {
    ...mapGetters(["getUser", ]),
    ...workstate.mapGetters(['getworks']),
    ...projectstate.mapGetters(['allpersons','getProject']),
    ...taskstate.mapGetters(['gettasks']),

    history(){
      
      let unworked_history = []
        if (this.level==4){
          this.todo = this.getworks.work_assignment[this.indx-1]
          this.todo.history= this.getworks.history.filter(e=> e.level==4 && e.assignment==this.getworks.work_assignment[this.indx-1].id)
        }else{    
        this.todo = this[this.level_helper[this.level].store]
        
        }
        return this.historydetailer()

      },
    
    
    
    
    
    
    },
    methods:{
        historydetailer(){
          
      let h_detalization=[]
      let arrfactor=['','project','task','work','assignment']      
      
      // this.todo.history.forEach((e,index)=> {
      //   let formfactor='project'
      //   let level=1
      //   for (let x in arrfactor){ 
      //     if (Object.is(e[arrfactor],null))  {
      //       break
      //     }         
      //     else if (!Object.is(e[arrfactor[x]],null) && 'name' in e[arrfactor[x]] && (!Object.is(e[arrfactor[x]].name,null))) {
      //       formfactor=arrfactor[x] 
      //       level = Number(x)+2
      //     }

        
      //   }
      //   e.formfactor=formfactor
      //   e.level=level})

      this.todo.history.forEach((e,index)=> {
       
        let h_ob = {new:e, old: this.todo.history.slice(index+1).find((el=>e.level==el.level && el[arrfactor[el.level]]===e[arrfactor[e.level]]))}
    
        h_detalization.push(h_ob)
    })
    console.log(h_detalization,"DETAL");
     return h_detalization



    },
      momentdatetime(datetime){
        return moment(datetime).format("HH:mm DD.MM.YYYY"); 
      },
      showuserinfo(id){
        this.$emit("showuserinfo",id)
      }
    }

}

</script>

<style>

</style>