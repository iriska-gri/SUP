<template>
    <v-row>
        <v-col class="flex-col">
            <v-row class="mb-1">
                <v-col class="flex-col pa-0">
                    <Cards
                        :ma="'ma-0'"
                        class="flex-col"
                        color="inyand"
                        :elevation= 0 
                    >
                        <template #cards>
                            <div class="overflow-auto overflow-x-hidden mml-border pa-5 rounded flex-col flex-grow-1 mmlr-heigth " v-scroll.self="onScroll">
                                <v-progress-linear
                                    class="mb-2 px-4 progressheight"
                                    v-show="waiter"    
                                    indeterminate
                                    color="teal"
                                />
                                   <div v-for="(messege, i) in chat.lastmessage" :key="`${chatplace}-${i}`" class="pa-0" >
                          
                             <div v-if="i==0 || messege.messagetime.split(' ')[0]!=chat.lastmessage[i-1].messagetime.split(' ')[0]">
                                
                                <v-row class="flex-grow-0 justify-center mt-0">
                                    <v-col class="text-center px-1"
                                    :class="i==0?'pa-0':'py-0'"
                                    >
                                        
                                                    <v-alert
                                                            dense
                                                            text
                                                            color="btns"
                                                            class="py-0"
                                                            >
                                                         <span class="card-text">   {{ getDate(messege.messagetime) }} </span>
                                                            </v-alert>
                  
                                    </v-col>

                                </v-row>
                                </div>
                                
                                <v-row
                                    class="flex-grow-0 mMessegeCloud"
                                    :ref="`${messege.id}`"
                                >
                                
                                    <v-col class="px-1"> 
                                                                           
                                        <mMessegeCloud
                                            :chatid="chat.id" 
                                            :mess = messege
                                            @userclicked="userclicked"
                                        />
                                    </v-col>
                                </v-row>
                             
                        </div>

 </div>
                                  
                    </template></Cards>
                <v-divider class="margDriv"></v-divider>
            </v-col>
        
        </v-row>
        
                
                <v-row class="flex-grow-0 mt-0" v-show="sender" >
           
            <v-col class="rounded-b-lg">
                
                 <sendMessege                 
                    :chat="chat"
                />
                
            </v-col>
        </v-row>

    </v-col>
    
    <mmesadmin 
    :user_chatadmin="user_chatadmin"
    :ref="chatplace"
    :chatusers="chatusers"
    :adminerror="adminerror"
    :currentuser="getUser().id"
    @chatman_change="chatman_change"
    @admin_change="admin_change"
    @adminerror="adminerrors"
    @confirmch="confirmchanges"
    />
    <infousercard :dialogdetail="dialogdetail"

        :person="person"
        @dialogdetailoff="dialogdetail=false"
    />




</v-row>


</template>

<script>
import { axiosInstance } from '@/utils/api'
import infousercard from '@/components/UI/infousercard.vue';
import moment from 'moment';
import mMessegeCloud from '../mess_components/m-messege-cloud.vue';
import mmesadmin from '../mess_components/m-mes-admin.vue';
import sendMessege from '../mess_components/send-messege.vue';
import { createNamespacedHelpers } from "vuex";
import { bus } from "@/main";
const auth = createNamespacedHelpers('auth')

