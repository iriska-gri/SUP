<template>
<v-container class="flex-col h-100 w-100 projects" fluid>
    <v-row class="flex-grow-0">
        <v-col class="pa-0">
                       <!--    -->
                <filters-bar 
                @sendData="updateData"
                @clear="clear"
                class="pa-1 pb-3"
                  
                    :header="pagetitle"
                >
                  <template v-slot:filterslist>
                      <f-input-search
                        
                        :field="'name'"
                        title="Название"
                    ></f-input-search>
                      <f-daterange
                    
                        :field="'datestart__gte'"
                        title="Срок начала с:"
                        
                    ></f-daterange>
                        <f-daterange
                       
                        :field="'datestart__lte'"
                        title="Срок начала до:"
                        
                    ></f-daterange>
                    <f-daterange
                  
                        :field="'dateend__gte'"
                        title="Срок окончания c:"
                        
                    ></f-daterange>
                        <f-daterange
                     
                        :field="'dateend__lte'"
                        title="Срок окончания до:"
                        
                    ></f-daterange>
                      
                  
                     <f-multi-select
                        
                            :title="'Статус'"
                            :field="'work__status'"
                            :disabled="false"
                        ></f-multi-select>
                    <f-input-search
                        
                        :field="'responsible__sn'"
                        title="Фамилия Ответственного"
                    ></f-input-search>


                        
                  </template>
                </filters-bar>
                       
        </v-col>

    </v-row>
    <v-row class="mt-0 ">
        <v-col class="flex-col pa-1">
              <v-card class="flex-grow-1">
           
        <div class="mt-3 iconInline">
        <BtnsOut      
            v-if="pagetitle=='Проекты'"        
            :widthi=140
            :icon = true
            title = "Создать проект"
            
            @click="createproj"
            color="open_icons"
      >
                       
      </BtnsOut>

             
                </div>

    <v-data-table
        :fixed-header="true"
        @dblclick:row="clickRow"
        :disable-pagination="true"
        hide-default-footer
        :headers="!into_project?headers:childHeaders"
        :items="!into_project?parentList:childList"
        class="grow-table"
    >
     <template v-slot:[`item.link`]="{ item }">

        
                <v-icon v-if="!into_project && item.all>0" @click.stop="toChild(item)">mdi-chevron-right</v-icon>
                <v-icon v-else-if="into_project" @click.stop="backParent">mdi-chevron-left</v-icon>
            </template>

             <!-- <template v-slot:[`item.user_project`]="{ item }">
                {{find_rp(item.user_project)}}
            </template> -->
            <template v-if="!into_project" v-slot:[`item.id`]="{ item }">
                {{item.parent.parent.id}}-{{item.parent.id}}-{{item.id}}
            </template>

             <template v-else v-slot:[`item.id`]="{ item }">
                {{projectid}}-{{taskid}}-{{workid}}-{{item.id}}
            </template>
          
            <template v-slot:[`item.dateend`]="{ item }">
                {{timediff(item.dateend) }}
            </template>
            <template v-slot:[`item.lastchanged`]="{ item }">
                {{formatDate(item.lastchanged) }}
            </template>
            <template v-slot:[`item.bars`]="{ item }">
                <div class="d-flex align-center">
                  <template v-if="'completed' in item && item.all>0">
                    <v-progress-linear  style="width: 80%;" :value="item.completed/item.all*100" height="10" buffer-value="100"></v-progress-linear>
                    <div class="ps-2">{{`${item.completed}/${item.all}`}}</div>
                  </template>    
                <div class="mx-auto" v-else><v-icon v-if="item.status__id==5" style="color:green">fa-solid fa-square-check</v-icon></div>





                    <v-menu offset-x left v-if="superuser">
                        <template v-slot:activator="{ on, attrs }">
                           
                            <div v-bind="attrs"
                                v-on="on" 
                                class="ms-2 dots-vertical">
                                <v-icon>mdi-dots-vertical</v-icon>
                            </div>
                        </template>
                        <v-list>
                            <v-list-item><v-list-item-title>Удалить</v-list-item-title></v-list-item>
                        </v-list>
                    </v-menu>
                    <div v-else style="width: 32px;">

                    </div>
                    <div @click.stop="menu" class="ps-2 dots-vertical"></div>
                </div>
            </template>
    
    
    
    
    </v-data-table>
       

        </v-card>

        </v-col>

    </v-row>
