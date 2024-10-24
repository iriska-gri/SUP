<template>
  <div class="d-flex flex-col flex-grow-1">
      <div>
       <v-app-bar
      class="flex-grow-0 ma-0 px-4 mx-2"
      color="inyand"
      elevation='1'
      dense
    
    >
  
      <v-app-bar-nav-icon>
         <MyIco
          @click="$emit('switch_mode')" 
          icons ="mdi-pencil-box-outline"
          color="btns"
          size="x-large"
          :tooltip= true
          :text_tool="'Редактировать проект'"
        />
      </v-app-bar-nav-icon>

      <v-toolbar-title
      color="primary"
      >Проект</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-row
          v-if="[1,6].includes(getProject.status.id)"
          class="flex-grow-0 align-self-center"
        >
  
            <MyIco
              v-if ="checkRP"
              @click="$emit('changestatus', {val: getProject, action: 5})"
              icons = 'mdi-arrow-right-drop-circle-outline'
              color='open_icons'
              :tooltip= true
              text_tool="Взять в работу"
            />
           
  
        </v-row>

        <!-- 5 - в работе -->
        <v-row
          class="flex-grow-0 align-self-end"
          v-if="[5].includes(getProject.status.id)"
        >
          <template v-if ="checkRP">
            <v-col class="py-2 px-0">
              <MyIco
                @click="$emit('changestatus', {val: getProject, action: 2})"
                icons = 'mdi-arrow-right-bold-circle-outline'
                color="open_icons"
                :tooltip= true
                text_tool="Отправить на согласование"
              />
            </v-col>
            <v-col class="py-2 px-1">
              <MyIco
                @click="$emit('changestatus', {val: getProject, action: 6})"
                icons = 'mdi-pause-circle-outline'
                color="paused"
                :tooltip= true
                text_tool="Приостановить работу"
              />
            </v-col>
          </template>
          <div v-if ="checkRP?'':checkDIR">
            <v-col class="py-2 pr-1">
              <MyIco
                icons = 'mdi-file-outline'
                color='btns'
                :tooltip= true
                :cursor= false
                text_tool="В работе"
              />
            </v-col>
          </div>
        
        </v-row>

        <!-- 2 на согласовании -->
        <v-row
          v-if="[2].includes(getProject.status.id)"
          class="flex-grow-0 align-self-end"
        >
          <template v-if ="checkDIR">
            <v-col class="py-2 px-0">
              <MyIco
                @click="$emit('changestatus', {val: getProject, action: 3})"
                icons = 'mdi-check'
                color="open_icons"
                :tooltip= true
                text_tool="Утвердить"
              />
            </v-col>
            <v-col class="py-2 px-1">
              <MyIco
                @click="$emit('changestatus', {val: getProject, action: 4})"
                icons = 'mdi-close'
                color="close_icons"
                :tooltip= true
                text_tool="Отклонить"
              />
            </v-col>
          </template>
         
        </v-row>

        <!-- 3 - утвержден -->
        <v-row
          v-if="[3].includes(getProject.status.id)"
          class="flex-grow-0 align-self-end"
        >
          <v-col class="py-2 pr-1">
            <MyIco
              v-if ="checkDIR"
              @click="$emit('changestatus', {val: getProject, action: 7})"
              icons = 'mdi-checkbox-marked-outline'
              color='open_icons'
              :tooltip= true
              text_tool="Утвержден. Отправить на завершение"
            />
        
          </v-col>
        </v-row>

        <!-- 4 - Отклонен -->
        <v-row
          v-if="[4].includes(getProject.status.id)"
          class="flex-grow-0 align-self-end"
        >
          <v-col class="py-2 pr-1">
            <MyIco
              v-if ="checkRP"
              icons = 'mdi-arrow-right-drop-circle-outline'
              @click="$emit('changestatus', {val: getProject, action: 5})"
              color='open_icons'
              :tooltip= true
              text_tool="Взять в работу"
            />
     
          </v-col>
        </v-row>
       
         <MyIco
             
              icons ="mdi-dots-horizontal"
              color='btns'
              :cursor= false
              :tooltip= true
              :text_tool='getProject.status.name'
            />

   
    </v-app-bar>
    </div>

  
  <v-row class="h-0 overflow-auto card-text ma-0 mt-2">
    
    <v-col class="d-flex flex-col pt-2">
           <row-pirow
       
        title="Название:"   
        rowclass="pb-0 mt-n2" 
        myclass="pt-2"
      >
        <template #leftcol>
                              <v-textarea 
                              readonly
                              solo
                        :value="getProject.longname"
                        auto-grow
                        :rows='0'
                        dense
                        flat
                       
                        class="mt-0 ml-n3 pt-0 nameproject"
                        hide-details
                    />
        
        </template>
      </row-pirow>
      <row-pirow
      class="mt-0"
        title="Краткое название:"      
      >
        <template #leftcol>
        
          <span>{{getProject.name}}</span>
        </template>
      </row-pirow>

      <row-pirow
      class="mt-0"
        title="Период:"      
      >
        <template  #leftcol>
          {{`${momentedDay(getProject.datestart) } - ${momentedDay(getProject.dateend)}/(${timediff(getProject.dateend)})`}}
     
        </template>
      </row-pirow>
      
      <period-info
        :srok="daycalc.fifteen"
      >
        <template>
          <v-progress-linear
              v-if="prlin"
              :value="daycalc.progress"
              :color="daycalc.color"
              rounded
              height="10"
              style="pointer-events: none"
              class="mt-2"
              />
        </template>
      </period-info>
      <row-pirow
      class="mt-0"
        v-show="!isNaN(workaccepted)"
        title="Выполнено задач:"
       
      ><template  #leftcol>
        {{`${alltask[1]}/${alltask[0]}`}}
        </template>
        </row-pirow>
     
      <v-row
        class="flex-grow-0 my-0"
        v-show="!isNaN(workaccepted)"
      >

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
          <strong class="ml-auto align-self-center body-2">
            {{ Math.ceil(workaccepted)}}%
          </strong>
        </v-col>
      </v-row>
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
          :value="getProject.difficult"
        ></v-rating>
          
        </template>
      </row-pirow>
      <v-divider
        class="mt-2 mb-1"
      />
      <row-pirow        
        title="Статус:"       
       
      >
        <template
          
          #leftcol
        >
        
          <span>{{getProject.status.name}}</span>
        </template>
      </row-pirow>
      <row-pirow
        title="Тип:"   
      >
        <template #leftcol>

          <span>{{getProject.ptype.name}}</span>
        </template>
      </row-pirow>
      <v-divider class="my-1 mt-3"
  
      />
      <roles-single
        :show="false"
        @showuserinfo="showuserinfo"
      />
      <v-divider class="mb-0 mt-3 bg_div" />
      <roles-many
        :roles="5"
        :show="false"
        @showuserinfo="showuserinfo"
      />
      <v-divider class="mb-n2 mt-5 bg_div" />
      <roles-many
        :show="false"
        @showuserinfo="showuserinfo"
      />
      <v-divider class="mt-4 mb-2"/>
      <row-pirow   title="Чат:"
        :rightcolUsed= true
        
      >
        <template #leftcol >
          <div class="d-flex">
          <MyIco
            @click="dialogger"
            size="small"
            icons = "mdi-menu"
            :tooltip= true
            text_tool="Управление чатом"
          /> 
          <span class="ml-4">{{`${Array.isArray(chat.users)? 'Кол-во участников: '  + chat.users.length: ''}`}}</span>
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
       <v-divider class="mt-4 mb-3"/>
            <exp-panel
              class="mb-3"
                :addremrow="addremrow"
                :newproject="getProject"

            />


       <history-min-card
            :level="1"
            :indx='0'
            @showuserinfo="showuserinfo"
            />
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
import { bus } from "@/main";
import uf from '@/utils/universal_functions'
import ui from './users-initialization.js'
import getFilters from '@/utils/filterutil'
import { createNamespacedHelpers } from "vuex";
import SelectUserMenu from '@/components/UI/SelectUserMenu.vue'
import rowPirow from '@/components/carddetails/pattern/row-pirow.vue';
import rolesSingle from './UI/roles-single.vue';
import periodInfo from './UI/period-info.vue'
import rolesMany from './UI/roles-many.vue';
import infousercard from '@/components/UI/infousercard.vue';
import historyMinCard from './UI/history-min-card'
import ExpPanel from './UI/exp-panel.vue';

