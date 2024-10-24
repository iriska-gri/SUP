<template>
    <v-card
    class="pa-4"
   
    >

            <v-autocomplete 
                dense
                class="inputext my-0 iconsh passiv_text--text"
                v-model="searchbase"
                :items="itemss"
                :loading="isLoading"
                :search-input.sync="globalsearch"
                item-color="open_icons"
                color="btns"
                clearable
                hide-no-data
                hide-details
                item-text="fullname"
                item-value="fullname"
                label="Глобальный поиск"
                placeholder="Начните вводить фамилию"
                return-object
            ></v-autocomplete> 
         
            <v-data-table
                
                hide-default-footer
                hide-default-header
                dense
                :headers="headers"
                :items="fields"
                item-key="id"
                sort-by="sn"
                group-by="otdel.name"
                class="elevation-1  menus1 overflow-y-auto mt-2"
                :search="search"
            >

                <template v-slot:[`group.header`]="{items, isOpen, toggle}">
                <th 
                :colspan="dialogtype==0?2:1">
                    <MyIco   
                    @click="toggle"    
                    size="x-small"
                    color="primaryicons"
                    :icons = 'isOpen ? "mdi-minus" : "mdi-plus"'
                    class="text-center"
                    />
                    {{ items[0].otdel.name }}
                </th>
     
                </template> 
                  <template v-slot:[`item.fullname`]="{ item }">
                    <strong v-if="item.id==getUser.id"  style="cursor: pointer"  @click="$emit('activateperson',item)">{{item.fullname}} (Вы)</strong>
                    <span  style="cursor: pointer" @click="$emit('activateperson',item)" v-else>{{item.fullname}}</span>
                </template>




                <template v-slot:[`item.chatman`]="{ item }">
                <MyIco 
                    @click="involving(item)"  
                    size="small"
                    :color='item.chatman?"green":"primaryicons"'
                    :icons='item.chatman?"mdi-check":"mdi-plus"'/>
                   
                </template> 
            </v-data-table>
          

    </v-card>
</template>

<script>
const { mapGetters } = createNamespacedHelpers("auth");
import { createNamespacedHelpers } from "vuex";
const auth = createNamespacedHelpers('auth')
import {axiosInstance} from '@/utils/api'
import getFilters from '@/utils/filterutil'
import MyIco from '@/components/UI/MyIco.vue'
import Cards from '@/components/UI/Cards.vue'

export default {

    props: {
       
        dialogtype: {
            type: Number,
            default: 4
        },
        chatusers:{
            type:Array,
            default: ()=>[]
        }
        
    },

    components: {        
  
        MyIco,
        Cards
        
    },

    mixins:[getFilters],

    data() {
        return {
            searchbase: null,
            entries: [],
            isLoading: false,
            globalsearch: null,
            headers: [
            {
                text: 'ФИО ',
                value: 'fullname',
                groupable: false,
            },      
        
            {
                text:"",
                value:"chatman"
            }
            ],
            search:"",
            organization_value:[],
            organization: [],
            department_value:[],
            department:[],
            settingsFilt: [],
          
            groupName: ''
        }
    },


    watch: { 
        chatusers(val){
            
            this.chat_users=val
              this.itemss.forEach((el) => {               
                el.chatman=this.chat_users.findIndex(e=>
                    ((e.id==el.id) && (e.chatman==true))
                    )>-1?true:false                
            });
               
                // this
        },
     
        dialogtype(val){
       
        if(val==0){
          
        this.entries=[]   
   
        }
        else{
          this.firstload()
        }
        },

        globalsearch (val) {
            // чувак загружен
        
            let flag = false
           
            if (!val||val==null||val==' ')return
       
                if (this.itemss.length > 0 ) {

                    flag = this.itemss.some(e=> e.fullname.toUpperCase().indexOf(val.toUpperCase().trim())===0)
                
                }
          
                // запрос уже идет
                if ((this.isLoading) || flag )        
            {
               
                return
                }

        this.isLoading = true
        console.log(this.chat_users,"cgusers");
        axiosInstance.post( "/filters/snistartswith", [{terms:{sn__istartswith: val.trim()}}])     
          .then(res => {              
            res.data.forEach((el) => { 
              
                el.chatman=this.chat_users.findIndex(e=>
                    ((e.id==el.id) && (e.chatman==true))
                    )>-1?true:false
                
            });
          
            this.entries = res.data
            
           
          })
          .catch(err => {
            console.log(err)
          })
          .finally(() => {
            
            this.isLoading = false}
            )
      },
    },

    
    computed: {
      
        ...mapGetters(["getUser", ]),
          chat_users:{
            get(){
                
                return this.chatusers
            },
            set(val){
               
                
                  val.forEach((el) => { 
              
                el.chatman=this.chat_users.findIndex(e=>
                    ((e.id==el.id) && (e.chatman==true))
                    )>-1?true:false
                
            });
            this.chatusers=val




            }

        },
        fields : {

            get() {
       
                if (!this.searchbase && this.dialogtype!=1)
                {
                return []       
                }
                else{   
                    return this.itemss
                }
            } ,
            set(val){
                this.fields=val
            } 
        },

        itemss: {
            get(){
            return this.entries.map(entry => {          
                return Object.assign({}, entry)
            }          

        )},
            set(val){
                
            }

      },
    },
    async mounted(){
      
         
            this.firstload()
       
    },

    methods: {
  
           
    alreadyinuser(item){
      
      if(this.chatusers.findIndex(e=>e.id==item.id)>-1 ){
        return true
      }
      return false
    },
   

    involving(item){
        
        item.chatman=!item.chatman
        let el = this.chatusers.find(e=>e.id==item.id)
        
            if (el!=undefined && el.admin==true) {
                item.chatman=true
                this.$emit("admin_del_error")
                }
            else{
                    this.$emit("adduserfromsearch",item)
            }
            

   
   
    },
   
  


        async firstload(){      
              this.build()
            },    
        

        build(){      
  
            this.entries=[]
           


    },

 



        
    
    }

    
}
</script>

<style scoped>

</style>