<template>
    <v-row class="messenger-main mm-height">
        <v-col class="flex-col sm_border">
            <v-row class="flex-grow-0 align-self-end">
                <MyIco
                    icons = 'mdi-close-thick'
                    size='x-small'
                    color="red"
                    @click="$emit('closesupogramm')"
                />
            </v-row>
            <v-row >
                <v-col
                    class="flex-col pl-1"
                    xl="3"
                    lg="3"
                    md="12"
                    cols="12"
                >
                    <v-row class="flex-grow-0 ">
                        <v-col class="flex-col pt-0 pb-1 pr-0">
                            <Cards 
                                :elevation= 0
                                color="inyand"
                                
                            >
                                <template #cards>
                                    <v-row class="sm_border rounded">
                                        <v-col class="py-0 pr-0">
                                            <ui-chat-search
                                                @searchdfunc="searchdfunc"
                                                :mychats="mychats.filter(e=>e.users.findIndex(elm=>elm.id==getUser.id)>=0)"
                                            />
                                        </v-col>
                                        <v-col class="flex-grow-0">
                                            <ui-btn-new-chat
                                                @createchat="createchat"
                                            />
                                        </v-col>
                                    </v-row>
                                </template>
                            </Cards>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col class="flex-col pt-0 pr-0">
                            <div class="sm_border flex-grow-1 flex-col rounded">
                                <Cards
                                    :elevation= 0
                                    color="inyand"
                                    class="overflow-auto h-0"
                                    :ma="'ma-1'"
                                >
                                    <template #cards>
                                        <ui-spisok-chat
                                            :mychats="searchd"
                                            :unreadNumer="unreadNumer"
                                            @activeChat="activeChat"
                                        />
                                    </template>
                                </Cards>
                            </div>
                        </v-col>
                    </v-row>
                </v-col>
                <v-col
                    class="flex-col pl-1 pt-2"
                    xl="9"
                    lg="9"
                    md="12"
                    cols="12"
                >       
                    <v-row class="flex-grow-0">
                        <v-col class="py-1 flex-col">
                            <div class="sm_border flex-grow-1 flex-col rounded">
                                <Cards
                                    :elevation= 0
                                    color="inyand"
                                    :min_height=48
                                >
                                    <template #cards>
                                        <ui-name-chat
                                            ref="mychat"
                                            :chat="activedCh"
                                            @chatuserdialog="chatuserdialog"
                                        />
                                    </template>
                                </Cards>
                            </div>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col class="pt-0 flex-col">
                            <div class="sm_border flex-grow-1 flex-col rounded">
                                <Cards
                                    :elevation= 0
                                    color="inyand"
                                    :ma="'my-0 mx-3'"
                                >
                                    <template #cards>
                                        <ui-chat
                                            ref="mychat"
                                            :waiter="waiter"
                                            :chat="activedCh"
                                            :unreadNumer="unreadNumer"
                                            @activeChat="activeChat"
                                            @createchat="createchat"
                                            @userclicked="userclicked"
                                        />
                                    </template>
                                </Cards>
                            </div>
                        </v-col>
                    </v-row>
                    <v-row
                        class="flex-grow-0 mt-1"
                        v-show="sender"
                    >
                        <v-col class="pt-0">
                            <sendMessege                 
                                :chat="activedCh"
                            />
                        </v-col>
                    </v-row>
                </v-col>
            </v-row>
        </v-col>
        <infousercard
            :dialogdetail="dialogdetail"
            :person="person"
            @dialogdetailoff="dialogdetail=false"
        />
    </v-row>
</template>