export default {

    props: {
       
        chatplace:{
            type:String,
            default:"mainchat"
        },
        header:{
            type:Boolean,
            default:true
        },
      
        waiter:{
            type:Boolean,
            default:false
        },
        chat: {
            type: Object,
            default: ()=> {return {users:[{id:''}],admin:{id:0}}}
        }
    },

    components: {
        infousercard,
        mMessegeCloud,
        mmesadmin,
        sendMessege
    },

    data() {
      return {
        adminerror:false,
        person:{},
        dialogdetail:false,
        chatusers:[],
        
        offsetTop: 0,
        textmessage:null,
        dialog:false,
        dialogtype:0,
        adminmenu:[{text:"Добавить пользователя",icon:"mdi-chat-plus-outline"},{text:"Передать права администратора",icon:"mdi-shield-crown"}],

      }  
    },
    computed:{
        sender(){
            let res =false
            try{
              res= this.chat.users.findIndex(el=>el.id==this.getUser().id)>=0
            }catch{}
            return res
        },
        user_chatadmin(){
            if ("admin" in this.chat){
            return this.chat.admin.id==this.getUser().id
            }
            else{
                return false
            }
        }
    },
    created(){
        
        bus.$on("chat_project_users_send",this.chat_project_users_recieved)
        // bus.$on('dialogfalse',()=>{this.dialog=false})
    },
    methods: {

        ...auth.mapGetters(["getUser"]),
        adminerrors(val){
            this.adminerror=val
        },
        userclicked(user){
            
            axiosInstance.get( `/user/${user}`)     
          .then(res => {    
                  
            this.person=res.data  
            this.dialogdetail=true   
           
            
           
          })
          .catch(err => {
            console.log(err)
          })
         
        },

        chat_project_users_recieved(data){
            try{
            this.chatusers = this.preparechatusers(data.payload)
            this.$refs[data.place].showdial()
            }
            catch{}


        },
        confirmchanges(){
                
                let users = []
                let chat = {id:this.chat.id}
                this.chatusers.forEach(el=>{if(el.chatman)users.push(el.id)
                                            if(el.admin)  chat.admin=el.id  })
                chat.users=users
                
                bus.$emit('changechatperson', chat)
                
        },
        showdial(){
             this.dialogdetail=true
            this.dialog=true
           
        },
        chatman_change(item){
            
         item.chatman=!item.chatman
            if (item.admin && item.chatman){
                    item.chatman=true      
            }
            else if(!item.chatman && item.admin){
                this.adminerror=true
                item.chatman=true
            }
           
        },
        admin_change(item){
            if (item.admin!=item.id){
                this.chatusers.forEach(el=>el.admin=false)
                item.admin=true
                item.chatman=true

            }
            // console.log(this.chat.admin)
        },
        



        preparechatusers(data){
           
            
            let usersids=[]
            let arr = []
            try{
            for (let[key,val] of Object.entries(data)){
                if (key!="Участники"){
                    if(!usersids.includes(val.id) ){
                        val.chatman=this.chat.users.findIndex(e=>e.id==val.id)>=0
                        val.admin= this.chat.admin.id==val.id
                    
                    arr.push(val)
                    usersids.push(val.id)
                    }
                  

                }else{            
                
                  val.forEach(e=>{
                        if (!usersids.includes(e.id) ){
                        e.projectrole=key
                         e.chatman=this.chat.users.findIndex(el=>el.id==e.id)>=0
                        e.admin= this.chat.admin.id==e.id
                        usersids.push(e.id)
                        arr.push(e) }}
                  
                        ) 
                
                }


            }}
            catch{}



            return arr

        },
        dialogfalse(){

        },

        
        onScroll (e) {    
                       
            if (e.target.scrollTop==0 && this.chat.lastmessage.length>=10){ 

                this.$emit("waiting")            
              
                bus.$emit("previous",this.chat.id) 
            }
   
      },
        scrollbottom(id){
            
          id = String(id)
            
          setTimeout( this.scroller,200, id)
     
            
        },
        scroller(id){
      
            let el = this.$refs[`${id}`]
        
            try{
        el[0].scrollIntoView({behavior: 'smooth'});
            }catch{

            }
            
        },
      
        getDate(date) {
            
            return moment(date).locale('ru').format('ll')
        },

         getName(chat) {
            let splitted = chat.split(' ')
            let i=0
            let shn=''
            while (i<2 && i<splitted.length) {
                    shn += splitted[i][0].toUpperCase()
                    i++
            }

            return shn
        },

    textmess(val){
      this.textmessage=val
    },

        chatTitle(chat) {
            if(chat.name != null){

                return chat.name
            } else {
                let nam = ''
                chat.users.forEach(el => {
                    if(el.id != this.getUser().id){
                        let snn = el.givenName.split(' ')

                        nam = el.sn + ' ' + snn[0][0] + '.'
                    }
                })
                return nam
            }
        }
    },

}
</script>

<style >

    .sender {
        background-color: #e1e1e1;
    }

    .send {
        max-height: 75px;
    }


    .mmlr-heigth {
        height: 0px;
    }

    .text-color-scrollbar {
        color: var(--v-btns-base)
    }

    .screen {
        border: solid 1px var(--v-granica-base);
    }

    .progressheight {
        min-height: 3px;
    }

    .margDriv {
        margin-bottom: -3px;
    }
    .margDrivTop {
        margin-top: 2px;
    }
    
</style>