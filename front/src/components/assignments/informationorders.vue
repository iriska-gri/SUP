<template>
<div class="flex-col flex-grow-1">
    <v-row  class="flex-grow-0 ma-0 py-2">
        <v-col class="flex-grow-1 pl-3 pr-0 pa-2">
            <!-- <MyIco
            @click="$emit('switch_mode')" 
            :icons ="show?'mdi-pencil-box-outline':'mdi-pencil-box'"
            color="btns"
            :tooltip= true
            :text_tool="show?'Перейти в режим просмотра':'Редактировать проект'"
            />
        </v-col>
        <v-col class="flex-grow-0 px-0 py-2">
            <MyIco
            v-if="show"
            @click="$emit('saveproject')" 
            icons ='mdi-content-save'
            color='green'
            :tooltip= true
            text_tool='Сохранить изменения'
            />  -->
        </v-col>
        <div class="positionname">
            <span class="text-subtitle-1 font-weight-medium text-uppercase">
                {{level_helper[level].type}}
            </span>

        
        </div>
<!-- 

        <v-col v-if="[1, 2, 4].includes(todo.status.id)" class="py-2 px-1 flex-grow-0 text-end" >
                   
                   
                    <v-menu
                        v-model="menu"
                        :min-width="'600px'"
                        :close-on-content-click="false"      
                      >
                        <template v-slot:activator="{ on }">
                          <div
                            v-on="on"
                           
                          >
            
            
            <MyIco
                icons = 'mdi-pause-circle-outline'
                color="paused"
                :tooltip= true
                :text_tool="'Приостановить ' + `${level==2?'задачу':'работу'}`"
            />
                          </div>
                        </template>
                        <DialogNewAssigment
                  text="Приостановить"
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
                 
                        @click="confirmation({elm: todo.id, res: 3, text: 'Приостановлено'})"
                        :width= 160
                    />
                  </template>
                </DialogNewAssigment>
                    </v-menu>
        </v-col> -->
            <!-- <v-col v-if="[3].includes(todo.status.id)" class="py-2 px-1 flex-grow-0 text-end" >
            
            <MyIco
                v-if ="checkRP"
                @click="$emit('changestatus', {val: todo, action: 2})"
                icons = 'mdi-play-speed'
                color="open_icons"
                :tooltip= true
                :text_tool="'Запустить ' + `${level==2?'задачу':'работу'}`"
            />
            
        </v-col>
        <v-col v-if="!show && ![3].includes(todo.status.id)" class="flex-grow-0 flex-col"> -->


        <!-- 1 - Черновик, 3 приостановлено -->
        <!-- <v-row
          v-if="[1].includes(todo.status.id)"
          class="flex-grow-0 align-self-end"
        >
          <v-col class="py-2 pr-1">

            <MyIco
              v-if ="checkRESP?'':checkRP"
              :icons ="todo.status.id==2?'mdi-file':'mdi-file-hidden'"
              color='btns'
              :cursor= false
              :tooltip= true
              :text_tool="todo.status.id==2?'Приостановлено РП':'Черновик'"
            />
            <MyIco
              v-if ="checkRESP?'':checkRP?'':checkALL"
              icons ="mdi-dots-horizontal"
              color='btns'
              :cursor= false
              :tooltip= true
              :text_tool="todo.status.id==2?'Приостановлен':'Черновик'"
            />
          </v-col>
        </v-row> -->

        <!-- 2 - в работе -->
        <v-row
          class="flex-grow-0  align-self-end pr-2"
       
        >
         <v-col v-if ="checkRESP && [1].includes(todo.status.id)"  class="pa-3">
            <MyIco
                          
                          icons = 'mdi-play-circle-outline'
                          color="open_icons"
                          :tooltip= true
                          text_tool="Взять в работу"
                           @click="$emit('changestatus', {val: todo, action: 2,h_action:8})"
                        />

         </v-col>
          
            <v-col v-if ="checkRESP && [2].includes(todo.status.id) && childready"  class="pa-3">
               <v-menu
                class="menu2"
                :min-width="'600px'"
                :close-on-content-click="false"     
                v-model="action_confirm"
              >
                <template v-slot:activator="{ on }">

                    <div
                      v-on="on"
                 
                    >
                    <!-- @click="$emit('changestatus', {val: todo, action: 4})" -->
                              <MyIco
                          
                          icons = 'mdi-arrow-up-bold-circle-outline'
                          color="open_icons"
                          :tooltip= true
                          text_tool="Отправить на проверку"
                        />
                    </div>


                </template>
                <DialogNewAssigment
                  text="Отчет о состоянии"
                >
                  <template #textarea>
                  <v-textarea
                            class="py-0 inputext"
                            background-color= "inyand"
                            auto-grow
                            rows="3"
                            solo
                            flat
                            v-model="comment_up"
                            placeholder="Комментарий"
                        ></v-textarea>
                  </template>
                  <template #btn1>
                    <BtnsOut
                      :disabled="comment_up.length==0"
                      colora="red"
                      title = "Не выполнено"
                      @click="chs(false)"
                    />
                  </template>
                  <template #btn2>
                    <BtnsOut
                      @click="chs(true)"
                      title = "Выполнено"
                    />
                  </template>
                </DialogNewAssigment>
              </v-menu>
            </v-col>
          



           <v-col class="py-2 px-0" v-if="[5].includes(todo.status.id)">
            <MyIco 
              icons = 'mdi-checkbox-marked-circle-outline'
              color='open_icons'
              :tooltip= true
              :cursor= false
              :text_tool="`${level==2?'Задача ':'Работа '}` +'завершена'"
            />
          </v-col>
          <!-- ВОЗМОЖНО, ПОТОМ ВОЗРОДИТЬ -->
          <!-- <v-col class="py-2 px-1" v-if="[5].includes(todo.status.id)">
            <MyIco
                v-if ="checkRESP"
                @click="$emit('changestatus', {val: todo, action: 2})"
                icons = 'mdi-undo-variant'
                color="btns"
                :tooltip= true
                text_tool="Вернуть из выполненных"
            />
          </v-col> -->
          <v-col class="py-2 pr-1" v-if="[4].includes(todo.status.id)">
              <MyIco
                icons = 'mdi-calendar-clock'
                color="btns"
                :tooltip= true
                :cursor= false
                text_tool="На проверке"
              />
            </v-col>
            

          <!-- <div v-if ="checkRESP?'':checkRP">
            <v-col class="py-2 px-1">
              <MyIco
                icons = 'mdi-file-outline'
                color='btns'
                :tooltip= true
                :cursor= false
                text_tool="В работе"
              />
            </v-col>
          </div>
          <div v-if ="checkRESP?'':checkRP?'':checkALL">
            <v-col class="py-2 px-1">
              <MyIco
                icons ="mdi-dots-horizontal"
                color='btns'
                :cursor= false
                :tooltip= true
                text_tool='В работе'
              />
            </v-col>
          </div> -->
        
        
        
        
        
        
        
        </v-row>

        <!-- 4 на проверке -->
        <!-- <v-row
          
          class="flex-grow-0 align-self-end flex-nowrap"
        > -->

        <!-- !НЕ УДАЛЯТЬ!!!!!!!!!!!!!!!!!!! -->

          <!-- <template v-if ="checkRP">
            <v-col class="py-2  px-0">
              <MyIco
                @click="$emit('changestatus', {val: todo, action: 5})"
                icons = 'mdi-check'
                color="open_icons"
                :tooltip= true
                text_tool="Утвердить"
              />
            </v-col>
            <v-col class="py-2 px-1">
              <MyIco
                @click="$emit('changestatus', {val: todo, action: 2})"
                icons = 'mdi-close'
                color="close_icons"
                :tooltip= true
                text_tool="Отклонить"
              />
            </v-col>
          </template> -->




           <!-- !НЕ УДАЛЯТЬ!!!!!!!!!!!!!!!!!!! -->



          <!-- <div v-if ="checkRESP?'':checkRP?'':checkALL">
           
          </div>
        </v-row> -->

       <!-- 5 завершено -->
        <!-- <v-row
          v-if="[5].includes(todo.status.id)"
          class="flex-grow-0 flex-nowrap align-self-end"
        > -->
         
        <!-- </v-row> -->
    
    </v-row>
    <v-divider/>
        <v-alert
            dense
            text
            color="btns"
            class="pa-0 pr-1 ma-0"
        >
            <v-row class="flex-grow-0  ma-0">
                <v-col class=" pa-0">
                    <v-breadcrumbs
                        class="pa-0 justify-end"
                        :items="breadcrumbs"
                    >
                        <template v-slot:item="{ item }">
                          <v-breadcrumbs-item
                            :class="item.href.length==0?'pointer':''"
                            :href="item.href"
                            :disabled="item.disabled"
                            @click="item.href.length==0?$emit('listchangetab', 0):''"
                          >
                            <span class="text_menus--text">
                              {{ item.text }}
                            </span>

                          </v-breadcrumbs-item>
                        </template>
                      
                      </v-breadcrumbs>
    </v-col>
                      
    </v-row> 
            </v-alert>
        <v-divider/>
    <v-row class="h-0 overflow-auto card-text ma-0 informationorder">
        <v-col class=" flex-col pt-1">          

            <row-pirow  
                title="Краткое название:"
                
            ><template #leftcol>{{todo.name}}</template>
    
            </row-pirow>
             <row-pirow 
        title="Название:"      
      >
        <template #leftcol>
          
          <span>{{todo.longname}}</span>
        </template>
      </row-pirow>
      
            <row-pirow
                title="Период:"
               
            >
            <template #leftcol>
              
              {{`${momentedDay(todo.datestart) } - ${momentedDay(todo.dateend)}/(${timediff(todo.dateend)})`}}
            </template>
            </row-pirow>
                 <period-info
                 :srok="daycalc.fifteen"
                 >
        <template> 
            <v-progress-linear
                v-if="todo.status.id != 5"
              :value="daycalc.progress"
              :color="daycalc.color"
                rounded
                height="10"
                style="pointer-events: none"
                class="mt-2"
            >
            </v-progress-linear>
                    </template>
      </period-info>
            <row-pirow v-show="indx==0 && !isNaN(workaccepted)"
                :title="level==2?'Выполнено работ:':'Выполнено поручений:'"

            />
            <v-row class="flex-grow-0 my-0" v-show="indx==0 && !isNaN(workaccepted)">
                <v-col class="align-self-center py-0">
                 
                    <v-progress-linear
                        v-model="workaccepted"
                        rounded
                        height="10"
                        style="pointer-events: none"
                        class="mt-0"
                    >
                    </v-progress-linear>
                </v-col>
                <v-col class="text-end flex-grow-0 pl-0 py-1">
                    <strong class="ml-auto align-self-center body-2">{{ Math.ceil(workaccepted)}}%</strong>
                </v-col>
                 
            </v-row>
            <!-- {{todo}} -->
              <row-pirow
        title="Сложность реализации:"      
      >
        <template #leftcol>
          <v-rating
          class=" ml-n3 star"
          color="warning"
          empty-icon="mdi-star-outline"
          full-icon="mdi-star"
          half-icon="mdi-star-half-full"
          hover
          length="5"
          readonly
          size="16"
          :value="todo.difficult"
        ></v-rating>
          
        </template>
      </row-pirow>
            <v-divider class="mt-2 mb-1"/>

            <row-pirow
                :point= true
                :stroka="'showuserinfo'"
                :title="level_helper[level].r_text"
                @showuserinfo="showuserinfo(todo.responsible.id)"
            >
            <template #leftcol>
              {{searchUserFullName(todo.responsible.id, allpersons)}}
            </template>
            </row-pirow>
            <!-- :text="`${searchUserFullName(todo.responsible.id, allpersons)}`" -->
            
            <row-pirow
                title="Статус:"

                        >
            <template #leftcol>
              {{`${ todo.status.name} ` 
                + `${[2,3].includes(todo.status.id) ?`(взято в работу ${momentedDay(todo.getstarted)})`:''}`
                + `${ 4==todo.status.id ?`(с ${momentedDay(todo.lastchanged)})`:'' }`}}
            </template>
            </row-pirow>
            <v-divider class="my-2 mb-1"/> 
            <row-pirow
                :rightcolUsed= true
                title="Чат:"
                :point= true
        
                :text="``"
            
            >
            <template #leftcol>
              <div class="d-flex">
                    <MyIco
                            @click="dialogger"
                            size="small"
                            icons = "mdi-menu"
                            :tooltip= true
                            text_tool="Управление чатом"
                        />
              
              <span class="ml-4">
              {{`${Array.isArray(chat.users)? 'Кол-во участников: ' + chat.users.length: ''}`}}
              </span>
              </div>
            </template>

                <template #rightcol>
                    <BtnsOut   
                        @click="$emit('createtabchat')"      
                        v-if="!('id'in chat)"     
                        :widthi=97
                        :icon = true
                        title = "Создать чат"
                    >
                        <template #icons>
                            <MyIco
                            size="small"
                            icons = 'mdi-chat-outline'
                        />
                        </template>                         
                    </BtnsOut>
                    <BtnsOut   
                        class="mr-1"
                        v-else
                        @click="$emit('chatviewer')" 
                        :widthi=97
                        :icon = true
                        :title = "chatview?'Скрыть Чат':'Показать чат'"
                    >
                        <template #icons>
                            <MyIco
                            size="small"
                            :icons = "chatview?'mdi-chevron-double-right':'mdi-chevron-double-left'"
                        />
                        </template>                         
                    </BtnsOut>
                </template>
            </row-pirow>
            <v-divider class="mt-3 mb-1"/>  
            <row-pirow
                :title="level_helper[level-1].type"
                :stroka="'linkproject'"
                :point= true
                @linkproject="parenthref()"
              >
            <template #leftcol>
                {{todo.parent.name}}
            </template>
            </row-pirow>
            <row-pirow
                title="Период:"
                          >
            <template #leftcol>
              {{`${momentedDay(todo.parent.datestart)} - ${momentedDay(todo.parent.dateend)} / ${timediff(todo.parent.dateend)}`}}
            </template>
            </row-pirow>
           
            <row-pirow
                :title="level_helper[level-1].r_text"
                :stroka="'showuserinfo'"
                :point= true

                @showuserinfo="showuserinfo(parentresp.id)"
              >
            <template #leftcol>
        {{parentresp.sn}} {{parentresp.givenName}}
            </template>
            </row-pirow>
            <v-divider class="mt-3 mb-1"/>  
            <row-pirow 
                title="Описание:"
            
                                      >
            <template #leftcol>
{{todo.description?'':'Описание отсутсвует'}}
            </template>
            </row-pirow>
                <v-row 
                    class="flex-grow-0 mt-0"
                    v-show="todo.description"
                >
                    <v-col 
                        class="pa-0"
                    >
                        <v-textarea
                            id="description"
                            class="unip"
                            background-color= "inyand"
                            readonly
                            hide-details
                            auto-grow
                            rows="0"
                            solo
                            flat
                            :value="todo.description"
                        > 
                        </v-textarea>
                    </v-col>
                </v-row>  
            <v-divider class="mt-3 mb-1"/> 
       
            <history-min-card :level="level"
            :indx='indx'
            @showuserinfo="showuserinfo"
            />
            <!-- <v-divider/>    -->
        </v-col>
    <infousercard
        :dialogdetail="dialogdetail"
        :person="person"
        @dialogdetailoff="dialogdetail=false"
    />
   











