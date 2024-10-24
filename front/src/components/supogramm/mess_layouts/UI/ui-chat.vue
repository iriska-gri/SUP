<template>
<v-row class="overflow-auto h-0 my-1 ui-chat"  v-scroll.self="onScroll">
    <v-col>
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
                                        class="ui-chat"
                                            :chatid="chat.id"
                                            :mess = messege
                                            @userclicked="userclicked"
                                        />
                                    </v-col>
                                </v-row>

                            </div>
    </v-col>
</v-row>
                          

</template>

<script>
import infousercard from '@/components/UI/infousercard.vue';
import moment from 'moment';
import mMessegeCloud from '@/components/supogramm/mess_components/m-messege-cloud.vue';
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
        mMessegeCloud,
        infousercard,
    },

    data() {
      return {
        adminerror:false,
        dialogdetail:false,
        chatusers:[],
        
        offsetTop: 0,
        textmessage:null,
        dialog:false,
        dialogtype:0,
        adminmenu:[{text:"Добавить пользователя",icon:"mdi-chat-plus-outline"},{text:"Передать права администратора",icon:"mdi-shield-crown"}],

      }  
    },
   
    methods: {
                userclicked(user){
                    this.$emit("userclicked", user)
            
         
        },

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

        getDate(date) {
            
            return moment(date).locale('ru').format('ll')
        },



    },


}
</script>

<style>

</style>