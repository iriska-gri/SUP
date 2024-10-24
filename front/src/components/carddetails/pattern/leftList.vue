<template>
  <v-row class="overflow-auto overflow-x-hidden h-0 mx-2">
    <v-col class="pa-1 px-2">
      <v-list dense>
        <div
          class="pt-2"
          v-for="(val,indx) in todo"
          :key="indx"
        >
          <v-list-item class="pl-1 pr-0">
            <v-list-item-content class="pa-0 colorfont"> 
              <v-list-item-title
             
                @click="listchangetab(indx)"
                class=" text-body-2 pointer"
              >
              
                {{val.name}}
              </v-list-item-title>  
              <v-row>
                <v-col class="pb-0 text-nowrap ">
                  <span class="caption pointer" @click="$emit('showuserinfo',val.responsible.id)">
                    ({{val.responsible.sn}}) 
                  </span>
                  <span class="caption ">
                    {{val.status.name}}
                  </span>


                </v-col>
                <v-col class="pb-0 flex-grow-1 text-nowrap">
                  <v-row class="mr-0 justify-end">
                    <v-col class="gaps flex-grow-0 pt-3 px-0">

                      <v-menu
                        v-model="val.menu"
                        :min-width="'600px'"
                        :close-on-content-click="false"
                        :close-on-click="false"
                       
                        
                      >
                        <template v-slot:activator="{ on, attrs }">
                          <div
                            v-bind="attrs"
                            v-on="on"
                            v-show="val.status.id<5"
                            
                          >
                      <MyIco
                        size="large"
                        :color="val.status.id!=3?'paused':'open_icons'"
                        :icons ="val.status.id!=3?'mdi-motion-pause-outline':'mdi-play-speed'"
                        :tooltip = true
                        :text_tool="val.status.id!=3?'Приостановить':'Взять в работу'"
                      />
                    </div>
                  </template>
                <DialogNewAssigment
                  :text="(val.status.id!=3? 'Приостановить ':'Открыть ') "
                >
                  <template #textarea>
                    <v-textarea
                            class="py-0 inputext"
                            background-color= "inyand"
                            auto-grow
                            rows="3"
                            solo
                            flat
                            v-model="comment"
                            placeholder="Комментарий"
                        ></v-textarea>
                  </template>
                  <template #btn2>
                    <BtnsOut
                 
                      @click="val.status.id!=3?confirmation({elm: val, res: 3, text: 'Приостановлено'}):confirmation({elm: val, res: 2, text: 'Открыто'})"
                      :title ="val.status.id!=3? 'Приостановить':'Открыть'"
                      :width= 160
                    />
                  </template>
                </DialogNewAssigment>
              </v-menu>
               </v-col>
    <v-col  class=" flex-grow-0 px-0 pl-1"
    v-show="[4,5].includes(val.status.id)" 
    >   
              <v-menu
                class="menu2"
                :min-width="'1400px'"
                :close-on-click="false"
                :close-on-content-click="false"     
                v-model="val.action_confirm"
              >
                <template v-slot:activator="{ on,attrs }">

                    <div
                      v-on="on"
                      v-bind="attrs"
                 v-show="[4,5].includes(val.status.id)"  
                    >
                      <MyIco
                        size="large"
                        :color="val.status.id==5?'open_icons':'close_icons'"
                        :icons ="val.status.id==5?'mdi-progress-check':'mdi-progress-question'"
                        :tooltip = true
                        :text_tool="val.status.id==5?'Выполнено':'Утвердить/отклонить'"
                      />
                    </div>


                </template>
                <DialogNewAssigment
                  
                  :min_height ="500"
                ><template #texts>
                  <div class="d-flex justify-space-between"><span>{{val.name}}</span>
                  <v-icon
                  @click="val.action_confirm=false"
                  >
                    mdi-close </v-icon>
                  
                  
                  </div>




                </template>
                  <template #textarea>
                    <v-row class="flex-grow-1 ">
                      <v-col class="d-flex flex-col">
                        
                          <v-row  class="flex-grow-0">
                            <v-col class="py-0">
                           Комментарий исполнителю
                            </v-col>
                          </v-row>
                          <v-row>
                         <v-col class="py-0 d-flex flex-col">
                          <!-- <v-card> -->
                             <v-textarea
                            class="py-0 inputext flex-grow-1"
                            background-color= "inyand"
                            auto-grow
                          solo
                          
                            
                            v-model="comment"
                            placeholder="Введите текст"
                        ></v-textarea>
                          <!-- </v-card> -->
                            </v-col>
                          </v-row>
                          <v-row  class="flex-grow-0">
                         <v-col class="py-0">
                            <span>Комментарий для отчетности</span> 
                            </v-col>
                            <v-col class="py-0 flex-grow-0 text-nowrap">
                              <v-checkbox
                                class="ma-0"
                                hide-details
                                v-model="send_up"
                                label="Отправлять"
                              />
                            </v-col>
                          </v-row>
                          <v-row>
                         <v-col class="py-0">
                             <v-textarea
                            class="py-0 inputext"
                            background-color= "inyand"
                            auto-grow
                            
                            solo
                            
                            v-model="comment_up"
                            placeholder="Введите текст"
                        ></v-textarea>
                            </v-col>
                          </v-row>
                          <v-row class="flex-grow-0">
                         <v-col class="">
                          <v-row  class="flex-grow-0">
                            <v-col class="">
                      <span class="caption text--secondary">{{level_helper[level].r_text}}</span><br>
                     <span class="pt-4 pointer" @click="$emit('showuserinfo',val.responsible.id)"> {{val.responsible.sn}} {{val.responsible.givenName}} </span>
                       </v-col>
                            <v-col class="flex-grow-0 text-nowrap">
                              <span class="caption text--secondary">Оцените</span>
                      <v-rating
                                color="warning"
                                empty-icon="mdi-star-outline"
                                full-icon="mdi-star"
                                half-icon="mdi-star-half-full"
                                hover
                                length="5"
                                size="18"
                                v-model ="r_rating"
                              ></v-rating>
                            </v-col>
                          </v-row>
                            </v-col>
                          </v-row>
                      </v-col>
                      <v-col  class="flex-col d-flex">
                        <v-row class="flex-grow-1 h-0 overflow-auto overflow-x">
                         
