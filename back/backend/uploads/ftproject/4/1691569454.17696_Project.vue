
<template>
<v-container class="flex-col h-100 w-100 " fluid >
  <v-row class="flex-grow-0 pt-3 px-3">
    <v-tabs
      v-model="tab"
      color="transparent"
      background-color="transparent"
      grow
    >
    <!--   -->
      <v-tab
        v-for="(value, i) in tabs"
        :href="'#tab-' + i"
        :key="i"
        active-class="select_item"
        class="relax_item mr-1 "
        :ripple="false"
      >
        {{value}}
      </v-tab>
    </v-tabs>
  </v-row>
 <v-row>
    <v-col
      class=" flex-col pr-2"
      lg=4
      md=12
      sm=12
    >
          <v-card class="flex-grow-1 flex-col mb-2" color="main_theme">

                          <v-card-text
                            class="pt-3
                            pb-0"
                          >
                            <v-row class="justify-end">
                              <v-col class="pa-0 pt-2 pr-2 flex-grow-0">
                            
                                <v-btn
                                  icon
                                  x-small
                                >
                                  <v-icon color="btns">
                                    mdi-arrow-top-right-bottom-left
                                  </v-icon>
                                </v-btn>
                              </v-col>
                            </v-row>
                          </v-card-text>
                        <v-card-text class="flex-col flex-grow-1">
                          <ColText
                            :fieldname="'Проект'"
                            class="py-2 pr-3"
                          >                          
                            <template #field>
                              <v-text-field
                                v-model="project.name"
                                placeholder="Без названия"
                                dense
                                hide-details
                                class="inputext"
                              >
                              </v-text-field>
                            </template>                         
                          </ColText>
                          <ColText
                            :fieldname="'Сырок'"
                            class="pb-1 pr-3"
                          >                          
                            <template #field>
                              <v-row>
                                <v-col
                                  v-for="(value,i) in ['datestart','dateend']"
                                  :key="i"
                                  class="pt-0 pb-1"
                                >
                                  <v-menu 
                                    v-model="picker[i]"
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
                                        :value="formatDate(project[value])"              
                                        type="date-local"              
                                        placeholder="дд.мм.гггг"
                                        @focus="datekey=i"
                                        @input="event=>oninput(event, value)"
                                        v-bind="attrs"
                                        hide-details
                                        v-on="on"
                                        class="pt-1 mb-2 inputext"
                                      >
                                      </v-text-field>
                                            </template>
                                            <v-date-picker
                                              :first-day-of-week="1"                                         
                                              v-model="project[value]"
                                              @input="i==1?
                                              datefrom = false
                                              :dateto=false"  
                                            >
                                            </v-date-picker>
                                          </v-menu>
                                          </v-col>
                              </v-row>
                            </template>                         
                          </ColText>
                            <ColText
                              :fieldname="fieldname.name"
                              v-for="(fieldname,val) in selectfields"
                              :key="val"
                              class="pb-1 pr-3"
                            >                          
                              <template #field>
                                <v-autocomplete
                                  dense
                                  class="inputext my-0 iconsh"
                                  v-model="project[fieldname.basefield]"
                                  :items="selectdatafields[val]"
                                  return-object
                                  item-text="name"
                                  item-value="id"
                                  hide-details
                                >
                                </v-autocomplete>
                              </template>                         
                            </ColText>
                            <ColText
                              v-for="(value, i) in userFields"
                              :key="i"
                              :fieldname="value.text"
                              :mod="value.model"
                              class="pr-3"
                              :class="i==0?'pt-1':'pt-2'"
                            >                          
                              <template #field>
                                <span
                                  :class="project[value.model]?'inyand2--text':'passiv_text--text'"
                                  class="inputext inputcolor  rounded-lg px-2 mr-2"
                                >
                                  {{project[value.model]?project[value.model].fullname:"Выбурете"}}
                                </span>
                              </template>
                              <template #buttons>
                                <SelectUserMenu
                                  :mod="value.model"
                                  :addtext="project[value.model]?'Изменить':'Добавить'"
                                />
                              </template>
                            </ColText>
                            <ColText
                              :fieldname="'Участники'"
                              :mod="'users'"
                              class="flex-grow-1 py-2 pr-3"
                              :position="position"
                            >                          
                              <template #field>
                                <v-card 
                                  class="pt-2 mr-2 rounded-lg flex-grow-1 inyand2--text inputcolor"
                                  elevation="0"
                                >
                                  <div
                                    v-for="(value,i) in project.users"
                                    :key="i"
                                    class="px-2"
                                  >
                                    <span>{{value.fullname}}</span>
                                    <v-icon
                                      @click="deluser(i)"
                                      
                                      x-small
                                      class="pl-1"
                                      color="close_icons"
                                    >
                                    mdi-close-thick                                      
                                    </v-icon>
                                  </div>
                                </v-card>
                              </template>
                              <template
                                #buttons
                              >
                              <SelectUserMenu
                                :mod="'users'"
                                :addtext="project.users.length?'Изменить':'Добавить'"
                              />
                              </template>
                            </ColText>
                       
                        </v-card-text>
                        <v-card-text class="pt-0 pb-1">
                          <v-row class="justify-end">
                            <v-col class="flex-grow-0 bg3 pr-0 pt-0">
                              <v-btn
                                icon
                                @click="save"
                              >
                                <v-icon color="btns">mdi-arrow-u-left-bottom</v-icon>
                              </v-btn>
                            </v-col>
                            <v-col class="flex-grow-0 pa-0 pr-1">
                              <v-btn
                                icon
                              >
                                <v-icon color="open_icons">mdi-content-save</v-icon>
                              </v-btn>
                            </v-col>           
                          </v-row>
                        </v-card-text>
    
          </v-card>

          <v-card color="main_theme">
            <v-card-actions>
              <v-row class="pa-2">
                <v-col
                  v-for ="(btns_name) in btns_otchet"
                  :key="btns_name"
                  lg=6
                  sm=6
                  class="pa-1 "
                >
                  <v-btn
                    color="btns"
                    outlined
                    block
                  >
                    {{btns_name}}
                  </v-btn>
                </v-col>
              </v-row>
            </v-card-actions>
          </v-card>
  </v-col>


    <v-col class="flex-col pl-0 pb-3 rightCard"
      lg=8
      md=12
      sm=12
    >
        <v-tabs-items
          v-model="tab"
          class="transparent flex-col flex-grow-1"
          outlined
        >
              <!-- <v-tab-item
        
        v-for="(value, i) in tabs"
        :key="i"
      > -->
          <v-tab-item
            v-for="(value, l) in tabs"
            :key="value"
            :value="'tab-' + l"
            class="h-100"
          >
          
           <v-card 
                class="flex-col flex-grow-1 rounded"
                color="main_theme"
                outlined
                
               
                      >
         
          
                      <!-- <v-card-text 
                    
                      > -->
  <!-- :key="'tab-0'"
                      v-show="tab=='tab-0'?true:false"-->
                                
                                  <v-card-title>
                                    План-график
                                  </v-card-title>
                                  <v-card-text class="flex-col flex-grow-1">
                                            Картинка ганта
            
                                  </v-card-text>
                                  <v-card-title>
                                    Задачи
                                      <v-btn
                                          color="btns"
                                          outlined
                                        
                                          @click="createtask"
                                        >
                                          Создать задачу
                                        </v-btn>
                                  </v-card-title>
                                  <v-card-text class="flex-col flex-grow-1">
                                    <v-row class=" flex-grow-0">
                                      <v-col
                                        lg=6
                                      >
                                        <v-data-table
                                          @dblclick:row="clickRow"
                                          :headers="taskheaders"
                                          :items="project.tasks"
                                          :items-per-page="5"
                                          class="elevation-1"
                                        ></v-data-table>
                                      </v-col>
                                      <v-col
                              
                                        lg=6  
                                      >
                                      {{project.tasks[0]}}
          
                                      </v-col>
                                    </v-row>
                                  

            
                                  </v-card-text>


                      <!-- </v-card-text>  -->
                      
              <!-- Чат -->
                      <v-card-text 
                 
                      :class="tab=='tab-1'?'':''"
                       :key="'tab-1'"
                       v-show="tab=='tab-1'?true:false"
                       
                      >

                           <Chat :wbs='ws' :mes='chatmes' :delmes='delmes'/>
                        </v-card-text>
                   
                      </v-card>

         </v-tab-item>
        </v-tabs-items>

    </v-col>
  </v-row>

