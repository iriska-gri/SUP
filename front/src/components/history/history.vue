<template>
<v-row class="rounded-sm">
    <v-col class="flex-col d-flex main_theme  ma-2">
        <v-row class="h-0  overflow-auto">
            <v-col>
                  <v-card>
         <v-card-text>
          <v-row v-for="x in historydetailer" :key="x.id">
          <v-col
          cols="2"
          >
          {{momentdatetime(x.new.createdate)}}
          </v-col>
          <v-col v-if="indx==0">
            {{factordict[x.new.formfactor]}}:<br>
            <strong>{{x.new[x.new.formfactor].name}}</strong>
          
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
              <div v-else-if="['status'].includes(k) && x.old==undefined">{{dictoffields[k]}}: <v-icon color="btns" x-small>mdi-plus</v-icon>  {{v==null?'НЕ СУЩЕСТВУЕТ':v.name}}</div>

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
              v-else-if="typeof v=='string' && x.old!=undefined && v!=x.old.info[k]"
              >{{dictoffields[k]}}: {{x.old.info[k]}} <v-icon color="btns" x-small>mdi-arrow-right</v-icon>{{v}}</div>
              <div
              v-else-if="typeof v=='string' && x.old==undefined"
              >{{dictoffields[k]}}: <v-icon color="btns" x-small>mdi-plus</v-icon>{{v}}</div>

         
         </div>
           
          </v-col>
          
           <v-col>
            {{x.new.comment}}
           
          </v-col>
          
           
          </v-row>
        </v-card-text>
        </v-card>
            </v-col>
        </v-row>
    </v-col>
</v-row>
 
</template>

<script>
import uf from '@/utils/universal_functions'
import { createNamespacedHelpers } from "vuex";
import moment from 'moment';
import {axiosInstance} from '@/utils/api';

const projectstate = createNamespacedHelpers("projectstate");
export default {
   mixins:[uf],
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
  
    methods: {
        formatDate (value) {
            if (value) {
                return moment(value).locale('Ru').format('HH:mm DD MMMM YYYY')
            }
        },
          momentdatetime(datetime){
        return moment(datetime).format("HH:mm DD.MM.YYYY"); 
      },
        
        
        
        
        
        },
      

    data: () =>({
         historydetail:false,        
        factordict:{project:"Проект",task:"Задача",work:"Работа",assignment: "Поручение"},
        level_helper:[{},
          {text:"Проект",store:"getProject"},
           {text:"Задача",store:"gettasks"},
            {text:"Работа",store:"getworks"},
             {text:"Поручение",store:"getworks"}


        ],
        dictoffields:{"name":"Название",
                      "responsible":"Ответственный",
                      'datestart':"Начало",
                      'dateend': 'Окончание',
                      'description': 'Описание',
                     'status':"Статус",
                    'filepath':"Загружен",
                    'filedel':"Удален",
                    'iditit': "Результат"
                }

        // header:[
        //     {text:'Время/Дата', value: 'createdate'},
        //     {text:'Автор', value: 'author.sn'},
        //     {text:'Действие', value: 'info'}
        // ],
    }),
    computed:{
        ...projectstate.mapGetters(["getProject","getProjectwatchers","getProjectusers"]),
    historydetailer(){
      let h_detalization=[]
      let arrfactor=['task','work','assignment']      
      
      this.getProject.history.forEach((e,index)=> {
        let formfactor='project'
        let level=1
        for (let x in arrfactor){ 
          if (Object.is(e[arrfactor],null))  {
            break
          }         
          else if (!Object.is(e[arrfactor[x]],null) && 'name' in e[arrfactor[x]] && (!Object.is(e[arrfactor[x]].name,null))) {
            formfactor=arrfactor[x] 
            level = Number(x)+2
          }

        
        }
        e.formfactor=formfactor
        e.level=level})

      this.getProject.history.forEach((e,index)=> {
       
        let h_ob = {new:e, old: this.getProject.history.slice(index+1).find((el=>e.level==el.level && el.formfactor && el[el.formfactor].id==e[e.formfactor].id))}
    
        h_detalization.push(h_ob)
    })
    console.log(h_detalization,"PHPHPHPH");
     return h_detalization
    },
    },
 
    async mounted(){

        // console.log(this.$route.path,"!_!)");
        // let res = await axiosInstance.get(`/history${this.$route.path}`)
        // this.ph=res.data
        // console.log(this.ph);
    },

}


</script>