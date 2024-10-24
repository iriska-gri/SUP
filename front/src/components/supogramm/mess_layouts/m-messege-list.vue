<template>

<v-row>
    <v-col class="flex-col m-messege-list">
        <v-row
            class="flex-grow-0"
        >
            <v-col class="flex-col pa-0 mml-border rounded">
                <Cards
                    height='40'
                    :elevation=0
         
                    color="inyand"
                >
                    <template #cards>
                        <v-row 
                            v-if="'id' in chat"
                            class="flex-grow-1 "
                        >
                            <v-col class="flex-grow-0 py-0 align-self-center">
                                <v-avatar
                                    :class="!$vuetify.theme.dark?'auchlight':'auchdark'"
                                    size="28"
                                >
                                    <span class="white--text text-caption">{{ getName(chatTitle(chat)) }}</span>
                                </v-avatar>
                            </v-col>
                            <v-col class="flex-col pa-0">
                                <v-row class="flex-col flex-grow-0 mt-3">
                                    <v-col class="flex-grow-0 py-0 text-caption text-ls">
                                        {{ chatTitle(chat) }}
                                    </v-col>
                                    <v-col class="py-0">
                                        <span class="text-caption text-ls">
                                            {{ Array.isArray(chat.users)? 'Кол-во участников: ' + chat.users.length: 'Последнее'}}
                                        </span> 
                                    </v-col>
                                </v-row>
                            </v-col>
                            <v-col class="flex-grow-0 py-0 align-self-center">
                                <MyIco
                                    @click="dialogger()"
                                    icons = 'mdi-menu'
                                />
                            </v-col>
                        </v-row>
                        <v-row
                            v-else
                            class="flex-grow-1 bord  rounded"
                        >
                        </v-row>
                    </template>
                </Cards>
            </v-col>
        </v-row>

        <v-row>
            <v-col class="mt-2 pa-0 mml-border rounded flex-col">
                <Cards
                    height='20'
                    :elevation=0
                    color="inyand"
                    class="overflow-auto"
                     v-scroll.self="onScroll"

                >
                    <template #cards>
                        <v-progress-linear
                            class="mb-2 px-4"
                            v-show="waiter"                            
                            indeterminate
                            color="teal"
                        ></v-progress-linear>
                            <div v-for="(messege, i) in chat.lastmessage" :key="`${chatplace}-${i}`" class="pa-0" >
                                <div v-if="i==0 || messege.messagetime.split(' ')[0]!=chat.lastmessage[i-1].messagetime.split(' ')[0]">
                                    <v-row class="flex-grow-0 justify-center mt-0">
                                        <v-col
                                            class="text-center"
                                            :class="i==0?'pt-0':''"
                                        >
                                            <Cards
                                                color="inyand"
                                                :elevation= 0
                                                height='40'
                                                :ma="'ma-2'"
                                                class="body-2"
                                                >
                                                <template #cards>
                                                    <v-divider class="mb-2"></v-divider>
                                                <span class="text-color-scrollbar">
                    {{ getDate(messege.messagetime) }}
                                                </span>
                                               <v-divider class="mt-2"></v-divider>
                                                </template>
                                            </Cards>
                                        </v-col>
                                    </v-row>
                                </div>
                                <v-row
                                    class="flex-grow-0"
                                    :ref="`${messege.id}`"
                                >
                                    <v-col>                                    
                                        <mMessegeCloud
                                        class="m-messege-list"
                                            :chatid="chat.id"
                                            :mess = messege
                                            @userclicked="userclicked"
                                        />
                                    </v-col>
                                </v-row>

                            </div>
                        </template>
                    </Cards>
                </v-col>
            </v-row>
        <v-row class="send flex-grow-0" v-show="sender" >
            <v-col class="flex-col pa-0 pt-2">

                <sendMessege                 
                
                    :chat="chat"
                />
                                    </v-col>
                                </v-row>
        <!-- <v-row>
            <v-col class="flex-col py-2">
                <Cards
                    :ma="'ma-2'"    
                    color="inyand"
                >
                    <template #cards>
                             <Cards
                             color="inputcolor"
                            class="overflow-auto"
                            :elevation= 0
                             v-scroll.self="onScroll"
                             >
                    <template #cards>
                         <v-progress-linear
                         class="mb-2 px-4"
                         v-show="waiter"                            
                        indeterminate
                            color="teal"
                            ></v-progress-linear>
                        <div v-for="(messege, i) in chat.lastmessage" :key="`${chatplace}-${i}`" class="pa-0" >
                          
                             <div v-if="i==0 || messege.messagetime.split(' ')[0]!=chat.lastmessage[i-1].messagetime.split(' ')[0]">
                                
                                <v-row class="flex-grow-0 justify-center mt-0">
                                    <v-col class="text-center" xl=2
                                    :class="i==0?'pt-0':''"
                                    >
                                        <Cards
                                            color="inyand"
                                            :elevation= 0
                                            :height= 40
                                            :ma="'ma-2'"
                                            class="body-2"
                                            >
                                            <template #cards>
                                                {{ getDate(messege.messagetime) }}
                                            </template>
                                        </Cards>
                                    </v-col>
                                </v-row>
                                </div>
                                <v-row class="flex-grow-0"   :ref="`${messege.id}`">
                                    <v-col
                                    
                                    >                                    
                                
                                    <mMessegeCloud
                                        :chatid="chat.id"
                                        :mess = messege
                                        @userclicked="userclicked"
                                    />
                                    </v-col>
                                </v-row>
                             
                        </div>

                        
                                  
                    </template></Cards>
                    </template>
                </Cards>
            </v-col>
        </v-row> -->
        
        <!-- <v-row class="send flex-grow-0" v-show="sender" >
            <v-col class="flex-col py-0">

                <Cards
                :height= 50
                
                >
                    <template #cards>
                                       <v-row>
                                        <v-col
                                            class="d-flex align-self-center pa-1 px-2"
                                                                                       
                                        >
                                                        <v-textarea
                                @keypress.enter.prevent="sendmessage"
                                v-model="textmessage"
                                label="Текст сообщения"
                                solo
                                background-color="inputcolor"
                            no-resize
                            rows="1"
                            hide-details
                            >
                            </v-textarea>
                                        
                                            <v-btn
                                            class="align-self-center"
                                            :disabled="!('id' in chat)"
                                        @click="sendmessage"
                                            icon
                                            >
                                            <v-icon class="rotate315">mdi-send </v-icon>
                                            
                                            
                                            </v-btn>
                               
                                        </v-col>
                                       </v-row>
                    </template>
                </Cards>
                    </v-col>
        </v-row> -->
    </v-col>
    <mmesadmin 
        :user_chatadmin="user_chatadmin"
        :ref="chatplace"
        :chat="{id:chat.id, name:chat.name,parent:chat.parent}"
        :chatusers="chatusers"
        :adminerror="adminerror"
        :currentuser="getUser().id"
        @chatman_change="chatman_change"
        @chatman_add="chatman_add"
        @changechatname="changechatname"
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
import mMessegeCloud from '@/components/supogramm/mess_components/m-messege-cloud.vue';
import mmesadmin from '@/components/supogramm/mess_components/m-mes-admin.vue';
import { createNamespacedHelpers } from "vuex";
import { bus } from "@/main";
import sendMessege from '@/components/supogramm/mess_components/send-messege.vue';

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
        mMessegeCloud,
        mmesadmin,
        infousercard,
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
        bus.$on("chat_users_send",this.chat_project_users_recieved)
        // bus.$on('dialogfalse',()=>{this.dialog=false})
    },
    methods: {

        ...auth.mapGetters(["getUser"]),
        adminerrors(val){
            this.adminerror=val
        },
        chat_project_users_recieved(data){
         
            try{
            this.chatusers = this.preparechatusers(data.payload)
            this.$refs[data.place].showdial()
            }
            catch(e){
               
            }
        

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


        confirmchanges(){
              
                let users = []
                let chat = {id:this.chat.id}
                this.chatusers.forEach(el=>{if(el.chatman)users.push(el.id)
                                            if(el.admin)  chat.admin=el.id  })
                chat.users=users
                if (this.chat.name!=null){
                    chat.name=this.chat.name
                }
                else if(chat.users.length<2){
                    return
                }
                

                bus.$emit('changechatperson', chat)
                
        },
        showdial(){
            this.dialog=true
        },
        changechatname(val){
            this.chat.name=val
        },
        chatman_add(item){
            let indx = this.chatusers.findIndex(el=>el.id==item.id)
            if (indx==-1){
                    this.chatusers.push(item)
            }
            else{
                // console.log(item);
               this.chatusers[indx].chatman=item.chatman
            }
            if(this.chatusers.length>2&&this.chat.name ==null){
                this.chat.name = this.chatusers.map((e)=> {return e.sn}).join("-")
            }

            
        },
        // chatman_remove(item){
        //     console.log(",df,d,d,,d,d,d,d,d,d,d,");
        //     let ind = this.chatusers.findIndex(el=>el.id==item.id)
        //     console.log(this.chatusers[ind]);
        //     this.chatusers.slice(ind,1)
        // },
        chatman_change(item){
            
         item.chatman=!item.chatman
            if (item.admin && item.chatman){
                    item.chatman=true      
            }
            else if(!item.chatman && item.admin){
                this.adminerror=true
                item.chatman=true
            }
            let ob=[]
            this.chatusers.forEach(el=> ob.push(el))
            // let ob = Object.assign({},this.chatusers)
            this.chatusers = ob
           
        },
        admin_change(item){
            if (item.admin!=item.id){
                this.chatusers.forEach(el=>el.admin=false)
                item.admin=true
                item.chatman=true

            }
         
        },



        preparechatusers(data){
      
            
            let usersids=[]
            let arr = []
            try{
            data.forEach(val=>{
               
                    if(!usersids.includes(val.id) ){
                        val.chatman=this.chat.users.findIndex(e=>e.id==val.id)>=0
                        val.admin= this.chat.admin.id==val.id
                    
                    arr.push(val)
                    usersids.push(val.id)
                    }              
            })
                }


            
            catch{}

            return arr
        },


        dialogfalse(){

        },

        dialogger(){
          
            bus.$emit("chatuserdialog",{place: this.chatplace ,chat:{id:this.chat.id,level:this.chat.level, parent:this.chat.parent, members:{users:this.chat.users, admin:this.chat.admin}}})
         
        },
        
        onScroll (e) {           
            if (e.target.scrollTop==0){              
               
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
        sendmessage(){            
            bus.$emit("sendmessage",{message:this.textmessage, id:this.chat.id})
            this.textmessage=null
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

    watch: {
        chat(val){
            // console.log(val),
        }
    } 
}
</script>

<style scoped>

    .messegeListwraper {
        /* border: 1px solid red; */
        box-sizing: border-box;
        height: 100%;
        display: grid;
        gap: .5%;

        grid-template-areas: 
        "A A A"
        "B B B"
        "C C D";

        grid-template-rows: 7% auto 6%;
        grid-template-columns: 85% 1fr;
    }

    .mListBody {
        border: 1px solid grey;
        background-color: #F5F5F5;
        overflow: scroll;
        grid-area: B;
    }

    .mListHeader {
        border: 1px solid grey;
        grid-area: A;
        padding-top: .2em;
    }

    .mListFooter {
        /* border: 1px solid; */
        grid-area: C;
        margin-top: .3em;
    }

    .mSend {
        /* border: 1px solid; */
        grid-area: D;
        margin-top: .4em;
    }

    .date {
        width: 20%;
        text-align: center;
    }

    .datamessage {
        text-align: center;
    }

    .send {
        max-height: 75px;
    }

    .rotate315{
        transform: rotate(-45deg);

    }

    .text-ls {
        line-height: 0.25rem!important;
    }

    .mml-border {
        border: solid 1px var(--v-granica-base);
    }
    
</style>