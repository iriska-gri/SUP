<template>
  <v-card class="d-flex flex-col flex-grow-1 pa-3" color="inyand">
    <v-row  class="d-flex flex-col inputcolor mx-0 mt-1 rounded chats flex-nowrap"


    >
    <v-col
      class="py-1 flex-grow-0"
      v-for="(it, i) in content"
      :key="it.id"
      :class="i==0?'mt-3':'pt-0'"
      >
      ({{momented(it.datetime)}})
        <strong class="open_icons--text"
            >
          {{it.sender.fullname}}
          </strong>:
        {{it.message}}
        <v-btn
          v-if="it.sender.id==getUser.id"
          @click="delmessage(it)"
          class="mx-2"
          fab
          x-small
          icon
          
        >
          <v-icon color="close_icons">
            mdi-email-minus-outline
          </v-icon>
        </v-btn>

</v-col>
    </v-row>

    <v-row class="flex-grow-0 ">
      <v-col class="px-0 pl-3 pb-3">
  <v-text-field
 
    background-color="inputcolor"
    solo
    dense
    v-model="message"
    hide-details
    ></v-text-field>
      </v-col>
 

    <v-col class="flex-grow-0 pb-3 pl-3 align-self-center
">
      <BtnsOut
        @click="sendchat"
        :disabled="message?false:true"
        title = "Отправить"
       
      />
    </v-col>
  </v-row>
  </v-card>
</template>

<script>

import moment from "moment";
import {axiosInstance} from '@/utils/api'
import { createNamespacedHelpers } from "vuex";

const { mapGetters } = createNamespacedHelpers("auth");
export default {

    props: {
      wbs:{
        type: Object,
        default: ()=>{}
      },    
      mes:{
        type: Object,
        default: ()=>{}
      },  
      delmes:{
        type: Number,
        default: null
      },             
      },
    data(){
      return{
      content:[],
      message:null
       }
     },
    computed:{      
     ...mapGetters(["getUser", ]),
    },
    watch:{
      mes(val){
        this.content.push(val);
      },
      delmes(val){       
        let splicer = this.content.findIndex(e=>e.id==val)
        this.content.splice(splicer,1)
      }
    },
    methods: {
     
      async sendchat(){
        await this.wbs.send({action:"sendchat",payload:this.message})     
        this.message=null
        },
        momented(val){
      return moment(val).format("HH:mm:SS DD.MM.YYYY")
    },
    async delmessage(it){
      
      await this.wbs.send({action:"delmessage",payload:{id:it.id,parent:it.parent.id}}) 
    }

    
    },

    async mounted(){
     
        moment.locales('ru')          
        let params = {type:this.$route.name,id:this.$route.params.id}
        
        // let res = await axiosInstance.post('/getchat', params)
        // this.content = res.data
       
         
        
    },
    
    
}
</script>

<style lang="scss">
@import "@/utils/colors.scss";

.chats {
  overflow-y: auto;
  height: 100px;
}
</style>