<v-col>
<v-timeline>
    <v-timeline-item
      v-for="x in history(val.id)"
      :key="x.id"
      large
    >
      <template v-slot:icon>
        <v-avatar>
          <img :src="`http://${serverurl}${x.author.avatar}`">
        </v-avatar>
      </template>
      <template v-slot:opposite>
        <span class="pointer" @click="$emit('showuserinfo',x.author.id)">{{x.author.sn}}</span>
      </template>
      
      <div class="caption text--disabled ">Создано:{{momentedtime(x.createdate)}}</div>
      <v-card class="elevation-2">
        <!-- <v-card-title class="text-h5">
          Lorem ipsum
        </v-card-title> -->
        <v-card-text class="pb-0"><p  v-if="!Object.is(x.comment,null) && x.comment.length>0">{{x.comment}}</p>
          <span class="caption text--secondary">{{x.action.name}}->{{x.info.status.name}}</span>

        </v-card-text>
      </v-card>
      
    </v-timeline-item>
  </v-timeline>
</v-col>
                        </v-row>
  
                      </v-col>
                    </v-row>
                    
                  </template>
                  <template #btn1>
                    <BtnsOut
                    
                      @click="confirmation({elm:val,res:2,text:'Отклонена'})"
                      title = "Отклонить"
                    />
                  </template>
                  <template #btn2>
                    <BtnsOut
                      @click="confirmation({elm:val,res:5,text:'Принята'})"
                      title = "Принять"
                    />
                  </template>
                </DialogNewAssigment>
              </v-menu>
            </v-col>
          </v-row>

