<template>
  <v-menu  
    v-model="isOpened"                          
    :close-on-content-click="false"
    min-width="500"
    max-width="500"
  > 
    <template v-slot:activator="{ on, attrs }" >   
      <div 
        v-bind="attrs"
        v-on="on"
      >
        <BtnsOut              
          :widthi=97
          :icon = true
          :title = addtext
        >
          <template #icons>
            <MyIco
              size="large"
              icons = 'mdi-account-plus'
            />
          </template>                         
        </BtnsOut>
      </div>
    </template>           
    <v-tabs
      vertical
      v-model="tab"
      color="select_lines_border"
      class="menus"
    >
    <v-tab active-class="active"
      v-for="i in iconsmenus"
      :key="i"
    > 
      <v-icon color="icons">
        {{i}}
      </v-icon>
    </v-tab>
    <v-tab-item
      v-for="i in 2"
      :key="i"
    >
      <Cards
        :color="!$vuetify.theme.dark?'auchlight':'auchdark'"
        class="menus"
      >
        <template #cards>
          <v-card-text class="pa-0">
            <div v-if="i==1" >
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
            <div v-else-if="i==2" >
              <v-card class="px-2 mb-2 ">
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
              </v-card>
            </div>
      <!-- Таблица списка имен -->
            <v-data-table
              @dblclick:row="openPersonalCards"
              hide-default-footer
              hide-default-header
              dense
              :headers="headers"
              :items="fields"
              item-key="id"
              sort-by="sn"
              group-by="otdel.name"
              class="elevation-1  menus1 overflow-y-auto"
              :search="search"
            >
              <template v-slot:[`group.header`]="{items, isOpen, toggle}">
                
                <th :colspan="[5,6].includes(mod)?1:2">
                  <v-row>
                    <v-col class="flex-grow-0 pr-0">   
                      <MyIco   
                        @click="toggle"    
                        size="small"
                        color="primaryicons"
                        :icons = 'isOpen ? "mdi-minus" : "mdi-plus"'
                        class="text-center"
                      />
                    </v-col>
                    <v-col >
                      {{ items[0].otdel.name }}
                    </v-col>
                  </v-row>

                    
                </th>
                <th v-if="[5,6].includes(mod) && tab==0">
                  <MyIco   
                    @click="involveall(items[notinuserIndex(items)])"   
                    size="small"
                    color="primaryicons"
                    :icons = involv(items)
                  />
                </th>
              </template>
              <!-- v-if="alreadyinuser(item)" -->
              <template v-slot:[`item.involve`]="{ item }">
                <MyIco
                  size="large"
                  v-if="notincludesusers(item).result"
                  @click="involving(item)"  
                  :color='item.involve?"green":"primaryicons"'
                  :icons='item.involve?"mdi-check":"mdi-plus"'
                />
              </template>
            </v-data-table>
          </v-card-text>
        </template>
      </Cards>
<!-- Диалоговое окно информацуии об участнике -->
      <infousercard
        :dialogdetail="dialogdetail"
        :person="person"
        @dialogdetailoff="dialogdetail=false"
      />
    
    </v-tab-item>
  </v-tabs>
</v-menu>    
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import {axiosInstance} from '@/utils/api'
import MyIco from '@/components/UI/MyIco.vue'
import getFilters from '@/utils/filterutil'
import Cards from '@/components/UI/Cards.vue'
import infousercard from './infousercard.vue';
const projectstate = createNamespacedHelpers("projectstate");
const auth = createNamespacedHelpers('auth')