</v-row>
 </div>
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import uf from '@/utils/universal_functions'
import ui from './users-initialization.js'
import { bus } from "@/main";
import moment from "moment";
const { mapGetters } = createNamespacedHelpers("auth");
const workstate = createNamespacedHelpers("workstate");
const taskstate= createNamespacedHelpers("taskstate")
const  projectstate =createNamespacedHelpers("projectstate");
import infousercard from '@/components/UI/infousercard.vue';
import rowPirow from '@/components/carddetails/pattern/row-pirow.vue';
import periodInfo from './UI/period-info.vue'
import historyMinCard from './UI/history-min-card'

export default {

    name: 'informationorders',

    mixins:[uf, ui],
    components:{
        infousercard,
        rowPirow,
        periodInfo,
        historyMinCard
  
    },
    props:{
    
        breadcrumbs:{
            type:Array,
            requiered:true,
        },
        chat:{
            type:Object,
            default:()=>{}
        },

        chatview:{
            type:Boolean,
            default:true
        },

        indx: {
            type: Number,
            default: 0
        },
        level: {
            type:Number,
            default:1
        },

    },

    data: () => ({
        
        dialogdetail:false,
        person:{},
        show: false,
        comment:"",
        menu:false,
        action_confirm:false,
        comment_up:"",
        level_helper:[{},{type:"Проект",responsible:'rp',r_text:"Руководитель проекта",store:'getProject',child:'project_tasks'},
                      {type:"Задача",responsible:'responsible',r_text:"Ответственный",store:'gettasks',child:"task_work"},
                      {type:"Работа",responsible:'responsible',r_text:"Ответственный",store:'getworks',child:"work_assignment"},
                      {type:"Поручение",responsible:'responsible',r_text:"Исполнитель",store:'getworks'},
        
        
        
        
        ]
        
    }),

    computed: {
    ...mapGetters(["getUser", ]),
    ...workstate.mapGetters(['getworks']),
    ...projectstate.mapGetters(['allpersons','getProject']),
    ...taskstate.mapGetters(['gettasks']),



        daycalc(){
          return this.calcdays(this.todo.datestart, this.todo.dateend,this.todo.status, 3, 5)
        },

        parentresp() {
          if(this.level>2){
            return this.todo.parent.responsible!=undefined?this.todo.parent.responsible:0
          }
          else{
            console.log(this.todo, "TODO")
            let a= this.todo.parent.users
            a=a.find(e=>e.role.id==2)
            console.log(a,"aaaa");
            return a!=undefined?a.user:0
          }     
            
        },

    // inf(){
    //     if (this.level==2){
    //         let p = this.getProject
    //         let rp = p.users.find(e=>e.role.id==2)
    //         p.responsible = rp!=undefined?rp.user:undefined  
    //         console.log(this.gettasks);
    //         console.log({data: this.gettasks, child:"task_work", parent:p, type:'Проект:', role: 'Руководитель проекта:'});         
    //         return {data: this.gettasks, child:"task_work", parent:p, type:'Проект:', role: 'Руководитель проекта:'}
    //     }
    //     else if (this.level==3){
    //         return {data: this.getworks, child:"work_assignment", parent:this.gettasks, type:'Задача:', role: 'Ответсвенный:'}
    //     }
    //     return {}


        
    // },
    
    todo(){
      let parent={parent:this[this.level_helper[this.level-1].store]}
      let current= this.indx>0?this.getworks.work_assignment[this.indx-1]:this[this.level_helper[this.level].store]
      console.log({...current,...parent} ,"CURPAR");
      return {...current,...parent}       
      },   

    workaccepted(){
      
        try{
        let wc=0
         this.todo[this.level_helper[this.level].child].forEach(el=> {if(el.status.id==5) wc+=1   } )          
        return wc/this.todo[this.level_helper[this.level].child].length*100
        } catch(e){
            return "0"
        }
        
    }, 

    checkRESP() {      
      console.log(this.todo,"TOTOTOTODO");
        return this.todo.responsible.id == this.getUser.id
        
    },

            // checkRP() {
            //     let rp = ''
            //     if (this.level == 2) {
            //         let k = this.todo.parent.users.find(e=> e.role.id == 2)
            //         rp = k.user.id
            //         console.log(`RP2--------`, rp)
            //     }
            //     if (this.level == 3) {
            //         rp = this.todo.parent.responsible.id
            //         console.log(`RP3--------`, rp)
            //     }
            //     if (rp == this.getUser.id) {
            //         return true
            //     }
            //     else
            //         return false
            // },
  
   
    },  
    mounted(){
      moment.locale("ru")
        
    },
   
    methods:{

        ...workstate.mapMutations(["setWorks"]),
      chs(report){
        this.$emit('changestatus', {val: this.todo, action: 4,h_action:7, comment:this.comment_up.length>0?this.comment_up:null,ididit:report})
        this.comment_up=""
        this.action_confirm=false

    },
    
    
      // confirmation(item){    
         
    
      //     let payload = {
      //       id: item.elm,
      //       status: item.res,
      //       commentadd: this.comment

      //     }
      //     console.log(payload, '-----------------informationsorder');
      //     this.menu=false
      //     this.comment=""
      //   //   this.$emit('confirmation', payload)
      // },

        parenthref(){
        if (this.indx==0){
            let a = this.$route.path.split("/")
            a.length = a.length-2
            this.$router.push(a.join("/"))
        }
        else{ this.$emit("changetab",0)
        }  
        
       
    },

    


    childready() {
            if (this.inf.child in this.inf.data && this.inf.data[this.inf.child].length==0)
                return true
            try{
                return this.inf.data[this.inf.child].every(el=>[3,5].includes(el.status.id))}
            catch{
                return false
            }
        },
        
        showuserinfo(val){
            this.person = this.searchUser(val, this.allpersons )
            this.dialogdetail=true
        },
        
        dialogger(){
            
            bus.$emit("chatuserdialog",{ place: 'rightchat' ,chat:{id:this.chat.id,level:this.chat.level, parent:this.chat.parent}})
         
        },

   

   

    }
}
</script>

<style>



.profile {
    min-width: 7vw;
}

.colorfont {
    color: var(--v-inyand2-base);;
}

.sticky {
  position: sticky;
  top: 0;

  z-index: 3;
  background: var(--v-inyand-base);
}
.sticky2 {
  position: sticky;
  bottom: 0;

  z-index: 3;
  background: transparent;
}
.v-textarea.v-text-field--enclosed.v-text-field--single-line:not(.v-input--dense) textarea {
    margin-top: -4px;
}

    .card-text {
        font-size: 14px;
    }
    #description {
        padding-top: 15px;
    }

    #something  {
        padding-top: 5px;
        align-self: center;
    }

    #td_history > .v-text-field.v-text-field--solo .v-input__control {
        min-height: 0;
    }

    .positionname {
        position: absolute;
        left: 48%;
    }

    .psevdobread {
        align-items: center;
    display: inline-flex;
    font-size: 14px;
    }

.star > button {
  padding-top: 2px!important;
  padding-bottom: 10px!important;
}
</style>