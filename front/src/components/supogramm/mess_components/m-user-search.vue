<template>
    <v-card
    class="pa-4"
   
    >
        <!-- <v-col class="pa-0"> -->
            <v-text-field v-if="dialogtype == 1"
            label="Введите название группы"
            v-model="groupName"

            >
            </v-text-field>
             <div v-if="dialogtype == 1" >
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
            <v-autocomplete v-else
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
                <th v-if="dialogtype==1">
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

            <v-btn small class="mt-3"
                @click="logData"
            >
                создать
            </v-btn>
           
        <!-- </v-col> -->
    </v-card>
</template>

<script>
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
            // if (this.tab==0)
            //     return this.entries 
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
    async mounted(){
         if(this.dialogtype==1){
            this.firstload()
         }
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
        let indx = this.users.findIndex(e=>e.id==item.id)
        
           if(indx>-1 ){ 
            this.users.splice(indx,1)
        
        }
        else{
        if(this.dialogtype==0){
            this.users=[item]
            
        }
        else if(indx==-1 && this.dialogtype==1){
            item.involve=true
            this.users.push(item)
        }
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
               console.log(data)
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
        if (this.dialogtype>0 && this.groupName.length==0) return
        let name = this.dialogtype>0? this.groupName:null        
        this.$emit('createchat',{"name":name, users:this.users})
        
        },



        notinuserIndex(items){
     
        },
        involveall(item){
                console.log("involve")
                console.log(item)
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
    //   let notinclude=[]
    //   let usersarr 
      
    //   let res = !item.involve   
     
    // //   if (this.mod=="watchers"){
    // //      this.getProjectusers().forEach(e=>notinclude.push(e.id))
    // //   }
      
    //   this.entries.map(el=> {
    //     if (el.otdel.id==item.otdel.id){       
    //         el.involve =res
    //         if (res){
    //           if (usersarr.findIndex(e=>e.id==el.id)==-1){
    //           usersarr.push({id:el.id,otgel_id:el.otdel.id, otdel_name:el.otdel.name, fullname:el.fullname})
    //           }
    //     }else{
    //    usersarr = this.usersplicer(el.id, usersarr)
    //   }
    //   }})
   
    //   this.users=usersarr
    
    },
        
    
    }

    
}
</script>

<style scoped>

</style>