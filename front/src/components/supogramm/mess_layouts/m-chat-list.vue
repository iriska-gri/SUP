<template>
<v-row class="m-chat-list">
    <v-col class="flex-col chat">
        <v-row class=" flex-grow-0">
            <v-col class=" pa-0 mcl_border rounded ">
                <Cards
                    height='40'
                    :elevation=0
                    color="inyand"
                >
                    <template #cards>
                        <v-row>
                            <v-col class="py-0">
                                <v-autocomplete
                                    class="inputext iconsh"
                                    dense
                                    :items="mychats"
                                    return-object
                                    item-value="chatTitle(item)"
                                    :item-text="item=>chatTitle(item)"
                                    :search-input.sync="searchat"
                                    clearable                             
                                >
                                </v-autocomplete>
                            </v-col>
                            <v-col class="flex-grow-0 pt-2">
                                <v-menu
                                    :close-on-content-click="false"
                                >
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-icon
                                            small
                                            v-bind="attrs"
                                            v-on="on"
                                            color="btns"

                                        >
                                            mdi-menu
                                        </v-icon>
                                    </template>
                                   
                                    <v-card
                                        width="250">
                                <v-list
                            
                                >
                                    <v-subheader>МЕНЮ</v-subheader>

                                  
                               
                                  <v-list-item-group        
                                    color="primary"
                                >   <v-list-item
                                v-for="(item, i) in creatormenu"
                                :key="i"
                                @click="dialogger(i)"
                                >
                                      <v-list-item-icon>
                                            <v-icon>{{item.icon}}</v-icon>
                                    </v-list-item-icon>
                                                <v-list-item-content>
                                                    <v-list-item-title>{{item.text}}
                                                    </v-list-item-title>
                                                    </v-list-item-content>
                                    </v-list-item>
                                     </v-list-item-group>
                                    </v-list>
                   </v-card>
                                </v-menu>
                            </v-col>
                        </v-row>  
                    </template>
                </Cards>
            </v-col>
        </v-row>
        <v-row>
            <v-col class=" flex-col">
                <v-row class="overflow-auto pt-2 chat hj">
                    <v-col class="flex-col mcl_border ind rounded">     
                        <v-list
                            dense
                            flat
                            class="inyand"
                        >
                            <template>
                                
                                <div  v-for="mychat in searchd"  :key="mychat.id">

                                   
                                <v-list-item
                                                                        
                    
                                    @click="$emit('activeChat', mychat.id)"
                                >
                                    <v-list-item-avatar
                                        class="ml-0 align-self-center"
                                        height=20
                                        width=20
                                    >
                                        <v-avatar
                                             :class="!$vuetify.theme.dark?'auchlight':'auchdark'"
                                            size=20
                                        >
                                            <span class="white--text text-chat">{{ getName(chatTitle(mychat)) }}</span>
                                            
                                        </v-avatar>
                                        
                                    </v-list-item-avatar>
                                        <div  v-show="unreadNumer[mychat.id] > 0"
                                        class="px-2 rounded-circle"
                                            style="position:absolute; left:10px; top:30px; background:red; z-index:1000 "
                                                            
                                                        > 
                                        <span class="text-caption white--text">{{ unreadNumer[mychat.id] }}</span>
                                            </div>
                                    <v-list-item-content class="align-self-center pa-0">
                                        <v-list-item-title class="ma-0">
                                            <span class="text-subtitle-2">
                                                {{ chatTitle(mychat) }}
                                            </span> 
                                        </v-list-item-title>
                                        <v-list-item-subtitle>
                                            <span class="text-caption">
                                                {{ mychat.lastmessage.length? mychat.lastmessage[mychat.lastmessage.length - 1].text.slice(0, 20) + (mychat.lastmessage[mychat.lastmessage.length - 1].text.length>20?"...": ''):'' }}
                                            </span> 
                                            
                                        </v-list-item-subtitle>
                                    </v-list-item-content>
                                </v-list-item>
                                 <v-divider></v-divider>
                            </div>
                            </template>
                        </v-list>
                    </v-col>
                </v-row>
            </v-col>            
        </v-row>
    </v-col>
        <v-dialog v-model="dialog"
 max-width="500"
 hide-overlay
>

         <mUserSearch
                                    :dialogtype="dialogtype"
                                    @createchat="createchat"
                                    ref="usersearch"
                                />
</v-dialog>
</v-row>

 
</template>

<script>