</v-container>
</template>


<script>
import datepicker from "@/utils/datepiker.js"
import SelectUserMenu from '@/components/UI/SelectUserMenu.vue'
import BtnsOut from '@/components/UI/BtnsOut.vue'
import ColText from '@/components/projects/ColText.vue'
import chat from '@/components/chats/chat.vue'
import {axiosInstance} from '@/utils/api'
import { createNamespacedHelpers } from "vuex";
const { mapGetters, mapMutations} = createNamespacedHelpers("projectstate");
import getFilters from '@/utils/filterutil'

export default {
  name: "project",
    components: {        
      SelectUserMenu,
      BtnsOut,
      ColText,
      chat
       
       
    },
    mixins:[datepicker,getFilters],
    data: () => ({
        taskheaders:[
            {text:"Задача",
            value:"name"},
             {text:"Ответственный",
            value:"responsible.sn"},
             {text:"Статус",
            value:"status.name"},
             {text:"Срок",
            value:"dateend"},

        ],
        delmes:null,
        chatmes:null,
        picker:[0,0],
        datekey:0,
        tabs: ['Карточка', 'Чат', 'История'],
        btns_otchet: ['Приказ', 'План', 'Паспорт', 'Отчет', 'План КС', 'Итоговый отчет', 'Состав РГ', 'Протокол'],
        menu:null,
        tab: null,
        ws: null,
        position: true,
        project:{
          id:"",
          name: "",          
       
          status: {
            id: 1,
           
          },
          director: {
            id: 0
          },
          secretary: {
            id: 0
          },
          rp: {
            id: 0
          },
          users: [  ],
          coordinator: {
            id: 0
          },
          ptype: {
            id: 0
          },
          datestart: "",
          dateend: "",
          tasks: [],
          author: {
            id: 0
          },
         
},        
          selectdatafields:{},
          selectfields:{project__type:{name:"Тип",basefield:'ptype'},
                        project__status:{name:"Статус",basefield:'status'}},
       


          box: {},

          
          userFields: [
                    {text: 'Директор', icons: 'mdi-account-plus', model: 'director'},
                    {text: 'Руководитель', icons: 'mdi-account-plus', model: 'rp'},
                    {text: 'Секретарь', icons: 'mdi-account-plus', model: 'secretary'},
                    {text: 'Координатор', icons: 'mdi-account-plus', model: 'coordinator'},
          ],

        
                  
          chalenge: {'ИСУП': [{name: 'Карточка задания'}, 
                  
                  {name: 'Всплывающее окно'},
                  {name: 'Все дер'}],
                  'УКД': [{name: 'Статистика по пользователем'}] } 
          
    }),

    methods: {
      ...mapMutations(["setProject"]),
      ...mapGetters(["getProject"]),
       console(val){
        console.log(val);
       },
      clickRow(e,row){
      
        this.$router.push(`${this.$route.path}/task/${row.item.id}`)
      },
      build(data){
         this.project=data;
          this.setProject(this.project)
      },
      deletedMessage(data){
              this.delmes=data

          },
        newChatMessage(data){
        this.chatmes=data        
      },

      deluser(i){
        this.project.users.splice(i,1)
      },
     
        editField(field) {
            
            this.box=field
        },
        save() {
          this.ws.send({"action":"update","payload":this.project})

        },
        async createtask(){            
            let res = await axiosInstance.get(`/createtask/?parent=${this.project.id}`)
           
            this.$router.push(`/project/${this.project.id}/task/${res.data.id}`)
        },
  
    },
   
 
    async mounted() {
    
        let s = await this.getFilters([{"project__status": { "sort": "id", "filters":{},"exclude":["projects"]}},
                                        {"project__type": { "sort": "id", "filters":{},"exclude":["projects"]}}
        ])
        
        this.selectdatafields = s.data
        // this.projectstatuses=s.data.project__status
        // this.projecttypes = s.data.project__type
        
        this.ws = new this.$pws()
        this.ws.start(this.$route.fullPath);
        this.ws.addEvent('onmessage', (event) => {
            const data = JSON.parse(event.data);
            if ("action" in data) {this[data.action](data.payload)}
            else{console.log(data)}
           
        })
       
    }
}
</script>

<style lang="scss">
@import "@/utils/colors.scss";




.project_css .v-window-item--active,.project_css  .v-window__container, .project_css .v-window {
  flex-grow: 1;
  display: flex !important;
  flex-direction: column;
}

.v-menu__content {
    box-shadow: 0px 5px 5px -3px rgb(0 0 0 / 0%), 0px 8px 10px 1px rgb(0 0 0 / 0%), 0px 3px 14px 2px rgb(0 0 0 / 10%);
    border-radius: 2px;
}

.inputext {
  font-size: 0.9rem;
}



.grow-table {

  overflow-y: scroll;
  .v-list-group :nth-child(1) {
  color:  var(--v-inyand2-base)!important;
  font-size: 0.8rem;
  // background: var(--v-menus-base)!important;
}
}

.inputext {
  font-size: 0.9rem;
  color: black;
}

.chat {
  min-height: 25%;
}

.iconsh 
  .v-icon.v-icon {
    font-size: 14px!important;
}

.v-tab-item >>> .v-window__container {
  flex-grow: 1 !important;

}


</style>