<script>
    import infousercard from '@/components/UI/infousercard.vue';
    import { axiosInstance } from '@/utils/api'
    import { bus } from "@/main";
    import mMessegeList from './mess_layouts/m-messege-list.vue';
    import mChatList from './mess_layouts/m-chat-list.vue';
    import { createNamespacedHelpers } from "vuex";
    import mMessegeListRight from '@/components/supogramm/mess_layouts/m-messege-list-right.vue';
    import UiChatSearch from '@/components/supogramm/mess_layouts/UI/ui-chat-search.vue';
    import UiBtnNewChat from '@/components/supogramm/mess_layouts/UI/ui-btn-new-chat.vue';
    import UiSpisokChat from '@/components/supogramm/mess_layouts/UI/ui-spisok-chat.vue';
    import UiNameChat from '@/components/supogramm/mess_layouts/UI/ui-name-chat.vue';
    import UiChat from './mess_layouts/UI/ui-chat.vue';
    import sendMessege from '@/components/supogramm/mess_components/send-messege.vue';
    const auth = createNamespacedHelpers('auth')

    export default {
        name: "messenger-main",
        components: {
            mMessegeList,
            mChatList,
            mMessegeListRight,
            UiChatSearch,
            UiBtnNewChat,
            UiSpisokChat,
            UiNameChat,
            UiChat,
            infousercard,
            sendMessege
        },
        props: {
        


        },
        data () {
            return {
                place:'mainchat',
                waiter:false,
                mychats: [{id:0,users:[]}],
                activedCh: {},
                unreadNumer: {},
                totalunr:0,
                searchd:[],
                dialogdetail:false,
                person:{},
                offset:1
               
            }
        },
        computed: {

            ...auth.mapGetters(["getUser"]),

            sender(){

            let res =false
            try{
              res= this.activedCh.users.findIndex(el=>el.id==this.getUser.id)>=0
            }catch{}
            return res
        },

        },

        async mounted() {
        // console.log(this.$route);
        this.ws = new this.$pws()
        this.ws._retry=true;
        this.ws.start("/supogramm");
         this.ws.addEvent('onmessage', (event) => {
            const data = JSON.parse(event.data);            
            if ("action" in data) {
                try{this[data.action](data.payload)}
                catch(e){
                    
                     console.log( e,"ERROR")
                   }
            console.log( data.action,"DATA_ACTION")
            
            }
            else{console.log(data)}
           
        })
        // this.ws.addEvent('onclose', (event) => {
        //     // this.ws.start("/supogramm");
        //     console.log("FKFKFKFKFKFKFKFKFKFK")
        // })
        },
        async created(){
           bus.$on("supogrammchatcreate",this.supogrammchatcreate)  
           bus.$on("sendmessage",this.sendmessage) 
           bus.$on("previous",this.getprevious)        
           bus.$on("delmessager",this.delmessager)
        //    bus.$on("sendmessagesubchat",this.sendmessagesubchat)
        //    bus.$on("getprevious",this.getprevious)
           bus.$on("chatuserdialog",this.chatuserdialog)
           bus.$on("changechatperson",this.changechatperson)
        //    bus.$on("notmychatincome",this.newmessageincome)
        //    bus.$on('renewer', this.renew)
        },

        methods:{
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

            searchdfunc(val) {
                this.searchd=val
            },

            delmessager(val){
                
                    this.ws.send({'action':"delmessage", "payload": val})
            },
            supogrammchatcreate(data){
                
                this.ws.send({'action':"makechat", "payload": data})
            },
            changechatperson(data){               
                this.ws.send({'action':"updatechatusers", "payload": data})
            },
             changeactive(data){
                
                
                let chat = this.mychats.length>0?this.mychats.filter(el=> (el.parent==data.parent) && (el.level==data.level)):[undefined]
                
                if (chat[0]==undefined){
                    this.ws.send({'action':"readnotmychat", "payload": data})
                }else{
                    bus.$emit("foundedchat", chat[0])
                }
                


             },

            chatuserdialog(data){ 
                this.place=data.place
                if(data.chat.parent!=null){
                      this.ws.send({'action':"get_chat_project_persons", "payload": data.chat})                     

                }    else{
                  
                     this.ws.send({'action':"get_chat_persons", "payload": data.chat.id})     
                   
                }          
              
             
                
            },

            messagedeleted(payload){
                try{
                let ind = this.mychats.findIndex(e=>e.id==payload.chat)
                
                let ind2=this.mychats[ind].lastmessage.findIndex(e=>e.id==payload.id)
                this.mychats[ind].lastmessage.splice(ind2,1)
                
                }
                catch{}
                
                } ,

            chat_project_users(payload){
                
                bus.$emit("chat_project_users_send",{payload: payload,place:this.place})
             
            },
                
            chat_users(payload){
                    bus.$emit("chat_users_send",{payload: payload,place:this.place})
            },

      

            buildchat(payload){
               
                
                this.mychats=payload.chatlist
                this.searchd = this.mychats
                // bus.$emit("connected")
                if ("unreaded" in payload){
                    
                this.unreaded = payload.unreaded
                this.totalunr=0
                console.log(this.unreaded,"unreadeeeed");
                this.unreaded.forEach(el=>{
                    this.unreadNumer[el.chat.id] = el.chat.id in this.unreadNumer?  this.unreadNumer[el.chat.id] + 1: 1
                     this.totalunr+= 1
                })
                

                }
                try{this.activeChat(this.activedCh.id)}
                catch{}
                this.$emit('totaller',this.totalunr)
                // console.log(this.unreadNumer,"не прочитано");
            },
            renew(pl){
                
                this.ws.stop()
                this.ws.start("/supogramm");
               
            },
            sendmessagesubchat(data){
                 this.ws.send({'action':"sendmessage", "payload": data})
            },
            sendmessage(val){
             
               
               this.ws.send({'action':"sendmessage", "payload": {"id":val.id, "text":val.message}})
            },

            createchat(val){
               
                val.level = null
                val.parent=null
                let users = new Set([this.getUser.id])
                val.users.forEach(el=>users.add(el.id))
                val.users=Array.from(users)
                this.ws.send({'action':"makechat", "payload": val})
            },

            newmessageincome(payload){
               
            
                let index = this.mychats.findIndex(el=> el.id == payload.chat.id)
                console.log("index",this.activedCh);
                if((payload.sender.id != this.getUser.id) && (this.activedCh== undefined || Object.keys(this.activedCh).length==0 ||  this.activedCh.id != payload.chat.id)){  
                    console.log("ix", index);                 
                    let obana = Object.assign({},this.unreadNumer)
                    obana[payload.chat.id] = payload.chat.id in obana?  obana[payload.chat.id] + 1: 1                    
                    this.unreadNumer=obana
                }
                
                 
                
                
                if (this.mychats[index].lastmessage.length==0 || this.mychats[index].lastmessage[this.mychats[index].lastmessage.length-1].id!=payload.id)
                {this.mychats[index].lastmessage.push(payload)}
                
                this.$refs.mychat.scrollbottom(payload.id)
                if(payload.sender.id != this.getUser.id){
                    this.totalunr+=1
                    this.$emit('totaller',this.totalunr)

                }

            },
            delchat(){
                this.ws.send({'action':"leavechat", "payload": {"id":1}})
            },
            systemmessage(payload){
            

            },
            adduser(){
                this.ws.send({'action':"adduser", "payload": {"chat":1, "user":421}})
            },

            activeChat(id){    
                           
                try{
                    this.activedCh = this.mychats.find(e=> e.id == id)
                if (this.activedCh.lastmessage.length>0)
               {this.$refs.mychat.scrollbottom(this.activedCh.lastmessage[this.activedCh.lastmessage.length-1].id)}
            
                }
                catch{}
            },

            ireadit(){
                this.ws.send({'action':"ireadIt", "payload": {"chat":this.activedCh.id}})
            },

            newunreaded(payload){
                this.unreaded = payload
                this.totalunr=0
                this.unreadNumer={}
                this.unreaded.forEach(el=>{
                    this.unreadNumer[el.chat.id] = el.chat.id in this.unreadNumer?  this.unreadNumer[el.chat.id] + 1: 1 
                    this.totalunr+= 1
                })
                this.$emit('totaller',this.totalunr)
                console.log("Новые непрочитано", this.unreaded);
            },

            getprevious(data){
               console.log("getprevious");
                 let ind = this.mychats.findIndex(el=>el.id==data)  
              console.log(Math.ceil(this.mychats[ind].lastmessage.length/20), this.mychats[ind].lastmessage.length);
            if  ( ind>=0 && 'lastmessage' in this.mychats[ind] && this.mychats[ind].lastmessage.length>0)   {
            this.waiter=true 
            let offset= this.mychats[ind].lastmessage.length<20?  Math.ceil(this.mychats[ind].lastmessage.length/20): Math.ceil(this.mychats[ind].lastmessage.length/20)+1
            this.ws.send({'action':"getprevious", "payload": {"chat":data, 'offset': offset}})
            }
            },

            // previous(){  
            //    console.log("previous");
            // let ind = this.mychats.findIndex(el=>el.id==this.activedCh.id)  
            // if    (this.mychats[ind].lastmessage.length>0)   {
            //     console.log(Math.ceil(this.mychats[ind].lastmessage.length/20));
            // this.waiter=true  
            // this.ws.send({'action':"getprevious", "payload": {"chat":this.activedCh.id, 'offset': Math.ceil(this.mychats[ind].lastmessage.length/20)}})
            // }
            // },
    

            takeprev(payload){
                console.log(payload);
                if(payload.res.length>0){
                let ind = this.mychats.findIndex(el=>el.id==payload.chat)   
                
                if  (this.mychats[ind].lastmessage.length<20){
                    this.mychats[ind].lastmessage=payload.res
                    this.mychats[ind].lastmessage=this.mychats[ind].lastmessage
                // }
                // else if(this.mychats[ind].lastmessage.length==20){

                }
                else{
                this.mychats[ind].lastmessage = payload.res.concat(this.mychats[ind].lastmessage)
                 }
                }

                this.waiter=false


                 },



        },

        watch: {
            activedCh(val) {
                try{
                this.unreadNumer[val.id] > 0? this.ireadit(): console.log('пусто');
                }
                catch{

                }
            },

        },

        beforeDestroy(){
            console.log("стоп");
            this.ws._retry=false;
            this.ws.stop()
        }
    }
</script>


<style >
.mm-height {
    height: 85vh;
    width: 50vw;
}

.sm_border {

    border: 1px solid var(--v-granica-base);
}



</style>