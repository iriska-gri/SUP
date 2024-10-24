<template>
    <Cards
        color="inyand"
        :ma="'ma-0'"
        
    >
        <template #cards>
            <DialogNewAssigment
                text="Создать разговор"
                class="umdgsearch_height"
                mycolor="'main_theme'"
            >
                <template #textarea>
                    <v-autocomplete 
                        dense
                        class="inputext pa-3 iconsh passiv_text--text"
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
                        class="elevation-1 overflow-y-auto flex-grow-1"
                        :search="search"
                    >
                        <template v-slot:[`group.header`]="{items, isOpen, toggle}">
                            <th :colspan="2">
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
                        <template v-slot:[`item.involve`]="{ item }">
                            <MyIco 
                                @click="involving(item)"  
                                size="small"
                                :color='alreadyinuser(item)?"green":"primaryicons"'
                                :icons='alreadyinuser(item)?"mdi-check":"mdi-plus"'/>
                        
                        </template> 
                    </v-data-table>
                </template>
                <template #btn2>
                    <BtnsOut
                        title="Создать"
                        @click="logData"
                    />
                </template>
            </DialogNewAssigment>
        </template>
    </Cards>
</template>

<script>
import { createNamespacedHelpers } from "vuex";
const auth = createNamespacedHelpers('auth')
import {axiosInstance} from '@/utils/api'
import getFilters from '@/utils/filterutil'


export default {

    props: {
        dialogtype: {
            type: Number,
            default: 4
        },

        dialog: {
            type:Boolean,
            default:false
        }
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
                value:"involve"
            }
            ],
            search:"",
            settingsFilt: [],
            users:[],
          
        }
    },

    watch: {


        globalsearch (val) {
            // чувак загружен
            console.log(val, '<<<<<<<<<<<<<<<<<<<');
            let flag = false
            // console.log(flag);
            if (!val||val==' ')return
       
                if (this.itemss.length > 0 ) {

                    flag = this.itemss.some(e=> e.fullname.toUpperCase().indexOf(val.toUpperCase().trim())===0)
                
                }
          
                // запрос уже идет
                if ((this.isLoading) || flag )        
            {
                // console.log('TUTA');
                return
                }

        this.isLoading = true
        this.settingsFilt=[{user:{sort:"sn",filters:{sn__istartswith:val.trim()},select_related:["otdel",'department','organization','position']}}]
        
        // грузим
        axiosInstance.post( "/filters/",
            this.settingsFilt)     
          .then(res => {  
            let ind = res.data.user.findIndex(e=>e.id==this.getUser().id)
            if (ind>-1) res.data.user.splice(ind,1)
            // console.log(res);
            this.entries = res.data.user
            
           
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

        itemss () {
            return this.entries.map(entry => {          
                return Object.assign({}, entry)
            }
        )
      },
    },


    methods: {
        ...auth.mapGetters(["getUser", ]),
           
    alreadyinuser(item){
      if(this.users.findIndex(e=>e.id==item.id)>-1 ){
        return true
      }
      return false
    },


    involving(item){
        let indx = this.users.findIndex(e=>e.id==item.id)
        
           if(indx>-1 ){ 
            this.users = []
        
        }
        else{
            this.users=[item]
        }
   
    },





    
        



        logData() {        
        this.$emit('createchat',{name:null, users:this.users})
        
        },



        
    
    }

    
}
</script>

<style>

.umdgsearch_height {
    height: 256px;
}

</style>