</v-col>
</v-row>
<v-row class="mt-0 mb-1">

                <v-progress-linear 
                    :value="calcdays(val.datestart, val.dateend, val.status, 3, 5).progress"
                    :color="calcdays(val.datestart, val.dateend, val.status, 3, 5).color"
                  />

</v-row>



          
  
              </v-list-item-content>       
              </v-list-item>
            
            
                                       

                                      <v-divider class="py-0"></v-divider>
      </div>
                                  </v-list>
                                </v-col>
                                  </v-row>
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import uf from '@/utils/universal_functions'
import moment from "moment";
import ui from '@/components/assignments/users-initialization.js'
const { mapGetters } = createNamespacedHelpers("auth");
const workstate = createNamespacedHelpers("workstate");
const taskstate= createNamespacedHelpers("taskstate")
const  projectstate =createNamespacedHelpers("projectstate");
import { URL } from "@/utils/api";
import infousercard from '@/components/UI/infousercard.vue';

export default {

    name:"leftList",
    mixins:[uf, ui],
    components:{
        infousercard},
    props: {
      // cardname:{
      //   type:String,
      //   default:"work"
      // },
      // status:{
      //   type: Number,
      //   requiered:true
      // },
      // itemList: {
      //   type: Array,
      //   requiered: true
      // }
      //  indx: {
      //       type: Number,
      //       default: 0
      //   },
        level: {
            type:Number,
            default:1
        },

    },

 

    data() {
      return {
        r_rating:3,
        send_up:false,
        serverurl:URL,
        comment_up:"",
        comment:"",
        level_helper:[{},{type:"Задачи",r_text:"Ответственный",store:'getProject',child:"tasks"},
                      {type:"Задачи",r_text:"Ответственный",store:'gettasks',child:"task_work"},
                      {type:"Работы",r_text:"Ответственный",store:'getworks',child:"work_assignment"},
                      {type:"Поручения",r_text:"Исполнитель",store:'getworks'},
        
        
        ]

        // card_type:{
        //   project: "задачу",
        //   task: "работу",
        //   work:"поручение"

        // },
      }

    },
    computed:{
      ...mapGetters(["getUser", ]),
    ...workstate.mapGetters(['getworks']),
    ...projectstate.mapGetters(['allpersons','getProject']),
    ...taskstate.mapGetters(['gettasks']),

      todo(){   
        console.log(this.getProject,"----------------");
      return   this[this.level_helper[this.level].store][this.level_helper[this.level].child]

    },
      // history(){
      //   let history=this[this.level_helper[this.level].store].history
      //   if (this.level==4){
            

      //   }

      // }
    },
   
    methods:{
      history(id){
        console.log(this.level, id);
          // console.log(this[this.level_helper[this.level].store].history);
       return  this.level<3? this[this.level_helper[this.level].store].history.filter(e=>[4,7].includes(e.action.id) && e.level==this.level+1):this[this.level_helper[this.level].store].history.filter(e=>!Object.is(e.assignment,null) && e.assignment.id==id && [4,7].includes(e.action.id) )
      },

      confirmation(item){     
         

          let payload = {
            id: item.elm.id,
            status: item.res,
            commentadd: this.comment,
            comment_up:this.send_up?this.comment_up:'',
            r_rating:this.r_rating

          }

          console.log();
          item.elm.menu=false
          this.comment_up=""
          this.comment=""
          this.$emit('confirmation', payload)
      },
      listchangetab(indx){

        if (this.level==3){
          this.$emit('listchangetab',Number(indx)+1)
        }            
        else{
            this.$emit('rout', this[this.level_helper[this.level].store][this.level_helper[this.level].child][indx].id)
        }
        
      }

    },
    mounted(){
      moment.locale("ru")
    }

    
}
</script>

<style>

</style>