const { mapMutations, mapActions } = createNamespacedHelpers("filterslogic");
const  projectstate = createNamespacedHelpers("projectstate");
const  mult = createNamespacedHelpers("multifilter");

export default {

    name: "project-informationorders",

    mixins:[getFilters,uf, ui],

    components:{
        SelectUserMenu,
        rowPirow,
        rolesSingle,
        rolesMany,
        infousercard,
        periodInfo,
        historyMinCard,
        ExpPanel
    },

     data: () => ({
        rp: false,
        
        dialogdetail:false,
        person:{},
                addremrow: [{field: 'target', text: "Цель (цели) проекта"},
                {field: 'result', text: "Результат (результаты) проекта"},
                {field: 'criteria', text: "Критерии успеха проекта"},
                {field: 'risks', text: "Риски реализации проекта"},
                {field: 'interactions', text: "Взаимосвязи с другими проектами и программами"},
                ],
        info_helper:{
            project_sphere:{text:"Сфера",typearr:false},
            grounds:{text:"Основания",typearr:false},
            target:{text:"Цели",typearr:true},
            financial_support:{text:"Финансирование",typearr:false},
            result:{text:"Результаты",typearr:true},
            criteria:{text:"Критерии успеха",typearr:true},
            risks:{text:"Риски",typearr:true},           
            influence:{text:"Влияние результатов",typearr:false},
            interactions:{text:"Взаимосвязь",typearr:true},
            
            
            
            
        }
       
     }),

      props:{
   
        // user: {
        //   type: Number,
        //   default: 0
        // },

        

        chat:{
          type:Object,
          default:()=>{}
        },

  
     

        chatview:{
          type:Boolean,
          default:true
        },

        // show:{
        //   type:Boolean,
        //   default:true
        // },


    
      },

        methods:{

        ...mapMutations(["setFields"]),
        ...mapActions(["clear", "getFilters", "addFilter", "activefilters"]),
        ...projectstate.mapMutations(["setProjectType", "setProjectStatus","setProjectname"]),
        
      // calccolorproject(datestart, dateend, status){
       
      //   try{
      //   let totheend = this.calcdays(datestart, dateend)[0]

      //   if(status.id==6){
      //     return "prliniarstop"
      //   }
      //   else if (status.id!=7){
      //     if (totheend>=100)
      //       {return "prliniar100"}
      //     else if(totheend>=85){
      //       return "prliniar85"
      //     }
      //     else{
      //       return "prliniarelse"
      //     }
      //   }
      //   else{
      //     return ""
      //   }
      // }catch{return ""}
    // },
     

      

        userssearch(id) {
          let names = this.respons(id)
          return names==undefined?'':'  '
        },

        showuserinfo(val){
            this.person = this.searchUser(val, this.allpersons )
            this.dialogdetail=true
        },
        setpn(val){
        this.setProjectname(val)},

 dialogger(){
            
            bus.$emit("chatuserdialog",{ place: 'rightchat' ,chat:{id:this.chat.id,level:this.chat.level, parent:this.chat.parent}})
         
        },





        },

        computed: {
          ...projectstate.mapGetters(["getProject","getprojectuniquePersons",'allpersons']),
          todo(){
              return this.getProject
          },
        alltask() {
        let alltask = []
        let isp = this.getProject.tasks.filter(e=>e.status.id == 5)
        alltask.push(this.getProject.tasks.length, isp.length)
        return alltask
      },
        workaccepted(){
          return 100*this.alltask[1]/this.alltask[0]
        },
        daycalc(){
          return this.calcdays(this.todo.datestart, this.todo.dateend,this.todo.status, 6, 7)
        },

        checkRP() {
            let obl = false
            this.getProject.users.filter(e=> {
              if ([2].includes(e.role.id) && e.user.id == this.user) {
                obl = true
              }})
            return obl
          },
  
        checkDIR() {
        let obl = false
        this.getProject.users.filter(e=> {
            if ([1].includes(e.role.id) && e.user.id == this.user) {
            obl = true
            }})
        return obl
        },
  
          prlin() {
            if(this.todo.status.id == 7) {
              return false
            }
            else
              return true
          },

          type1:{
            get() {
              return this.getProject.ptype.id
            },
            set(val) {
              // console.log(`val----`, val);
              this.setProjectType(val)
            }
            
          },

          status1:{
            get() {
              return this.getProject.status.id
            },
            set(val) {
              // console.log(`val----`, val);
              this.setProjectStatus(val)
            }
            
          }
        },
           
 


}
</script>

<style>
  .v-application--is-ltr .v-textarea.v-text-field--enclosed .v-text-field__slot textarea {
    margin: 0
  }
  .card-text {
      font-size: 14px!important;
      font-weight:400!important
  }
  .denc {
    min-height: 20px!important;
  }

  .bg_div {
    border-color: rgb(239 239 239)!important;
  }

 

.star > button {
  padding-top: 2px!important;
  padding-bottom: 10px!important;
}

.nameproject.v-textarea textarea {

    min-height: 23px!important;
}

.v-text-field.v-text-field--solo.v-input--dense > .v-input__control {
    min-height: 0px!important
}

</style>