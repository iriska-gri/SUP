<template>

<!-- :class="!$vuetify.theme.dark?'auchlight':'auchdark'" -->
  <v-col
    class="pa-0 flex-col d-flex fonback"
  >
    <v-tabs
      class="flex-grow-0 px-1 pl-2 pr-0 pt-2 "
      color="transparent"
      background-color="transparent"
      v-model="tab"
    >
      <v-tab 
        v-for="(val,key) in docktype"
        :key="key"
        active-class="select_item"
        class="relax_item mr-2 flex-col d-flex"
        :ripple="false"
        @click="dialogtheme.title=key"
      >
      {{key}}
      </v-tab>
      <div class="ml-auto mt-auto pr-2 ">        
            <v-btn           
              @click="docktype[dialogtheme.title].createnew ? dialogger(): dialogNo()"
              title = " новый"
              textbtn="text-uppercase"
             
              color="open_icons"
            >   Создать     
            </v-btn>
            <v-btn 
              class="ml-4"          
             
    
              title = ""
              textbtn="text-uppercase"
              @click="docktype[dialogtheme.title].createnew ?uploader(): dialogNo()"
              color="primary"
            >     Загрузить   
            </v-btn>
         
      </div>
    </v-tabs>
    <v-tabs-items
      class="flex-grow-1 flex-col d-flex bgtrans"
      v-model="tab"
    >
      <v-tab-item
        v-for="(val,key) in docktype"
        :key="`tabitem${key}`"
        class="flex-grow-1"
      >
        <v-card
          class="flex-col d-flex"
          color="transparent pa-2"
          flat
        >

          <v-data-table
            height=719
            :items-per-page= "-1"
            :headers="headers"
            :items="val.data"
            hide-default-footer
            class="elevation-1 h-100"
            @dblclick:row='clickRow'
          >
            <template v-slot:[`item.approved`]="{ item }">
              <span v-if="(item.approved==1) && (item.approver.id==getUser.id)">Требуется ваше участие</span>
              <span v-else-if="item.approved==1">На утверждении</span>          
              <span v-else-if="item.approved==2">Отклонено</span>
              <span v-else-if="item.approved==3">Утверждено</span>
            </template>    
            <template v-slot:[`item.accepters`]="{ item }">
              <v-progress-linear
                v-if="(item.accepters.length>0) && (item.accepters[0].accepted>0)"
                :value="calculateaccepted(item.accepters)/item.accepters.length*100"
                height="15"
                buffer-value="100"
              >
                <strong>
                  {{calculateaccepted(item.accepters)}}/{{ item.accepters.length }}
                </strong>
              </v-progress-linear>
            </template>  
          </v-data-table>
        </v-card>
      </v-tab-item>
    </v-tabs-items>



