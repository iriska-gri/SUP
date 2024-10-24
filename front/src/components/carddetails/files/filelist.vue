<template>
  <div class="flex-col d-flex flex-grow-1">
    <v-row class="flex-grow-0 align-center">
      <v-col
        v-if="`${statid}`.includes(status)"
        id="fileinput"
        class="py-0"
        xl="6"
        lg="6"
        md="6"
      >
        <v-file-input
          dense
          flat
          v-model="filesinput"
          class="text-caption font-weight-normal inputext"
          hide-details
          :show-size="1000"
          multiple
          placeholder="Выберите файлы"
          prepend-icon="mdi-paperclip"
          clear-icon='mdi-close'
        >      
          <template #append-outer>
            <MyIco
              @click="uploadfile"
              :disabled="filesinput===null?true:filesinput.length==0?true:false"
              icons = 'mdi-chevron-double-up'
            />
          </template>
        </v-file-input>
      </v-col>
      <v-divider
        v-if="`${statid}`.includes(status)"
        vertical
      />
      <v-col class="flex-grow-0 py-2">
        <v-icon  color="btns" dense>
          mdi-file-multiple
        </v-icon>
      </v-col>
      <v-col class="py-1 text-subtitle-2 font-weight-regular">
        Всего файлов загружено: {{  files.filter(e=>e.visible[level-1]=='1' && e[levelkey[level]].id==currentid).length}}
      </v-col>

    </v-row>
    <v-row class="flex-grow-0 sticky px-2">
      <v-col class="flex-col d-flex pa-0">
        <v-divider/>
      </v-col>
    </v-row>
    <v-row class="overflow-auto h-0">
      <v-col class="pa-0">
        <v-list dense class="py-0">
          <div
            class="inyand"
            v-for="(file, index) in files"
            :key="index"
            >
              <v-list-item
                class="pa-0"  
                v-if="(file.visible[level-1]=='1' || file.sender.id == getUser.id) && filepainter(file)"
              >
                <v-col class="pb-0 pt-2">
                  <v-list-item-content class="py-0">
                    <v-list-item-title
                      @click.prevent="downloadItem(file)"
                      class="pointer"
                    >
                      {{filename(file.filepath)}}
                    </v-list-item-title>
                    <v-list-item-subtitle>
                      {{momentedtime(file.datetime)}}
                    </v-list-item-subtitle>
                  </v-list-item-content>
                </v-col>
                  <v-list-item-action-text class="mx-5 ml-8">
                    Скачано: {{file.counter}}
                  </v-list-item-action-text>
                  <v-list-item-action-text class="ml-0 mr-1">
                    <!-- Загрузил(а): {{file.sender}}   -->
                    Загрузил(а): {{reName(file.sender)}}
                  </v-list-item-action-text>  
                  <v-list-item-action class="my-0 mr-1">
                    <v-menu
                      ref="filemenu"
                      :close-on-content-click="false"
                      absolute
                      offset-y
                      max-width=300
                      v-if="(file.visible[level-1]=='1' || file.sender.id == getUser.id) && filepainter(file)"
                    >
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn 
                        v-bind="attrs"
                        v-on="on"
                        icon>
                        <v-icon small  color="greym lighten-1">mdi-menu</v-icon>
                      </v-btn>
                  </template>
                    <v-card
                      color="inyand"
                      class="flex-col d-flex flex-grow-1"
                      elevation-1
                    >
                     <div class="d-flex flex-col flex-grow-1">
                        <v-row>
                          <v-col v-if="getUser.id==file.sender.id" >
                            <v-list
                              class="pa-0"
                              color="inyand"
                            >
                            <v-list-item class="pl-0 pr-1">
                            <v-list-item-avatar class="mr-1">
                              <v-icon color="btns">mdi-file</v-icon>
                            </v-list-item-avatar>
                            <v-list-item-content class="pb-0">
                              <v-list-item-title class="caption font-weight-bold">
                                {{filename(file.filepath)}}
                              </v-list-item-title>
                              <v-list-item-subtitle class="caption">
                                 {{reName(file.sender)}}
                              </v-list-item-subtitle>
                              <v-list-item-subtitle class="caption">
                                {{momentedtime(file.datetime)}}
                              </v-list-item-subtitle>
                            </v-list-item-content>
                            <v-list-item-action class="align-self-end mb-0">
                                <v-icon
                                  color="btns"
                                  small
                                  @click="deleter(file)"
                                >
                                  mdi-delete
                                </v-icon> 
                            </v-list-item-action>
                          </v-list-item>
                        
                                                    <!-- <v-col class="align-self-center text-end py-0 mr-2">
                            <v-icon  color="btns"
                      @click="$emit('deleter',file)"
                      >mdi-delete </v-icon> 
                          </v-col>-->
                          </v-list>
                      </v-col> 

                         
                        </v-row>
                     
                        <v-row class="ma-1 pa-1 main_theme">
                          <v-col
                            v-for="(vis,ind) in file.visible"
                            :key="ind"
                            xl="6"
                            lg=6
                            md=6
                            sm=6
                            cols=6
                            class="caption pa-0"
                          >
    <v-row class="pa-2  align-items-center inyand">
      <v-col class="flex-grow-0 pa-2 ">
        
        <v-container
          id="cheks"
          class="pa-0"
          fluid
          hide-details
        >
        
          <v-checkbox
            :disabled="(file[textlevels[ind].field]===null)"
            v-model="file.visible[ind]"
            color="btns"
            hide-details
            dense
            class="mt-0  pt-0"
            :true-value='"1"'
            :false-value="'0'"
            @click="$emit('VisSwitcher',file)"
          />
        </v-container>
      </v-col>
      <v-col class="pa-0">
      
      <span :class="(file[textlevels[ind].field]===null)?'disableds--text':''">
        {{textlevels[ind].text}}
      </span>  
      </v-col>
    </v-row>
                       
            
                  
         

                        </v-col>
                
                        </v-row>
                  
                      </div>
                      </v-card>

                       
                  </v-menu>
  
  
  
          </v-list-item-action>
       
        </v-list-item>
        </div>
      </v-list>
            </v-col>
          </v-row>
          <v-row class="flex-grow-0 pb-2 px-2">
            <v-col class="pa-0">
              <v-divider></v-divider>
            </v-col>
          </v-row>
              <!-- <v-row class="flex-grow-0 sticky px-2">
      <v-col class="flex-col pt-3">
        <v-divider/>
      </v-col>
      </v-row> -->
