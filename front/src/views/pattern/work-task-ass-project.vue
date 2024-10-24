<template>
  <v-row class="ma-1">
    <div class="alerts">
      <v-alert
        type="success"
        dismissible
        v-if="!message.mes==''"
      >
        {{message.mes}} 
      </v-alert>
    </div>
    <v-col class="d-flex flex-col  gaps">
     
      <v-row class="gaps">
        <v-col
          class="flex-grow-0 d-flex flex-col colblock pa-0"
          xl="2"
          lg="2"
         
          cols="12"
        >          
              <Cards
                :ma="'ma-1 mt-2'"
                color="inyand"
                :elevation= "4"
              >
                <template #cards> 
        
                    <v-app-bar
                          class="flex-grow-0 d-flex d-flex flex-col ma-0 px-2 mx-2 mb-4"
                          dense
                          elevation="1"
                          color="inyand"
                        >
                        <v-toolbar-title
                        color="inyand"
                        >   {{cards=='project'?'Задачи':cards=='task'?'Работы':'Поручения'}}</v-toolbar-title>
                        
                        <v-spacer></v-spacer>

                        <MyIco
             
              icons ="mdi-plus"
              color='btns'
              :cursor= false
              :tooltip= true
              :text_tool='"Добавить"'
               @click="$emit(cards=='project'?'createnewTask':cards=='task'?'createnewWork':'createnewass')"
            />
                       
                        </v-app-bar>
                                     
             
                  
                  
                  <slot  name="spisok"/>
               </template>
              </Cards> 
        
        </v-col>
        


        <v-tabs-items
          class="tebs"
          v-model="tabProj"
        >
          <v-tab-item value=1>
            <transition
              name="bounce"
              @after-enter="$emit('afterEnter')"
              @after-leave="$emit('afterLeave')"
            >
            <v-row class="ma-0">
              <v-col 
                class="flex-col d-flex pa-0 informations colblock"
                :xl="chatview?8:12"
                :lg="chatview?8:12"
                md="12"
                sm="12"
                cols="12"
              >



              
               <v-row
                class="ma-0"
                :class="'mb-1'"
               >
                <v-col class="flex-col d-flex pa-0">
                    <Cards :ma="'ma-2'">
                      <template #cards>
                        <Cards
                            color="inyand"
                            :elevation= "0"
                            :ma="'ma-0'"
                        >
                          <template #cards>
                              <slot name="informations"/>
                                <v-divider/>
                       
                          </template>
                        </Cards>
                      </template>
                    </Cards>
                </v-col>
               </v-row>
               <v-row class="ma-0 flex-grow-0 row_informations ">
                <v-col
                  class="flex-col  d-flex pa-0 colfiles"
                  :xl="!chatview?8:12"
                  :lg="!chatview?8:12"
                  md="12"
                  sm="12"
                  cols="12"
                >
                    <Cards :ma="'ma-2'">
                      <template #cards>
                        <Cards
                          color="inyand"
                          :elevation= "0"
                        >
                          <template #cards>
                            <slot name="filess"></slot>
                          </template>
                        </Cards>
                      </template>
                    </Cards>
                </v-col>
                <v-col class="flex-col d-flex pa-0 ml-1" v-if="!chatview">
                  <Cards :ma="'ma-2'">
                    <template #cards>
                      <Cards
                        color="inyand"
                        :elevation= "0"
                        class="overflow-auto overflow-x-hidden h-0"
                      >
                        <template #cards>
                          <slot name="graphic"></slot>
                        </template>
                      </Cards>
                    </template>
                  </Cards>
                </v-col>
               </v-row>

                </v-col>
             
                <v-col
                  class="pa-0"
                  :class="chatview?'flex-col d-flex':''"
                  v-show="chatview"
                >
                  <v-row
                    class="ma-0 ml-1 flex-grow-0 row_chat colblock"
                    :style="{ height: height + 'vh' }"
                  >
                    <v-col class="flex-col d-flex pa-0">
                      <Cards
                        :ma="'ma-2'"
                        v-show="chatview"
                      >
                        <template #cards>
                          <Cards
                            color="inyand"
                            :elevation= "0"
                          >
                            <template #cards>
                              <slot name="chat"/>
                              <v-row class="flex-grow-0 mt-1 align-self-center">
                                <v-col class="flex-grow-0 pa-1 pt-0"
                                  v-for="(value, i) in btnchat"
                                  :key="i"
                                >
                                  <v-btn
                                    x-small
                                    color="secondary"
                                    outlined
                                    @click="startResize(value)"
                                  >
                                    <v-icon >
                                      {{value}}
                                    </v-icon>
                                  </v-btn>
                                </v-col>
                              </v-row>
                            </template>
                          </Cards>
                        </template>
                      </Cards>
                    </v-col>
                  </v-row>
                  <v-row class="ml-1 mt-1 mb-0 mr-0">
                    <v-col class="flex-col d-flex pa-0">
                      <Cards :ma="'ma-2'">
                        <template #cards>
                          <Cards
                            color="inyand"
                            :elevation= "0"
                            
                          >
                            <template #cards>
                              <slot name="graphic"></slot>
                            </template>
                          </Cards>
                        </template>
                      </Cards>
                    </v-col>
                  </v-row>

                </v-col>
             
                </v-row>
              </transition>
            </v-tab-item>
                
            <v-tab-item value=2>
              <transition
                name="bounce"
                @after-enter="$emit('afterEnter')"
                @after-leave="$emit('afterLeave')"
              >
                <slot name="projdocs"/>
              </transition>
            </v-tab-item>
            <v-tab-item value=3>
              <history
              
              />
    
            </v-tab-item>
          </v-tabs-items>

        
        </v-row>
      </v-col>
    </v-row>