<v-dialog
      v-model="notbuilddock"
      width="600"
    >
      <v-card
        elevation="2"
        outlined
      >
        <v-card-title
        class="pt-0 px-0"
        >
           <v-alert
           class="flex-grow-1"
      border="top"
      color="red lighten-2"
      dark
    >
      Документ {{dialogtheme.title}}
    </v-alert>
         
        </v-card-title>
        <v-card-text>
           
          <div>
            К сожалению, {{docktype[dialogtheme.title].previous}} проекта {{getProject().name}} 
          </div>
          <div>
            <strong>НЕ УТРВЕЖДЕН{{docktype[dialogtheme.title].previous=="Распоряжение"?'О':''}}</strong>
          </div>
          <div>
          Заполнение формы документа невозможно.          
          </div>
          <div>
            вы можете скачать шаблон
          </div>
        </v-card-text>
        <v-card-actions>

        </v-card-actions>
      </v-card>
    </v-dialog>



    <v-dialog
      v-model="uploaddialog"
      width="600"
    >
      <v-card
        elevation="2"
        outlined
      >
        <v-card-title>
          Подгружаем файл ({{dialogtheme.title}})
        </v-card-title>
        <v-card-text>
          <div>
            Для прикрепления документа, необходимо заполнить некоторые поля
          </div>
          <div>
            <v-text-field
              label="Номер документа"
              v-model="docnumber"
              hide-details="auto"
            ></v-text-field>
          </div>
          <div>
            <v-file-input
              v-model="chosenFile"
              show-size
              truncate-length="15"
            ></v-file-input>
          </div>
          <div>
            <v-autocomplete
              :items="getprojectuniquePersons()"
              return-object
              item-text="fullname"
              label="Кто подписывал/будет подписывать"
              v-model="dialogtheme.data.approver"
            >
              <template v-slot:item="item">
                <v-list-item-content>
                  {{item.item.fullname}} ({{item.item.position.name}}) 
                </v-list-item-content>
              </template>
            </v-autocomplete>
          </div>
          <div>
            <v-select
              v-model="Selectapprovmodel"
              :items="Selectapprov"
              label="Подписан или нет"
            ></v-select>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-btn
            @click="sendfile"
            size="small"
            color="passiv_text"
          >
            Загрузить
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Диалоговое окно документации -->
    <v-dialog
      v-model="dialog"
      fullscreen
      hide-overlay
      transition="scale-transition"
      :content-class="dialog?'flex-col d-flex':''"
    >
      <Cards
        :color="!$vuetify.theme.dark?'auchlight':'auchdark'"
      >
        <template #cards>
          <v-toolbar
            dark
            color="main_theme"
            class="flex-grow-0 flex-col d-flex rounded"
            height=35
          >      
            <v-toolbar-title class="flex-grow-1 flex-col d-flex px-2">
              <v-row>
                <v-col
                  class="align-self-center inyand2--text"
                  xl="3"
                >
                  {{dialogtheme.tophead}}
               
                </v-col>
                <v-col
                  class="align-self-center pl-0 inyand2--text font-weight-light body-2 flex-row"
                  xl="4"
                >
                  <v-tooltip bottom>
                      <template v-slot:activator="{ on, attrs }">
                        <v-btn
                          icon
                          :light="$vuetify.theme.dark?false:true"
                          :disabled="disableEdition"
                          @click="saver"
                          v-bind="attrs"
                          v-on="on"
                        >
                          <v-icon color="open_icons">
                            mdi-content-save
                          </v-icon>
                        </v-btn>
                      </template>
                      <span>Сохранить (недоступно после отправки на согласование или утверждение)</span>
                  </v-tooltip>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                        :light="$vuetify.theme.dark?false:true"
                        :disabled="disableEdition"
                        @click="reeditabler"
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-file-find
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>Режим просмотра/редактирования</span>
                  </v-tooltip>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        :disabled="'path' in dialogtheme.data && (!(dialogtheme.data.path=== null) && dialogtheme.data.path.length>0)"
                        icon
                        :light="$vuetify.theme.dark?false:true"
                        @click="copydock"
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-text-box-multiple-outline
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>Новый документ на основе этого</span>
                  </v-tooltip>
                  <v-tooltip bottom>
                  <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                        color="primary"
                        @click="dialogger()"
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-text-box-plus-outline
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>Новый документ</span>
                  </v-tooltip>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                       <v-btn
                        v-if="pathfile()"
                        :light="$vuetify.theme.dark?false:true"
                        icon
                        :id="idConfig.download"
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-file-download-outline
                        </v-icon>
                      </v-btn>
                      <v-btn
                        v-else
                        :disabled="('id' in dialogtheme.data)==false"
                        icon
                        @click="downloadacceptlist(false)"
                        :light="$vuetify.theme.dark?false:true"
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-file-download-outline
                        </v-icon>
                      </v-btn>
                    </template>
                      <span>Скачать</span>
                  </v-tooltip>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                        :disabled="dialogtheme.data.accepters.length==0"
                        @click="downloadacceptlist(true)"
                        :light="$vuetify.theme.dark?false:true"
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-format-list-checks
                        </v-icon>
                      </v-btn>
                    </template>
                      <span>Скачать лист согласования</span>
                  </v-tooltip>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                        @click="deleter"
                        :light="$vuetify.theme.dark?false:true"
                        :disabled="(disableEdition || !('id' in dialogtheme.data) || dialogtheme.data.approved>0 || (dialogtheme.data.accepters.length>0 && dialogtheme.data.accepters[0].accepted>0))"
                        v-bind="attrs"
                        v-on="on"
                      >
                      
                        <v-icon color="btns">
                          mdi-delete-forever-outline
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>Удалить документ (недоступно после отправки на согласование или утверждение)</span>
                  </v-tooltip>
                  <!-- <v-btn :id="idConfig.zoomOut">Zoom out</v-btn> -->

                   <!-- <v-btn  :id="idConfig.zoomIn">Zoom in</v-btn>
                  <v-btn  :id="idConfig.previousPage">Предыдущая</v-btn>
                  
                  <v-btn  :id="idConfig.nextPage">Следующая</v-btn>
                  <v-btn  :id="idConfig.presentationMode">ВЭ</v-btn> -->

                  <pdf-toolbar
                    ref="pdftoolbar"
                    v-if="pathfile()"
                  />


















                </v-col>
                <v-col class="align-self-center text-end">
                  <MyIco
                    @click="dialog = false"
                    size="small"
                    icons = 'mdi-close-thick'
                    color="passiv_text"
                  />
                </v-col>
              </v-row>
            </v-toolbar-title>
          </v-toolbar>
          <Cards
            class="mt-3"
          >
            <template #cards>
              <v-row>
                <v-col
                  class="d-flex flex-col"
                  xl=10
                >
                  <v-row class="justify-center">
                    
                    <v-col
                      class="d-flex flex-col"
                      :xl="pathfile()?12:['План-график', 'Отчет'].includes(dialogtheme.title)?12:['Итог'].includes(dialogtheme.title)?9:5"
                      
                     
                    >
                      <Cards
                        color="inyand"
                        v-if="'data' in dialogtheme &&  'path' in dialogtheme.data && (!(dialogtheme.data.path===null)&&dialogtheme.data.path.length>0)"
                      > 
                        <template #cards>
 
                          <vue-pdf-app  v-if="dialogtheme.data.path.substr(dialogtheme.data.path.length-3)=='pdf'" :config="config" :pageScale="100" :id-config="idConfig" :pdf="srcstring()" >
                            <template #viewer-prepend>
                                    <div class="viewer-prepend">
                                     
                                    </div>
                                  </template>
                         </vue-pdf-app>



                          <!-- <pdf :src="srcstring()" v-if="dialogtheme.data.path.substr(dialogtheme.data.path.length-3)=='pdf'"></pdf> -->
    <!--   
                            <pdf  v-if="dialogtheme.data.path.substr(dialogtheme.data.path.length-3)=='pdf'"
                            style="max-width:40px !important"
                            :src="" :page="1"
                            :resize="true"
                            :rotate="1"
                            >

                            <template slot="loading">
                                  Загружаю....
                                </template>
                            </pdf> -->
                            <!-- v-else -->
                        <v-img v-else
                            :src="srcstring()"
                        ></v-img>
                      </template>
                      </Cards>
                      <Cards
                        color="inyand"
                        :ma="'mr-0 mb-3'"
                        v-else
                      > 
                        <template #cards>
                        <Cards
                        color="inyand"
                        class="overflow-x-auto"
                        height='0'
                        :elevation= 0
                        
                       
                      > 
                       
                        <template #cards>
                          <div>
                            <!-- {{dialogtheme.title}} -->
                          <dockhead
                            v-if="['Приказ', 'Распоряжение'].includes(dialogtheme.title)"
                            :title="dialogtheme.title.toUpperCase()"
                            :editable="editable" 
                          />
                          <order
                            v-if="dialogtheme.title=='Приказ'"
                            ref="mydock" 
                            :editable="editable"                          
                            :dialogdata="dialogtheme.data"
                            :approver="dialogtheme.data.approver"
                          />
                         
                          <planks
                            v-else-if="dialogtheme.title=='План-график'"
                            ref="mydock" 
                            :editable="editable"                          
                            :dialogdata="dialogtheme.data"
                            :approver="dialogtheme.data.approver"
                          />
                          <disposition
                            v-else-if="dialogtheme.title=='Распоряжение'"
                            ref="mydock" 
                            :editable="editable"                          
                            :dialogdata="dialogtheme.data"
                            :approver="dialogtheme.data.approver"
                          />
                          
                          <report
                            v-else-if="dialogtheme.title=='Отчет'"
                            ref="mydock" 
                            :editable="editable"                          
                            :dialogdata="dialogtheme.data"
                            :approver="dialogtheme.data.approver"
                          />
                          <final-report
                             v-else-if="dialogtheme.title=='Итог'"
                            ref="mydock" 
                            :editable="editable"                          
                            :dialogdata="dialogtheme.data"
                            :approver="dialogtheme.data.approver"
                          />                         
                          </div>
                        </template>
                      </Cards>
                             </template>
                      </Cards>
                    </v-col>
                  </v-row>
                </v-col>
                <v-col
                  class="d-flex flex-col"
                  cols=2
                >
                  <Cards>
                    <template #cards>
                      <v-row class="flex-grow-0">
                        <v-col class="d-flex flex-col pb-0">
                          <v-autocomplete
                            v-model="dialogtheme.data.approver"
                            :items="getprojectuniquePersons()"
                            item-text="id"
                            dense
                            return-object
                            :disabled="disableEdition"
                            :label=" dialogtheme.data.approved==0?'Утвердить с:':'Утверждает'"
                            class="inputext iconsh"
                          >
                            <template v-slot:selection="item">
                              <v-list-item-content>
                                  {{item.item.fullname}}
                              </v-list-item-content>
                            </template>
                            <template v-slot:item="item">
                              <v-list-item-content>
                                  {{item.item.fullname}} ({{item.item.position.name}}) 
                              </v-list-item-content>
                            </template>
                          </v-autocomplete>
                        </v-col>
                      </v-row>
                      <v-row
                        class="flex-grow-0"
                        v-if="dialogtheme.data.approved>1"
                      >
                        <v-col>
                          {{approvertext(dialogtheme.data.approved)}}
                        </v-col>
                      </v-row>
                      <v-row
                        class="flex-grow-0"
                        v-if="dialogtheme.data.approved>1"
                      >
                        <v-col>
                          <v-menu
                            v-if="dialogtheme.data.comment"                                                  
                            :close-on-content-click="false"
                            :nudge-width="200"
                            left
                            offset-x
                          >
                            <template v-slot:activator="{ on, attrs }">
                              <v-list-item-subtitle
                                v-bind="attrs"
                                v-on="on"
                              >
                                <v-icon x-small>
                                  mdi-message-outline
                                </v-icon>
                                  {{dialogtheme.data.comment.length>30? `${dialogtheme.data.comment.substring(0,30)}...` :dialogtheme.data.comment}}
                              </v-list-item-subtitle>
                            </template>
                              <v-card>
                                {{dialogtheme.data.comment}}
                              </v-card>
                          </v-menu>
                        </v-col>
                      </v-row>
                      <v-row class="flex-grow-0">
                        <v-col class="py-0">
                          {{!dialogtheme.data.accepters.length || (!('accepted' in dialogtheme.data.accepters[0]) ||dialogtheme.data.accepters[0].accepted==0)?"Согласовать с:":"Согласование"}}
                        </v-col>
                        <v-col class="py-0 text-end" v-if="!dialogtheme.data.accepters.length || (!('accepted' in dialogtheme.data.accepters[0]) ||dialogtheme.data.accepters[0].accepted==0)">
                          <SelectUserLite :selectedUs="dialogtheme.data.accepters" :excludeUsers="dialogtheme.data.approver===null?[]:[dialogtheme.data.approver]"/>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col class="d-flex flex-col py-0">
                          <InputText
                            class="maxHi"
                          >
                            <template #insert>
                              <div v-if="!dialogtheme.data.accepters.length">                            
                                Не выбраны
                              </div>
                              <div class="pa-0 pt-1" v-else-if="dialogtheme.data.accepters.length ">
                              <!-- && dialogtheme.data.accepters[0].accepted>0"> -->
                                <v-list
                                  class="pa-0 rounded-lg mb-2"
                                  dense v-for="(item,i) in dialogtheme.data.accepters"
                                  :key="`list${i}`"
                                >                                                  
                                  <v-list-item>
                                    <v-list-item-content class="pa-0">
                                      <v-list-item-title class="pa-0">
                                        {{item.fullname}}
                                      </v-list-item-title>
                                      <v-list-item-subtitle>
                                        <strong>
                                          {{acceptortext(item.accepted)}}
                                        </strong>
                                      </v-list-item-subtitle>
                                      <v-menu
                                        v-if="item.comment"                                                  
                                        :close-on-content-click="false"
                                        :nudge-width="200"
                                        left
                                        offset-x
                                      >
                                        <!-- <template v-slot:activator="{ on, attrs }">
                                          <v-list-item-subtitle
                                            v-bind="attrs"
                                            v-on="on"
                                          >
                                            <v-icon x-small>
                                              mdi-message-outline
                                            </v-icon>
                                              {{item.comment.length>30? `${item.comment.substring(0,30)}...` :item.comment}}
                                            </v-list-item-subtitle>
                                        </template> -->

                                        <v-card>      
                                          {{item.comment}}  
                                        </v-card>
                                      </v-menu>
                                    </v-list-item-content>                                  
                                  </v-list-item>                              
                                </v-list>                         
                              </div>
                            </template>
                          </InputText>
                        </v-col>
                      </v-row>
                      <v-row class="flex-grow-0 mb-0">
                        <v-col class="pb-0">      
                          <BtnsOut
                            v-if="dialogtheme.data.accepters.length && dialogtheme.data.accepters[0].accepted==0"
                            @click="saver('toaccept')"
                            title = "На согласование"
                            :block = true
                          />
                        </v-col>
                      </v-row>
                <!-- {{dialogtheme.data}} -->
                      <v-row
                        class="flex-grow-0 my-0"
                        v-if="dialogtheme.data.approver && 'id' in dialogtheme.data.approver && dialogtheme.data.approved==0"
                      >
                        <v-col class="pb-0">
                          <BtnsOut
                            @click="saver('toapprover')"
                            title = "На утверждение"
                            :block = true
                          />
                        </v-col>
                      </v-row>
                      <v-row
                        class="flex-grow-0 my-0"
                        v-if="responser.view"
                      >
                        <v-col class="py-0">
                          <v-textarea
                            v-if="responser.ta_model=='approver'"
                            v-model="dialogtheme.data.comment"                  
                          >
                          </v-textarea>
                          <v-textarea
                            v-else-if="responser.ta_model=='accepters'"
                            v-model="dialogtheme.data.accepters[responser.index].comment"                  
                          ></v-textarea>
                        </v-col>
                      </v-row>
                      <v-row
                        class="flex-grow-0"
                        v-if="responser.view"
                      >
                        <v-col class="py-0">
                          <BtnsOut
                            @click="confirmOrNot(3)"
                            title = "Принять"
                          />
                        </v-col>
                        <v-col class="pt-0">
                          <BtnsOut
                            @click="confirmOrNot(2)"
                            title = "Отклонить"
                          />
                        </v-col>
                      </v-row>
                    </template>
                  </Cards>
                </v-col>
              </v-row>
                <!--  -->
            </template>
          </Cards>
        </template>
      </Cards>  
    </v-dialog>



















  </v-col>
























