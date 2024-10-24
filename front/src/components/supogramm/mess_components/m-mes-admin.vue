<template>
<div>

    <v-dialog
        v-model="dialog"
        ref="mainchat"
        persistent
        max-width="800"

        hide-overlay
        
    >
           <Cards
        color="inyand"
        :ma="'ma-0'"
        
    >
        <template #cards>
<DialogNewAssigment
                class="mmadmin_height"
                mycolor="'main_theme'"
                ma="heightCard_m_mes_admin"
            
            >
        <template #texts>
            <v-text-field
                v-if="chat!=null && chat.parent==null && chat.name!=null && user_chatadmin"
                v-model="chatname"     
                single-line
                dense
                hide-details
                class="text-h6  fd"
            ></v-text-field>
      <span class="text-h6 se" v-else> Чат</span>
        </template>
        <template #pass>
<v-row>
    <v-col>
      <v-text-field v-if="user_chatadmin"
        v-model="search"
        append-icon="mdi-magnify"
        label="Поиск"
        single-line
        hide-details
      ></v-text-field>
        <h4 v-else-if="chat!=null && chat.parent==null && chat.name!=null && !user_chatadmin">
        {{chatname}}


    </h4>
    </v-col>
</v-row>
<v-row class="my-0" v-if="chat!=null && chat.parent==null && user_chatadmin">
    <v-col class="px-0">
            <mUserChanger
        
        @activateperson="activateperson"
        :chatusers="chatusers"
        @admin_del_error="admin_del_error"
        @adduserfromsearch="adduserfromsearch"
    
        ref="userchanger"
                                /> 
    </v-col>
</v-row>

        </template>
    <template #textarea>

      

  
     
    <v-data-table 
   
    class="ma-2"
    dense
    :headers="chatusersHeaders"
    :items="chatusers"
    hide-default-footer
    sort-by="fullname"
     :search="search"
    >
  

        <template v-slot:[`item.chatman`]="{ item }">
            <v-btn
            @click="user_chatadmin?$emit('chatman_change',item):''"
             icon>
                <v-icon
                color="green"
                 v-show="item.chatman">
               mdi-check-bold</v-icon>
               <v-icon v-show="!item.chatman">
               </v-icon>             
               </v-btn>
    
      </template>
      <template v-slot:[`item.fullname`]="{ item }">
        <strong v-if="item.id==currentuser"  style="cursor: pointer" @click="activateperson(item)">{{item.fullname}} (Вы)</strong>
        <span  style="cursor: pointer" @click="activateperson(item)" v-else>{{item.fullname}}</span>
      </template>
        <template v-slot:[`item.admin`]="{ item }">
            <v-btn
            @click="user_chatadmin?$emit('admin_change',item):''"
            
             icon>
             <v-icon
             color="red"
              v-show="item.admin">
               mdi-star-check-outline</v-icon>
               <v-icon v-show="!item.admin">
               </v-icon>    
               </v-btn>  
     
      </template>
    
    
    
    
    </v-data-table>
   





    </template >
                    <template #btn1  v-if="user_chatadmin">
          <BtnsOut
            title="Сохранить"
            @click="confirmchanges"
            :disabled="adminerror"
          />
        </template>
        <template #btn2>
          <BtnsOut
            title="Закрыть"
            @click="dialog=false"
            :disabled="adminerror"
          />
        </template>

            </DialogNewAssigment>

<!--  --> </template></Cards>
</v-dialog>
       


<v-snackbar
            timeout="-1"
            v-model="adminerror"
            class="pt-15"
            color="red lighten-1"
            top
        >
             Админ должен быть участником чата
            <template v-slot:action>
                <v-btn
                    color="white"
                    text
                    
                    @click="$emit('adminerror',false)"
                >
                Закрыть
                </v-btn>
            </template>
        </v-snackbar>
        <infousercard :dialogdetail="dialogdetail"

                :person="person"
                @dialogdetailoff="dialogdetail=false"
            />

</div>



</template>
<script>
import mUserChanger from '../mess_components/m-user-changer.vue';
import infousercard from '@/components/UI/infousercard.vue';
export default {
    name:"mmesadmin",
    components:{mUserChanger, infousercard},
    props:{
        user_chatadmin:{
            type:Boolean,
            default:false
        },
        chat:{
            type:Object,
            default:()=>{}
        },
        chatusers:{
            type:Array,
            default:[]
        },
        currentuser:{
            type:Number,
            default:0
        },
        adminerror:{
            type:Boolean,
            default:false
        }
    },
    computed:{
        chatname:{
            get(){
                return this.chat.name
            },
            set(val){
                    this.$emit("changechatname",val)
            }
        }
    },
    
    data(){
        return {
            person:{},
            changechat:false,
            dialog:false,  
            dialogdetail:false,          
            search: '',
            chatusersHeaders: [
           { text: 'Имя',
            
            value: 'fullname',
            groupable: false,
          },
          { text: 'Должность', value: 'position.name', align: 'right' },
          { text: 'Участник', value: 'chatman', align: 'right' },
        { text: 'Админ', value: 'admin', align: 'right' }
        ],
        }
    },
    
    methods:{
        adduserfromsearch(item){
            
            this.$emit('chatman_add',item)
        },
       admin_del_error(){

        // this.adminerror=true
        this.$emit('adminerror',true)
       },
        showdial(){
            this.dialog=true
        },
        confirmchanges(){
            this.dialog=false
            this.$emit('confirmch')
        },
        activateperson(item){
            this.person = item
            this.dialogdetail=true
        }
    }
}

</script>
<style >


.heightCard_m_mes_admin {
    height: 500px;
    margin: 12px;
}




</style>