</v-container>

</template>
<script>

import moment from "moment"
import { createNamespacedHelpers } from "vuex";
import FiltersBar from '../components/UI/FiltersBar.vue';
import FInputSearch from '../components/UI/FInputSearch.vue';
import {axiosInstance} from '@/utils/api'
const { mapMutations, mapActions } = createNamespacedHelpers("filterslogic");
const globalstore = createNamespacedHelpers("globalstore");
export default {
  components: { FiltersBar, FInputSearch },
    data: () => ({
        model:'',
        search: '',       
        ws: null,
        projectid:null,
        taskid:null,
        workid:null,
        superuser: false,  
        childHeaders:[
            {text: " ", value: "link"},
            {text:"Код",value:"id"},

            {text:"Название", value: "name"},
            {text:"Исполнитель", value:"responsible.sn"},
            {text:"Срок", value: "dateend"},
            {text:"Статус", value: "status.name"},

        ],      
        headers: [
            {text: " ", value: "link"},
            {text:"Код",value:"id"},

            {text:"Название", value: "name"},
            {text:"Ответственный", value:"responsible.sn"},
            {text:"Срок", value: "dateend"},
            {text:"Статус", value: "status.name"},
            {text:"Изменено", value: "lastchanged"},
            {text:"Выполнение", value: "bars"},
        ],
        into_project: false,
        pagetitle:'',      
        menu: false,
        childList:[],

        parentList:[],       
       
    }),

    methods: {   
        ...globalstore.mapMutations(['set_assign_id']),
        ...mapMutations(["setFields"]),
        ...mapActions(["clear", "getFilters", "addFilter", "activefilters"]),
        ...globalstore.mapGetters(["getassign_id"]),
        async createproj(){
            
            let res = await axiosInstance.post('/createproj')
            console.log(res);
            this.$router.push(`/project/${res.data.id}`)
        },
   

        timediff(dateend) {
            return moment(dateend).isValid()? moment(dateend).locale('ru').fromNow(): 'Не установлен'
        },
        formatDate(date) {
            return (date && moment(date).isValid())? moment(date).format("DD.MM.YYYY"): '' 
        },

        
        
        build(data) {
            
            if (!this.into_project){
            if (data.payload.length>0){    
            data.payload.forEach(el => {

                el["completed"]= el.work_assignment.filter(el=>el.status.id==5).length
                el["all"]=el.work_assignment.length
                
            });    
            this.parentList= data.payload
            }
            else{
                this.parentList=[]
            }
            
            }
            else{
                this.childList = data.child
            }
           
            
        },
        async updateData(){
            let payload=await this.activefilters()
            for (let key of Object.keys(payload))
         {
             if ( ['work__status__in'].includes(key))  {
             let arr=[]             
             payload[key].forEach(el => {arr.push(el.id)
                
             });
             payload['status__in']=arr
             delete payload[key]
             }

         }
            this.ws.send({"action": "getfilter", payload})
        //    console.log(await this.activefilters());
        },
      
        find_rp(arr){            
            const rp = arr.find(el=>el.role.id==2)
            return rp==undefined?"Не назначен": rp.user.sn
        },



        update(){
            console.log(`UPDATE`)

                },
        titler(itname=""){            
            if(this.$route.path=="/projects")             {
             this.pagetitle= !this.into_project?"Проекты":`${itname}: Задачи`
            }else if(this.$route.path=="/tasks"){
             this.pagetitle= !this.into_project?"Задачи":`${itname}: Работы`
            }
            else if(this.$route.path=="/works"){
             this.pagetitle= !this.into_project?"Работы":`${itname}: Поручения`
            
            }else{

                this.pagetitle="Поручения"
            }
        },
      
        toChild(item) {
            [this.projectid,this.taskid,this.workid]=[item.parent.parent.id,item.parent.id,item.id]
            this.into_project = true;
            
            this.titler(item.name)    
            this.childList=item.work_assignment
            // this.ws.conn.send(JSON.stringify({"action": "getchild","parent__type":this.$route.path.slice(1), "parent__id": item.id}))
        },

        backParent() {
            this.into_project = false;
            this.titler()
         
        },
        clickRow(e, row)  {
            let path = this.$route.path
            let pusher={
                '/projects':[{name:"Task",'col':'id'},{name:"Project",'col':'id'} ],
                '/tasks':[{name:"Work",'col':'id'},{name:"Task",'col':'id'}],
                 '/works':[{name:"Work",'col':'parent'},{name:"Work",'col':'id'}],
                '/assignments':[{name:"Work",'col':'parent'},{name:"Work",'col':'parent'}]
            }           
            
            let ind = this.into_project? 0:1       
            // console.log("ssss",{ name: pusher[path][ind].name, params: { tid:row.item[pusher[path][ind].col]}}); 
            console.log("новый роут-----",row.item )
            let params = { id:row.item[pusher[path][ind].col]}
           
            if(ind==1){

                this.$router.push({path:`/project/${row.item.parent.parent.id}/task/${row.item.parent.id}/work/${row.item.id}`})
            }

            else if(ind==0 ){
                this.$router.push({path:`/project/${this.projectid}/task/${this.taskid}/work/${row.item.id}`})
            }
           
               
            
            
        },
        wsconnect(){
            this.ws = new this.$pws()               
            this.ws.start(`/reestr${this.$route.path}`);
            this.ws.addEvent('onmessage', (event) => {
            const data = JSON.parse(event.data); 
            console.log(data, "dataonmess");
            try{                  
            this[data.action](data);
            }catch(e){
                console.log(e)
            }
        }
        )
        }
    },
     watch:{
    $route(to, from){
    this.ws.stop()
    this.into_project=false
    this.childList=[]
    this.parentList=[]
    this.titler()
    this.wsconnect()
    
  }
},

  
  
    mounted() {
        
        this.superuser = this.$store.getters['auth/getSuperUser']
        this.setFields({ 
           work__status: { module: "mult" },
        //    role:{module:"mult"}
          
        });

        this.getFilters([
            
            {work__status:{name:"work__status", sort:"id", related_name: "name"}}], true).then(async (data) => {console.log(data,"data")})
        
        this.wsconnect()
        this.titler()
        
    },
    destroyed() {
        this.ws.stop()
    }
}
</script>
<style lang="scss" scoped>
    @import "@/utils/colors.scss";
    
    .main-projects {
        color: $color-main;
    }

    

</style>
<style lang="scss">
    @import "@/utils/colors.scss";
    
        h4 {
            color: $bg-purple;
  
        }
    
    .task-table tbody tr:first-child td {

        color: $color-main;
    }

    tbody {
        cursor: pointer;
    }

    .main-projects .theme--light.v-data-table > .v-data-table__wrapper > table > thead > tr > th {
        font-weight: 600;
    
        color: $color-main;
    }

    .main-projects .theme--light.v-data-table > .v-data-table__wrapper > table tr .dots-vertical i {
        opacity: 0;
    }

    .main-projects .theme--light.v-data-table > .v-data-table__wrapper > table tr:hover .dots-vertical i {
        opacity: 1;
    }

    .grow-table {
        display: flex;
        flex-direction: column;
        overflow-y: auto;
            }

    .iconInline {
        position: absolute;
        z-index: 3;
        left: 1%;
        top: 93%
        
        
    }
</style>