</template>

<script>
// import pdf from 'vue-pdf'
import VuePdfApp from "vue-pdf-app";
// import "@/utils/viewer.txt";
import "vue-pdf-app/dist/icons/main.css";
import moment from 'moment';
import { createNamespacedHelpers } from "vuex";
import {axiosInstance, axiosMp, URL} from '@/utils/api'
import PdfToolbar from "../UI/PdfToolbar"
import Order from '@/components/projects/documents/Order'
import Dockhead from '@/components/projects/documents/dockhead'
import SelectUserLite from '../UI/SelectUserLite.vue';
import Planks from '@/components/projects/documents/Planks';
import Report from '@/components/projects/documents/Report';
import FinalReport from '@/components/projects/documents/FinalReport';
import disposition from './documents/disposition.vue';
const  projectstate =createNamespacedHelpers("projectstate");
const userinfo = createNamespacedHelpers("auth");
export default {
name: 'ProjectDocks',
components:{
    Dockhead,
    Order,
    SelectUserLite,
    Planks,
    Report,
    FinalReport,
    disposition,
    PdfToolbar,
    VuePdfApp

    // pdf,
   
 

},
props:{
    documents:{
        type:Array,
        default:()=>[]
    }
        
    
},
data(){
    return{
       config: { toolbar:false   },
      notbuilddock:false,
      idConfig: { zoomIn: "zoomInId",
                  zoomOut: "zoomOutId",
                  download:"downloadId",
                  presentationMode:"presentationModeId",
                  previousPage:'previousPage',
                  // pageNumber:"pageNumberId",
                  nextPage:"nextPageId"
                  },
      
      chosenFile: null,
      Selectapprov: ['Не подписан','Подписан'],
      Selectapprovmodel:null,
      disableEdition:false,
      editable:false,
      acceptormenu:false,
      responser:{view:false, ta_model:null, index:null},
     
       headers: [
         {text:"Номер",value:"docnumber"},
          {
            text: 'Создан',           
            value: 'created',
          },
          {text:'Утвержден',
          value:"approved"},
          {text:"Согласование (реакции)",
          value:"accepters"
          },
     
        ],

       dialog:false,
        docktype:{"Приказ":{ action:"order",data:[],previous:false, createnew:true,disabler:false},
                  "Распоряжение":{ action:"passport",data:[],previous:false, createnew:true,disabler:false},
                  // "Состав РГ":{ action:"workgroup",data:[],model:{}},
                  // "План":{ action:"plan",data:[],model:{}},
                  // "План-график":{ action:"plan_ks",data:[],previous:"Распоряжение", createnew:false,disabler:false},
                  "План-график":{ action:"plan_ks",data:[],previous:false, createnew:true,disabler:false},
                  "Отчет":{ action:"report",data:[],previous:false, createnew:true,disabler:false},
                  "Итог":{ action:"outcome",data:[],previous:false, createnew:true,disabler:false},
                  "Протокол":{ action:"protocol",data:[],previous:false,  createnew:true,disabler:false}, 

    },
    tab: null,
    dialogtheme:{
        tophead:"",
        title:"Приказ",
        created:"",
        data:{approved:0, path:null, approver:{}, comment:null, accepters:[{comment:""}]},
        
    },
    uploadPercentage:null,
    uploaddialog:false,
    docnumber:''
    // false



    }
},


methods:{
    ...projectstate.mapGetters(["getProject","getprojectuniquePersons"]),
    
    pathfile(){
       return 'path' in this.dialogtheme.data && (!(this.dialogtheme.data.path=== null) && this.dialogtheme.data.path.length>0) && this.dialogtheme.data.path.substr(this.dialogtheme.data.path.length-3)=='pdf'
    },
    srcstring(){
      return  `http://${URL}/api${this.dialogtheme.data.path}`
    },
    async downloadacceptlist(confirmationmod){
      let res = await axiosInstance.get(`/project/downloaddock/${this.dialogtheme.data.id}/?confirmationmod=${confirmationmod}`)
      
        let link=document.createElement('a');
        link.href=`data:application/vnd.openxmlformats-officedocument.wordprocessingml.document;base64,${res.data}`
        link.download=`${this.dialogtheme.title}${confirmationmod?"__согласование__":""}.docx`;
        link.click();
        link.remove()
    },
  idtonewdock(payload){
    console.log(this.dialogtheme.data,"=================------idtonewdock-----====================");
    this.dialogtheme.data.id=payload.id
    let nob = Object.assign({vrersion:payload.vrersion},this.dialogtheme.data)
    this.dialogtheme.data=nob
    
  },



      uploader(){       
        
        this.dialogtheme.data = {accepters:[],approver:{},approved:0}
        this.uploaddialog=true
            },
    async sendfile(){
        console.log(`this.dialogtheme.data.approver`, this.dialogtheme.data.approver);
       let formData = new FormData();              
        formData.append('file',this.chosenFile);       
        formData.append("approver", 'id' in this.dialogtheme.data.approver?this.dialogtheme.data.approver.id:0)
        formData.append("approved", this.Selectapprov=='Подписан'?3:0)
        formData.append('doctype', this.dialogtheme.title)
        formData.append('docnumber',this.docnumber)
        
   
            let item_id= this.getProject().id
            let res =await axiosMp.post( `/project/${item_id}/uploaddock`,formData)
            if (res.data.created=="ok"){
                this.uploaddialog=false
                this.chosenFile=null,
                this.docnumber=""
                this.dialogtheme.data={approved:0, path:null, approver:{}, comment:null, accepters:[{comment:""}]},
                
               this.$emit("savedock",['getprojectdocks', ''])
            };
          
        
    },


    reeditabler(){
      if(this.canIedit()){
      this.editable=!this.editable
      this.dialogtheme.tophead = !this.editable?"Просмотр документа":"Редактирование документа"
      }else{
        this.editable=false
        this.dialogtheme.tophead ="Просмотр документа"

      }
    },

   canIedit(){
    if ( (this.dialogtheme.data.approved==0)&&
         ((this.dialogtheme.data.accepters.length && this.dialogtheme.data.accepters[0].accepted==0)||
         (!this.dialogtheme.data.accepters.length))
         
         )
         {
          return true
         }
    return false
  },



    calculateaccepted(items){      
      let app=0
      items.forEach(el=>{if (el.accepted>1)app++
    })
   
    return app
    },

    needtoresponse(){
       
      let myid=this.getUser.id
       if(this.dialogtheme.data.approver&&  this.dialogtheme.data.approved==1 && this.dialogtheme.data.approver.id==myid ) {
         this.responser={view:true, ta_model:'approver'}
         return
      }
      if(this.dialogtheme.data.accepters.length){
        //  && this.dialogtheme.data.accepters[0].accepted>0
           let indx = [...this.dialogtheme.data.accepters].findIndex(el=>el.id==myid)
           if (indx>-1 && this.dialogtheme.data.accepters[indx].accepted==1) {
              this.responser={view:true, ta_model:'accepters',index:indx}
            return  
           }

      }
      // else {this.responser={view:true, type:null, index:null} }
     
      // if (!acceptors.length)return this.responser={view:false,type:null}
      
     this.responser={view:false, ta_model:null, index:null}
    },
    acceptortext(it){
      if (it==0) return ""
      else if(it==1)return "На согласовании"
      else if(it==2)return "Отклонено"      
      else return "Согласовано"
    },
    approvertext(it){
      if (it==0) return ""
      else if(it==1)return "На утверждении"
      else if(it==2)return "Отклонено"      
      else return "Согласовано"

    },

    confirmOrNot(result){
  
      let conf = {id: this.dialogtheme.data.id}
      if (this.responser.ta_model=='approver'){

        this.dialogtheme.data.approved=result
        conf['approved']=result
        conf['comment']=this.dialogtheme.data.comment
        conf['version']=this.$refs.mydock.orderdock
        conf.version['approver']=this.dialogtheme.data.approver
        this.needtoresponse()
        this.$emit("savedock",['approver_update', conf])
      }
      else if(this.responser.ta_model=='accepters'){
        this.dialogtheme.data.accepters[this.responser.index].accepted=result
        conf['accepters']=this.dialogtheme.data.accepters[this.responser.index]
        console.log(`conf`, conf);
        this.needtoresponse()
        this.$emit("savedock",['acceptor_update', conf])
      }

    },
    deleter(){
        //  console.log(this.dialogtheme.data.path)
      this.$emit("savedock",['doc_deleter', {id:this.dialogtheme.data.id, path:this.dialogtheme.data.path}])
    },


    saver(type="justsave", act='project_savedock'){
        
      if(type=="toapprover"){
          this.dialogtheme.data.approved=1
          this.disableEdition=!this.canIedit()
          this.editable=false
        }
        else if(type=='toaccept'){
            this.disableEdition=!this.canIedit()
            this.dialogtheme.data.accepters.forEach(el=>el.accepted=1)

            this.editable=false
        }
        console.log("DIALOG", this.$refs.mydock.orderdock);
       let savedata = {doctype__name: this.dialogtheme.title, 
                    version: (!(this.dialogtheme.data.path===null)) &&this.dialogtheme.data.path.length >0?{}:this.$refs.mydock.orderdock,
                    approver: (!(this.dialogtheme.data.approver===null)) && 'id' in this.dialogtheme.data.approver?this.dialogtheme.data.approver.id:null,
                    approved:this.dialogtheme.data.approved,
                    comment:this.dialogtheme.data.comment,
                    accepters:this.dialogtheme.data.accepters,
                    actiontype: type
                    }
        if (this.dialogtheme.title=='Отчет'){
        
          savedata.version.planresult = this.$refs.mydock.planresult
          savedata.version.problemsrisks = this.$refs.mydock.problemsrisks
        }
        if ("id" in this.dialogtheme.data) savedata["id"]=this.dialogtheme.data.id
        
        // console.log(this.$refs.mydock.orderdock);
        
        this.$emit("savedock",[act, savedata])
    },

    async copyrunview(id){
       let res = await axiosInstance.get(`/getdock/${id}`)
      this.dialogtheme.data = res.data 
     
      this.disableEdition=!this.canIedit()
      this.needtoresponse()
      this.dialog = true

    },

    copydock(){
         delete this.dialogtheme.data.id;
         this.saver("justsave",'project__clonedock')
    },
    async clickRow(row,item){
  
      this.dialogtheme.title = item.item.doctype.name 
      this.dialogtheme.tophead = !this.editable?"Просмотр документа":"Редактирование документа"
      let res = await axiosInstance.get(`/getdock/${item.item.id}`)
      this.dialogtheme.data = res.data 
      console.log(this.dialogtheme.data);
      this.disableEdition=!this.canIedit()
      this.needtoresponse()
      this.dialog = true
   
    },

    async dialogger(){
        // console.log(item);
       
        // this.dialogtheme.title = item 
        this.dialogtheme.tophead = "Создание нового документа" 
        
        this.dialogtheme.data = {accepters:[],approver:{},approved:0,path:null, comment:null}
        this.responser={view:false, ta_model:null}
        this.editable=true
        this.disableEdition=!this.canIedit()        
        this.dialog = true
    },
    dialogNo(){
      // this.dialogtheme.title = item
      this.notbuilddock=true
      
    }
},
computed:{
  ...userinfo.mapGetters(["getUser"]),

},



watch:{
    documents(val){
      console.log(`sdddddd`)

      for(let key in this.docktype){
         this.docktype[key].data=[]
         
         if (this.docktype[key].previous!=false){
        let indx =   val.findIndex(e=>(e.doctype.name==this.docktype[key].previous && e.approved==3))
        console.log(`indx,this.docktype[key]`, indx,this.docktype[key]);
        if (indx>=0){
          this.docktype[key].createnew = val[indx].path===null?true:false
          this.docktype[key].disabler = false
        }
        else{
          console.log(`key`, key);
          this.docktype[key].createnew=false
          this.docktype[key].disabler = true
        }
        // this.docktype[key].createnew = (indx>=0 && val[indx].path===null)?true:false
        
   
   
   }
        }       
        
        val.forEach(el => {  
            el.created = moment(el.created).locale("Ru").format("HH:mm:ss DD MMMM YYYY")         
            this.docktype[el.doctype.name].data.push(el)
            
        });
        console.log(this.docktype);
    }
}
}
</script>

<style>
.bgtrans {
  background-color: transparent!important;
}



</style>