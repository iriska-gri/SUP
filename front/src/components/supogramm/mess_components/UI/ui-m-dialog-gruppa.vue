<template>
    <Cards
        color="inyand"
        :ma="'ma-0'"
    >
        <template #cards>
            <DialogNewAssigment
                text="Создать новую группу"
              
                mycolor="'main_theme'"
                
            > 
            <template #textarea>
        <!-- <v-col class="pa-0"> -->
            <v-text-field
            label="Введите название группы"
            v-model="groupName"

            >
            </v-text-field>
             <div >
        <v-card class="px-2 mb-2">
          <v-autocomplete
            v-model="organization_value"
            :items="organization"
            dense
            @change="changeorg"
            class="inputext my-0 iconsh"
            hide-details
            item-color="open_icons"
            color="primaryicons"
          >
          </v-autocomplete>
        </v-card>
        <v-card class="px-2 mb-2">
          <v-autocomplete
            v-model="department_value"
            :items="department"
            dense
            @change="changedep"
            class="inputext my-0 iconsh"
            hide-details
            item-color="open_icons"
            color="primaryicons"
          ></v-autocomplete>
        </v-card>
        <v-card class="px-2 mb-2 ">
          <v-text-field
            v-model="search"
            single-line
            hide-details
            dense
            color="primaryicons"
            class="inputext pa-0 pr-1"
          >
            <template #append>
              <MyIco       
                size="small"
                class="pt-1"
                color="primaryicons"
                icons = 'mdi-magnify'
              />
            </template>
            <template #label>
              <span class="inputext passiv_text--text">
                Поиск
              </span>
            </template>
          </v-text-field>
        </v-card>
      </div>
          
         
            <v-data-table
                
                hide-default-footer
                hide-default-header
                dense
                :headers="headers"
                :items="fields"
                item-key="id"
                sort-by="sn"
                group-by="otdel.name"
                class="elevation-1 overflow-y-auto umdgruppa_height "
                :search="search"
            >
                <template v-slot:[`group.header`]="{items, isOpen, toggle}">
                <th 
                :colspan="1">
                    <MyIco   
                    @click="toggle"    
                    size="x-small"
                    color="primaryicons"
                    :icons = 'isOpen ? "mdi-minus" : "mdi-plus"'
                    class="text-center"
                    />
                    {{ items[0].otdel.name }}
                </th>
                <th >
                    <MyIco   
                    @click="involveall(items[0])"   
                    size="small"
                    color="primaryicons"
                    :icons = 'alreadyinusermany(items[0])?"mdi-minus-box-multiple-outline":"mdi-plus-box-multiple"'
                    />
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

           
        <!-- </v-col> -->
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



    mixins:[getFilters],

    data() {
        return {
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
            organization_value:[],
            organization: [],
            department_value:[],
            department:[],
            settingsFilt: [],
            users:[],
            groupName: ''
        }
    },

    watch: {
        dialogtype(val){
        console.log(val)
        if(val==0){
          
        this.entries=[]   
   
        }
        else{
          this.firstload()
        }
        },

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
      
                    return this.itemss
             
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
    async mounted(){
  
            this.firstload()
         
    },

    methods: {
        ...auth.mapGetters(["getUser", ]),
           
    alreadyinuser(item){
      if(this.users.findIndex(e=>e.id==item.id)>-1 ){
        return true
      }
      return false
    },
    alreadyinusermany(item){
    if(this.users.some(e=>e.otdel.id==item.otdel.id) ){
        return true
      }
      return false
    },

    involving(item){
        console.log(`item`, item, this.user);
        let indx = this.users.findIndex(e=>e.id==item.id)
        
           if(indx>-1 ){ 
            this.users.splice(indx,1)
        
        }
        else{
          
            item.involve=true
            this.users.push(item)
       
        }
   
    },
    async changeorg(val){
      this.department_value=[]
      this.department=[]
      this.users=[]
      this.settingsFilt=[{department:{sort:"name",filters:{department_user__organization__name: val},exclude:[]}}]
      let res = await this.getFilters(this.settingsFilt)      
      this.build(res.data)
      this.department_value= this.department[0]
      await this.changedep(this.department_value)
     },
    async changedep(val){
      
      this.settingsFilt=[{user:{sort:"sn",filters:{department__name: val, organization__name: this.organization_value},select_related:["otdel",'position']}}]
      let res = await this.getFilters(this.settingsFilt)      
      this.build(res.data)
    },


        async firstload(){
        this.settingsFilt = [{organization:{starttable:"organization", sort:"id"}},
                                    {department:{sort:"id",filters:{department_user__organization: this.getUser().organization.id}}},
              {user:{sort:"sn",filters:{department__id: this.getUser().department.id},select_related:["otdel",'position']}}
              
              
              ]
              let res = await this.getFilters(this.settingsFilt)      
              this.build(res.data)
            },


    
        

        build(data){      
              
            if ('user' in data){          
            this.entries=data.user;  
          
            }
            else{
            this.entries=[]
            }
         
            for (let [key,val] of Object.entries(data)){
            if (key !='user'){
            val.map(el=>{this[key].push(el.name)
            if (el.id==this.getUser()[key].id){this[`${key}_value`]=el.name}          
            })      
            
            }      
        
        } 



    },

        logData() {
        if (this.groupName.length==0) return
      
        this.$emit('createchat',{name:this.groupName, users:this.users})
        
        },


        involveall(item){
  
            let indx = this.users.findIndex(e=>e.otdel.id==item.otdel.id)
            if (indx>-1){
                this.users = this.users.filter(e=>e.otdel.id!=item.otdel.id)
            }
            else{
            this.entries.map(el=>{
                if (el.otdel.id==item.otdel.id){  
                  
                    this.users.push(el)  
            }}
            )
            }
  
    
    },
        
    
    }

    
}
</script>

<style>

.umdgruppa_height {
    height: 250px;
}

</style>