import mChatBar from '@/components/supogramm/mess_components/m-chat-bar.vue';
import mUserSearch from '@/components/supogramm/mess_components/m-user-search.vue';
import { createNamespacedHelpers } from "vuex";
const auth = createNamespacedHelpers('auth')

export default {

    components: {
        mChatBar,
        mUserSearch
    },

    props: {
        mychats: {
            type: Array,
            default: ()=>[]
        },
        unreadNumer: {
            type: Object,
            default: ()=>{}
        },
    },
    mounted(){
      
    },
    computed:
    {
          searchat:{
            get(){
                
                return this.searchterm    
                    },
                set(term) {
                   
                    if(term!=null && term.length>0){
                    this.searchd = this.mychats.filter(e=> this.chatTitle(e).match(term))
                  
                    }
                    else{
                            this.searchd = this.mychats
                    }
                
    },},},

    data() {
        return{
            creatormenu:[{text:"Начать разговор",icon:"mdi-chat-plus-outline"},{text:"Новая группа",icon:"mdi-forum-outline"}],
            numb:0,
            closeOnClick: true,
            searchterm:"",
            searchd:[],
            dialog:false,
            dialogtype:0
            // chats: [
            //     {group_name: 'Разработка ИСУП', users: ['Владимиров', 'Сапунов', 'Гришина'], last_seen: ''},
            //     {group_name: '', users: 'Владимиров Н.', last_seen: '15:34'}
            // ],

        }  
    },
   
    methods: {

        ...auth.mapGetters(["getUser"]),
        dialogger(it){
            this.dialogtype=it
            this.dialog=true

        },
        goChat(id) {
            this.$emit('activeChat', id)
        },
// this.chatColor = Math.floor(Math.random()*16777215).toString(16); 
// '#8DA399', '#7399E1', '#B09AE1', '#EB9C96', '#9ACA8F', '#CA8FC4', '#C7CA8F', '#8FCAFF', '#FFB68F', '#FFB5F5'
        getcolor() {
            let colors =  [
            '#8DA399', '#7399E1', '#B09AE1', '#EB9C96', '#9ACA8F', '#CA8FC4', '#C7CA8F', '#8FCAFF', '#FFB68F', '#6E7F80'
            ];
            this.chatColor = colors[Math.floor(Math.random() * colors.length)];
        return this.chatColor
        },

        getName(mychat) {
            let splitted = mychat.split(' ')
            let i=0
            let shn=''
            while (i<2 && i<splitted.length) {
                    shn += splitted[i][0].toUpperCase()
                    i++
            }

            return shn
        },

        chatTitle(mychat) {
            if(mychat.name != null){
                // console.log(mychat.name);
                return mychat.name
            } else {
                let nam = ''
                mychat.users.forEach(el => {
                    if(el.id != this.getUser().id){
                        let snn = el.givenName.split(' ')
                        // console.log(el.sn + snn[0][0]);
                        nam = el.sn + ' ' + snn[0][0] + '.'
                    }
                })
                return nam
            }
        },

        itsAlive(val){
            console.log(val, 'OOOOOOOOOOOOOOO');
            this.$emit('letsChat', val)
        },

        createchat(val){
            this.dialog=false
            this.$refs.usersearch.users=[]
            this.$refs.usersearch.groupName=""
            this.$emit("createchat",val)
        },


    },
    watch:{
        mychats(){            
            this.searchd = this.mychats
        }
    }
}
</script>

<style >

.chatsListwraper {
    height: 100%;
    box-sizing: border-box;
    display: grid;
    /* border: 1px solid blue; */
    gap: .5%;

    grid-template-areas: 
    "A A A"
    "B B B"
    "B B B";

    grid-template-rows: 7% 1fr;
}

.cListHeader {
    border: 1px solid grey;
    grid-area: A;
}

.cListBody {
    border: 1px solid grey;
    background-color: #F5F5F5;
    grid-area: B;
}

.chatBar {
        /* border: 1px solid; */
        margin-bottom: .1em;
        cursor: pointer;
    }

.inputext {
  font-size: 0.9rem!important;
  color: black;
}

.col_inp 
    .v-icon.v-icon {
    font-size: 17px;
    }

.mcl_border {
    border: 1px solid var(--v-granica-base)!important;

}

.iconsh 
  .v-icon.v-icon {
    font-size: 14px!important;
}

.text-chat {
    font-size: 0.5rem !important;
}

.hj {
    height: 0
}

.ind {
    background-color: var(--v-inyand-base);
}



</style>