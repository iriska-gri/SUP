<template>
      <Cards
        color="inyand"
        :elevation= 0
        class="ma-1 nameAssidnment unip height_informationorders overflow-auto"
        
    >
        <template #cards>
            <v-row class="flex-grow-0">
                <v-col>
                    <strong>Поручения</strong>
                </v-col>
            </v-row>
            <v-divider></v-divider>
            <v-row
                v-for="(elm,index) in getworks.work_assignment"
                :key="index"
                class="flex-grow-0"
            >
                <v-col
                    :class="index==0?'mt-2':''"
                >
                    <span class="align-self-center">{{elm.name}} - <strong>{{elm.status.name}}</strong> - Срок до: {{momentedDay(elm.dateend)}} ({{elm.responsible.sn}})</span>
                
                </v-col>
                <v-col
                    xl=1
                > 
                    <v-menu
                        :min-width="elm.comment.length>0?'900px':'600px'"
                        :close-on-content-click="false"      
                    >
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn
                                v-show="elm.status.id<5 && getworks.status.id<3"
                                class="ml-auto"
                                x-small
                                icon
                                fab
                                :color="elm.status.id!=3?'orange accent-3':'orange darken-2'"
                                v-bind="attrs"
                                v-on="on"
                            >
                            <v-icon>{{elm.status.id!=3?'mdi-progress-clock':'mdi-play-speed'}}</v-icon>
                            
                            </v-btn>
                    </template>
        <v-card>
            <v-card-title>
             {{elm.status.id!=3? 'Отложить':"Открыть"}} поручение
        </v-card-title>
        <v-card-text>
           <v-textarea
          class="mx-2"
          
          placeholder="Комментарий"
          ></v-textarea>

        </v-card-text>
        <v-card-actions>
           <v-btn
            text
            @click="elm.status.id!=3?$emit('confirmation', {elm: elm, res: 3, text: 'Отложено'}):$emit('confirmation', {elm: elm, res: 2, text: 'Открыто'})"
          >
           {{elm.status.id!=3? 'Отложить':"Открыть"}}
          </v-btn>
        </v-card-actions>
        </v-card>
       </v-menu>
        <!-- <v-menu
      :min-width="elm.comment.length>0?'900px':'600px'"
      :close-on-content-click="false"
      
      
    >
      <template v-slot:activator="{ on, attrs }">

        <v-btn v-show="[4,5].includes(elm.status.id) && getworks.status.id<3"
        class="ml-auto"
        x-small
        icon
        fab
          :color="elm.status.id==5?'green':'red'"
         
          v-bind="attrs"
          v-on="on"
        >
        <v-icon
        
        >{{elm.status.id==5?'mdi-progress-check':'mdi-progress-question'}}</v-icon>
          
        </v-btn>
      </template>

      
         <v-row>
        <v-col class="pr-0" v-if="elm.comment.length>0">
          <v-card

          >
          <div class="flex-grow-1" v-for="(e,indx) in elm.comment" :key="e[0]+'-'+indx"> <strong>{{e[0]}}</strong>:<br> {{e[1]}}
            <v-divider></v-divider>
            </div>
            
            </v-card>
          </v-col>
         <v-col class="pl-0">
          <v-card>
        <v-list>
          <v-list-item>
            <v-list-item-avatar>
             
            </v-list-item-avatar>

            <v-list-item-content>
              <v-list-item-title>{{elm.name}}</v-list-item-title>
              <v-list-item-subtitle>Срок до: {{momentedDay(elm.dateend)}}</v-list-item-subtitle>
            </v-list-item-content>

          
          </v-list-item>
        </v-list>

        <v-divider></v-divider>

        <v-list>
          <v-list-item>
           
            <v-list-item-title>Комментарий</v-list-item-title>
          </v-list-item>
          <v-textarea
          class="mx-2"
          v-model="comment"
          ></v-textarea>
         
           
        </v-list>

        <v-card-actions>
          <v-spacer></v-spacer>

          <v-btn
            text
            @click="confirmation(elm,2,'Отклонено')"
          >
            Отклонить
          </v-btn>
          <v-btn
            color="primary"
            text
             @click="confirmation(elm,5,'Принято')"
          >
            Принять
          </v-btn>
        </v-card-actions>
         </v-card>
        </v-col>
        </v-row> 
     
    </v-menu> -->
                </v-col>
            </v-row>
            
        </template>
      </Cards>


      <!-- <v-card v-if="indx==0" style="height:100%">
                              <v-card-title class="py-0"><h5>Поручения</h5></v-card-title>
                                
                                <v-divider></v-divider>
                            <v-card-text>
                               
                                    
                                <div class="d-flex" v-for="(elm,index) in getworks.work_assignment" :key="index">
                                        <span class="align-self-center">{{elm.name}} - <strong>{{elm.status.name}}</strong> - Срок до: {{momentedDay(elm.dateend)}} ({{elm.responsible.sn}})</span>
        
          <v-menu
      :min-width="elm.comment.length>0?'900px':'600px'"
      :close-on-content-click="false"      
      
    >
      <template v-slot:activator="{ on, attrs }">
         <v-btn v-show="elm.status.id<5 && getworks.status.id<3"
        class="ml-auto"
        x-small
        icon
        fab
          :color="elm.status.id!=3?'orange accent-3':'orange darken-2'"
         
          v-bind="attrs"
          v-on="on"
        >
        <v-icon>{{elm.status.id!=3?'mdi-progress-clock':'mdi-play-speed'}}</v-icon>
          
        </v-btn>
  </template>
        <v-card>
            <v-card-title>
             {{elm.status.id!=3? 'Отложить':"Открыть"}} поручение
        </v-card-title>
        <v-card-text>
           <v-textarea
          class="mx-2"
          v-model="comment"
          placeholder="Комментарий"
          ></v-textarea>

        </v-card-text>
        <v-card-actions>
           <v-btn
            text
            @click="elm.status.id!=3?confirmation(elm,3,'Отложено'):confirmation(elm,2,'Открыто')"
          >
           {{elm.status.id!=3? 'Отложить':"Открыть"}}
          </v-btn>
        </v-card-actions>
        </v-card>
       </v-menu>
        <v-menu
      :min-width="elm.comment.length>0?'900px':'600px'"
      :close-on-content-click="false"
      
      
    >
      <template v-slot:activator="{ on, attrs }">

        <v-btn v-show="[4,5].includes(elm.status.id) && getworks.status.id<3"
        class="ml-auto"
        x-small
        icon
        fab
          :color="elm.status.id==5?'green':'red'"
         
          v-bind="attrs"
          v-on="on"
        >
        <v-icon
        
        >{{elm.status.id==5?'mdi-progress-check':'mdi-progress-question'}}</v-icon>
          
        </v-btn>
      </template>

      
        <v-row>
        <v-col class="pr-0" v-if="elm.comment.length>0">
          <v-card

          >
          <div class="flex-grow-1" v-for="(e,indx) in elm.comment" :key="e[0]+'-'+indx"> <strong>{{e[0]}}</strong>:<br> {{e[1]}}
            <v-divider></v-divider>
            </div>
            
            </v-card>
          </v-col>
         <v-col class="pl-0">
          <v-card>
        <v-list>
          <v-list-item>
            <v-list-item-avatar>
             
            </v-list-item-avatar>

            <v-list-item-content>
              <v-list-item-title>{{elm.name}}</v-list-item-title>
              <v-list-item-subtitle>Срок до: {{momentedDay(elm.dateend)}}</v-list-item-subtitle>
            </v-list-item-content>

          
          </v-list-item>
        </v-list>

        <v-divider></v-divider>

        <v-list>
          <v-list-item>
           
            <v-list-item-title>Комментарий</v-list-item-title>
          </v-list-item>
          <v-textarea
          class="mx-2"
          v-model="comment"
          ></v-textarea>
         
           
        </v-list>

        <v-card-actions>
          <v-spacer></v-spacer>

          <v-btn
            text
            @click="confirmation(elm,2,'Отклонено')"
          >
            Отклонить
          </v-btn>
          <v-btn
            color="primary"
            text
             @click="confirmation(elm,5,'Принято')"
          >
            Принять
          </v-btn>
        </v-card-actions>
         </v-card>
        </v-col>
        </v-row>
     
    </v-menu>
                                </div>


                            </v-card-text>

                    </v-card>




                    </v-col>

            </v-row>
        </v-card> -->

</template>

<script>
import { createNamespacedHelpers } from "vuex";
import momentedDay from '@/utils/universal_functions'

const { mapGetters } = createNamespacedHelpers("auth");
const workstate = createNamespacedHelpers("workstate");


export default {

    name: 'assignment',

    mixins:[momentedDay],

    data: () => ({
        comment:""
    }),

    computed: {
    ...mapGetters(["getUser", ]),
    ...workstate.mapGetters(['getworks']),
    },  


    methods:{
        ...workstate.mapMutations(["setWorks"]),
    }

}
</script>

<style>
.unip {
  height: 50px;
}
</style>