export default {

   components: {        
      infousercard,
      MyIco,
      Cards
           
    },

    mixins:[getFilters],
    props:{
     
      mod:{
        type:Number,
        default:0
      },
      addtext:{
        type:String,
        default:"Добавить"
      },


    },
    
     data: () => ({ 
      person:{},
      isOpened:false,
      tab:0,       
      entries: [],
      isLoading: false,
      searchbase: null,
      globalsearch: null,
      search:"",
      organization_value:[],
      organization: [],
      department_value:[],
      department:[],
      settingsFilt: [],
      iconsmenus: ['mdi-account-multiple-plus', 'mdi-database-search'],
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
        detailedit: {},
        detailsextended: {},
       
        dialogdetail: false,
        users:[],

  }

     ),
    computed: {
     
      fields : {

        get() {
          if (this.tab==0)
            return this.entries 
          else if (!this.searchbase)
          {
          return []       
          }
          else if (this.tab==1){   
            return this.itemss
          }
        }  
      },

      itemss () {
        return this.entries.map(entry => {          
          return Object.assign({}, entry)
        }
        )
      },



     


  },
  watch: {
      tab(val){
        if(val==1){
          
        this.entries=[]   
   
        }
        else{
          this.firstload()
        }
      },
      isOpened(val){
        
          if (val){this.firstload()}
      },


      
      globalsearch (val) {
        // чувак загружен
       
        let flag = false
        // console.log(flag);
        if (!val||val==' ')return
       
        if (this.itemss.length > 0 ) {

          flag = this.itemss.some(e=> e.fullname.toUpperCase().indexOf(val.toUpperCase().trim())===0)
          
        }
          
        // запрос уже идет
        if ((this.isLoading) || flag )        
      {
          return
          }

        this.isLoading = true
        this.settingsFilt=[{user:{sort:"sn",filters:{sn__istartswith:val.trim()},select_related:["otdel",'department','organization','position']}}]
        
        // грузим
        axiosInstance.post( "/filters/",
            this.settingsFilt)     
          .then(res => {  
            
            this.entries = this.checkinvolving(res.data.user)

            
          })
          .catch(err => {
            console.log(err)
          })
          .finally(() => {
            
            this.isLoading = false}
            )
      },
    },
    mounted(){
     
      // console.log(this[`getProject${this.mod}`]());
      // console.log('user',this.getUser());
    },

     methods: {
    
    ...projectstate.mapGetters(["getProject",`getProjectdirector`,'getProjectusers','getProjectwatchers','getProjectrp', 'getProjectcoordinator', 'getProjectsecretary']),  
    ...auth.mapGetters(["getUser", ]),
    ...projectstate.mapMutations(["setProject",'setProjectdirector','setProjectusers','setProjectwatchers','setProjectrp','setProjectcoordinator','setProjectsecretary']),
    
    notincludesusers(item) {
      let result = false
      let freeuser = []
      if([6].includes(this.mod)){
        this.getProject().users.forEach(e=>
          {
            if (e.role.id!=6) {
              freeuser.push(e.user.id)
            }
          }
        )
        this.entries.filter(el=>
          {
            if (!freeuser.includes(el.id))
              { 
                if (item.id == el.id)
                {
                  result= true
                }
              }
            }
        )
      }
      else {
        result = true
      }
      return {result: result, freeuser: freeuser}
    },


    involv(items) {
      let departmentUsers = []
      let departmentUsersTrue =[]
      let check = 0
      items.filter(el => 
        {
          if (!this.notincludesusers(items).freeuser.includes(el.id)) {
            departmentUsers.push(el.id)
          }
          if (el.involve == true) {
              departmentUsersTrue.push(el.id)
          }
        }
      )
      if (this.mod==5) {
        check = items.length
      }
      else {
        check = departmentUsers.length
      }
      return check==departmentUsersTrue.length?"mdi-minus-box-multiple-outline":"mdi-plus-box-multiple"
    },

    notinuserIndex(items){
      if([6].includes(this.mod)){
        let alreadyusers = []
        let indx=-1
        for(let i=0;i<items.length; i++){
          indx=alreadyusers.findIndex(e=>e==items[i].id)
          if(indx==-1) return i
        }
            return 0
          }
          return 0
        },

    
    
    
    alreadyinuser(item){
      if([6].includes(this.mod) && (this.getProject().users.findIndex(e=>e.user.id==item.id && e.role.id!=this.mod)>-1)){
        return false
      }
      return true
    },
    involvedotdel(item){
    
      let filtero = this.entries.filter(el=>el.otdel.id==item.otdel.id)

      return filtero.every(el=>el.involve==true)
    },



  
    involveall(item){     
      let usersarr = this.getProject().users
      let departmentUsers = []
      let departmentUsersTrue = []
      let deleteUser = []
      this.entries.filter(el=>{
        if (this.mod == 5) {
          if (el.otdel.id==item.otdel.id) {
            departmentUsers.push(el.id)
          }
          if (el.involve==true && el.otdel.id==item.otdel.id) {
            departmentUsersTrue.push(el.id)
          } 
        }         
          if (!this.notincludesusers(item).freeuser.includes(el.id))
            { 
            if (this.mod == 6) {
              if (el.otdel.id==item.otdel.id) {
                departmentUsers.push(el.id)
              }
              if (el.involve==true && el.otdel.id==item.otdel.id) {
                departmentUsersTrue.push(el.id)
              } 
            } 
         
              if (el.involve==false && el.otdel.id==item.otdel.id ) {
                let user = {id:el.id, fullname:el.fullname}
                deleteUser.push(el.id)
                usersarr.push({role:{id:this.mod}, user:user})
                el.involve = true      
              }
              if (this.mod == 5) {
              deleteUser.map(del=>
              {
                let indexdel = usersarr.findIndex(e=>e.role.id!=5 && e.user.id == del)
                  if(indexdel>-1){
                    usersarr.splice(indexdel,1)
                  }
              })
              }
            }
          }
      )
      if (departmentUsers.length==departmentUsersTrue.length) {
        departmentUsers.map(dep=>{
          this.entries.filter(el=> {
            let indexdel = usersarr.findIndex(e=>e.user.id == dep )
              if(indexdel>-1){
                usersarr.splice(indexdel,1)
              }
              if (el.involve == true &&  el.otdel.id==item.otdel.id ) {
                 el.involve = false 
              }
          }
          )
        }
        )

      }
    console.log('Запись всех пользователей прошла успешно');
    this.setProjectusers(usersarr)
    },


    usersplicer(elId,usersarr){
       let i=0
        while (i<usersarr.length){
          if (elId==usersarr[i].user.id && this.mod==usersarr[i].role.id){  usersarr.splice(i,1)
          }

          else{
            i++
            
          }
        }
      return usersarr
    },

      singleadd(item){
        
        let users = this.getProject().users;
        let ent = this.entries.findIndex(e=>e.involve==true && e.id!=item.id)
        let check = this.entries.findIndex(e=>e.id==item.id)
        let us = users.findIndex(e=>[5,6].includes(e.role.id) && e.user.id==item.id)
        let cur = users.findIndex(e=>e.role.id==this.mod && e.user.id==item.id)
        let ind = users.findIndex(e=>e.role.id==this.mod)
        let user = {id:item.id, fullname:item.fullname}
        console.log(`users`, users);
        if (item.involve == false) {
          users.splice(cur,1)
        }
        else {
          if (ind == -1) {
             users.push({role:{id:this.mod}, user:user})
          }
        }

        if (us >-1) {
          users.splice(us,1)
        }

        if (ent >-1) {
          if (this.entries[ent].involve=false)
          {
            this.entries[check].involve=true
          }
            this.entries[ent].involve=false
            users[ind].user = user
        }

      },

    
    involving(item){ 
      item.involve=!item.involve
      let usersarr = this.getProject().users
      if (!([5,6].includes(this.mod))){
        this.singleadd(item)
      }else{
        if (item.involve){
          usersarr.push({role:{id:this.mod},user:{id:item.id,otgel_id:item.otdel.id, otdel_name:item.otdel.name, fullname:item.fullname}})
          if (this.mod==5){
             let indexuserw = usersarr.findIndex(e=>e.role.id!=5 && e.user.id==item.id)
             if(indexuserw>-1){
                usersarr.splice(indexuserw,1)
             }
          }
        }
        else{
           usersarr = this.usersplicer(item.id, usersarr)      
        } 
      }
      console.log('Запись прошла успешно');
      this.setProjectusers(usersarr)
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

    checkinvolving(data){
      let projectusers = this.getProject().users
      
         projectusers = [5,6].includes(this.mod)? projectusers.filter(e=>e.role.id==this.mod):[projectusers.find(e=>e.role.id==this.mod)]
     

        data.forEach(el => {  
              if (projectusers[0])   {         
              el['involve']= projectusers.findIndex(e=>e.user.id===el.id)==-1?false:true
              }else{
                el['involve']=false
              }}
              
              
              );  
      return data
    },
      openPersonalCards(row, item) {
         this.person= item.item     
        
          this.dialogdetail = true
        },

    build(data){        
        if ('user' in data){          
         this.entries=this.checkinvolving(data.user);    }
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
    async firstload(){
        this.settingsFilt = [{organization:{starttable:"organization", sort:"id"}},
                                    {department:{sort:"id",filters:{department_user__organization: this.getUser().organization.id}}},
              {user:{sort:"sn",filters:{department__id: this.getUser().department.id},select_related:["otdel",'position']}}
              
              
              ]
              let res = await this.getFilters(this.settingsFilt)  
             
              this.build(res.data)
            }


    
     },  
    

  
   
}

</script>

<style lang="scss">
@import "@/utils/colors.scss";
.menus {
  max-height: 300px;
  min-height: 300px;
}
.menus1 {
  max-height: 170px;
  min-height: 170px;
}
.hdsd {
  background: rgb(32, 7, 99);
}

.rightCard {
  .v-window__container {
    flex-grow: 1;
  }

}
.heidialog {
  min-height: 50px;
}

</style>