</template>


<script>
import history from '@/components/history/history.vue'
export default {

    name:"work-task-ass-projec",
  components:{history},
    data() {
      return {
        height: 55.8,
        btnchat :['mdi-menu-up', 'mdi-menu-down'],
        
      }
    },

    props: {
      breadcrumbs:{
        type:Array,
        requiered:true,
      },
      chatview: {
          type: Boolean,
          default: false
      },   

      // show: {
      //     type: Boolean,
      //     default: true
      // },
      tabProj: {
        type: String,
        default: '1'
      },
       title: {
        type: String,
        default: ""
      },
      cards: {
        type: String,
        default: ""
      },
      message: {
        type: Object,
        default:()=>{return {mes:"", show: false}}
      }
    },

    computed: {

    },
    
    methods: {
      startResize(ico) {
        let ind = 15
        console.log(`this.height`,this.height );

        if (ico =="mdi-menu-up" && this.height > 19) {
           this.height -= ind
        }
          if (ico =="mdi-menu-down" && this.height < 71) {
            console.log(`mdi-menu-down`);
            this.height += ind
        }
      },



    },
}

</script>

<style>

.row_informations {
  min-height: 38vh;
}

.row_chat {
  transition: height 0.7s;
  max-height: 70vh;
  min-height: 20vh;
}


.alerts {
position: absolute;
margin-left: auto;
margin-right: auto;
bottom: 5%;
left: 0;
right: 0;
text-align: center;
z-index: 2;
max-width: 20%;
}

.pointer{
  cursor: pointer;
}
fieldset {
  height: 2.5rem;
}

.arbeiten .v-tab {
  justify-content: stretch;
  height: 30px!important;
  text-align: start!important;
  margin-top: 8px;

}

.h_dna {
  height: 250px;
}

.arbeiten .v-tabs-items {
  display: flex;
}

.arbeiten  .v-window__container {
    flex-grow: 1!important;
    flex-direction: column;
  }

  .arbeiten .v-window-item--active {
        flex-grow: 1!important;
    flex-direction: column;
    display: flex;
  }


.styck {
    position: sticky;
    top: 0;
    max-height: 350px;
    overflow: auto!important;
    background: lightpink;
    z-index: 1000;
}

.cook {
        position: absolute;
        z-index: 1;
        left: 60%;
        top: 1vh;
        width: 40%;
    
}

.tebs {
  width: 0;
}

.theme--dark.v-tabs-items {
    background-color: transparent;
}

.blok1 {
  min-width: 857px;
  min-height: 633px;
}

.blok2 {
  min-width: 857px;
}

.c {

  overflow: auto;
}

.poruz {
    margin-top: 5px !important;
    margin-bottom: 12px !important;
    min-width: 13vw;
    max-width: 13vw;
}





.bounce-enter-active {
  animation: bounce-in .5s reverse;
}
.bounce-leave-active {
  animation: bounce-in .5s 
}
@keyframes bounce-in {
  0% {
    opacity:1
  
  }
  100% {
    transform: translateX(100vw);
    opacity:0

  }

} 

.height_informationorders {
  height: 100px;
}

.gaps {
    gap: 0.3rem;
}


.k .v-slide-group__content {
  justify-content: space-between;
}

.textworksize {
  font-size: 14px;
}

.psevdobread {
      color: rgba(0, 0, 0, 0.38);
}

@media (max-width: 1264px) {


    .colblock {
        min-height: 700px;
    }

    .colfiles {
      min-height: 200px;
    }

}

</style>