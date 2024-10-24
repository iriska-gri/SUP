<template>

                      <v-row 
                            v-if="'id' in chat"
                            class="flex-grow-1 flex-nowrap"
                        >
                            <v-col class="flex-grow-0 py-0 align-self-center">
                                <v-avatar
                                    :class="lightdark(chat.level, $vuetify.theme.dark)"
                                    size="28"
                                >
                                    <span class="white--text text-caption">{{ getName(chatTitle(chat)) }}</span>
                                </v-avatar>
                            </v-col>
                            <v-col class="flex-col align-self-center">
                                <v-row class="flex-col flex-grow-0">
                                    <v-tooltip bottom v-if="chatTitle(chat).length>60">
                                        <template v-slot:activator="{ on, attrs }">
                                            <v-col
                                                class="flex-grow-0 py-0 text-caption text-ls"
                                                v-bind="attrs"
                                                v-on="on">
                                                {{ chatTitle(chat).length>60?chatTitle(chat).slice(0, 35)+"...":chatTitle(chat) }}
                                            </v-col>
                                        </template>
                                        <span>{{ chatTitle(chat) }}</span>
                                    </v-tooltip>
                                    <v-col v-else
                                        class="flex-grow-0 py-0 text-caption text-ls"
                                    >
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

                        </v-row>
                        <v-row
                            v-else
                            class="flex-grow-1 bord rounded"
                        >
                        </v-row>
</template>

<script>

import mmesadmin from '@/components/supogramm/mess_components/m-mes-admin.vue';
import { createNamespacedHelpers } from "vuex";
import { bus } from "@/main";
import func from '../func'
const auth = createNamespacedHelpers('auth')

export default {

    name:"ui-name-chat",
    mixins:[func],

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
        mmesadmin
    },

    data() {
      return {
        adminerror:false,
        person:{},
      
        chatusers:[],
        textmessage:null,
        dialog:false,
      
      }  
    },

    created(){
        
        bus.$on("chat_project_users_send",this.chat_project_users_recieved)
        bus.$on("chat_users_send",this.chat_project_users_recieved)
        // bus.$on('dialogfalse',()=>{this.dialog=false})
    },
    
    computed:{

        user_chatadmin(){
            if ("admin" in this.chat){
            return this.chat.admin.id==this.getUser().id
            }
            else{
                return false
            }
        }
    },

    methods: {

        ...auth.mapGetters(["getUser"]),
        adminerrors(val){
            this.adminerror=val
        },
        chat_project_users_recieved(data){
         console.log('data', data);
            try{
            this.chatusers = this.preparechatusers(data.payload)
            this.$refs[data.place].showdial()
            }
            catch(e){
               console.log(e);
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



        dialogger(){
          console.log('jjjj');
            bus.$emit("chatuserdialog",{place: this.chatplace ,chat:{id:this.chat.id,level:this.chat.level, parent:this.chat.parent, members:{users:this.chat.users, admin:this.chat.admin}}})
         
        },




    },

    watch: {
        chat(val){
            // console.log(val),
        }
    } 
}
</script>

<style>

</style>