</div>

</template>
<script>
import {axiosInstance, } from '@/utils/api'
import { createNamespacedHelpers } from "vuex";
const { mapGetters } = createNamespacedHelpers("auth");
import uf from '@/utils/universal_functions'
export default {
    name:'filelist',
    mixins:[uf],
    props:{
      files:{
        type:Array,
        default:()=>[]
      },
      level:{
        type:Number,
        default:1
      },
      status:{
        type:Number,
        default:0
      },
      currentid:{
        type:Number,
        default:0
      },

      statid: {
        type:Array,
        default:()=> [1, 2, 3]
      }
    },

    computed: {
    ...mapGetters(["getUser", ]),
     },

    data(){
      return{
        levelkey:['','project','task','work','assignment'],
        filesinput:null,
        textlevels:[{field:'project',text:"В проекте"},{field:'task',text:"В задаче"},{field:'work',text:"В работе"},{field:'assignment',text: "В поручении"}],
      }

    },

    methods:{


    deleter(file){
      
      this.$refs.filemenu.forEach(el=>el.save())
      
      this.$emit('deletefile',file)
    },

    async downloadItem(file){
      let res= await axiosInstance.get("/main/getfile/?id="+file.id)

        const blob = new Blob([res.data])

        const link = document.createElement('a')

       
        var url = window.URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = this.filename(file.filepath)
        a.click()
        a.remove()


    } ,   

    uploadfile(){
           
            let formData = new FormData();   
            this.filesinput.forEach(el => {formData.append('file',el)
                
            });
           this.filesinput=null
         

            this.$emit('uploadfile',formData)

    },
    filepainter(file){   
      console.log(this.currentid,this.level, this.files); 
      return file[this.levelkey[this.level]]!=null && (file[this.levelkey[this.level]].id==this.currentid)
     
    }



     },
    
}
</script>
<style lang="scss">

#fileinput .theme--light.v-icon, #fileinput .theme--dark.v-icon {
    color: var(--v-btns-base);
}



.v-input--selection-controls__ripple {
  color:var(--v-btns-base)
}

.v-input--selection-controls.v-input--dense:not(.v-input--switch) .v-input--selection-controls__ripple {
    top: calc(50% - 14px)!important;
}

.v-input--selection-controls.v-input--dense .v-input--selection-controls__ripple {
    width: 13px!important;
    height: 13px!important;
    left: -1px!important;
}

.v-input--selection-controls__ripple {
    border-radius: 7%!important;
}
    
</style>