
<template>

 
  <work-task-ass-project
   
    :cards="$options.name"
    :tabProj="tabProj"
    :chatview="chatview"
   
    :message="message"   
    @listchangetab="tab='0'"
    @createnewTask="createnewTask"
    @allCard="allCard"
    :title="'Проект ' + project.name"
    @comm="comm"
  >
    <template #spisok>
      <left-list       
        :level="1"       
        @confirmation="confirmation"
        @rout="rout"
        @showuserinfo="showuserinfo"
      />
        <!-- <v-row class="flex-grow-0">
          <v-col class="pa-0">
            <v-divider/>
          </v-col>
        </v-row> -->
        <!-- <v-row class="flex-grow-0">
          <v-col class="k text-end flex-col pa-0"> -->
            <v-tabs 
              @change="changetabProject"
              class="flex-grow-0"
              v-model="tabProj"
            >
              <v-tab
                href="#1"
                class="pa-0 tabproject"
              >
                <MyIco
                  icons = 'mdi-home-map-marker'
                  size="large"
                />  
              </v-tab>
              <v-tab href="#2" class="pa-0 tabproject">
                <MyIco
                  icons = 'mdi-wallet-travel'
                  size="large"
                />  
                </v-tab>
                <!-- <v-tab href="#3" class="pa-0 tabproject">
                  <MyIco
                    icons = 'mdi-timetable '
                    size="large"
                  />  
                </v-tab> -->
                <v-col class="flex-grow-0">
                  <MyIco
                    @click="gantviewer"
                    size="large"
                    icons = 'mdi-chart-gantt'
                  />  
                </v-col>
            </v-tabs>
          <!-- </v-col>   
        </v-row> -->
        <v-slide-x-reverse-transition>
          <v-card
            v-show="gantview"
            class="gantPosition"
          >        
            <Gant
              ref="gantproject"
              :tasksOR='project.task'
              @saver = "addTask"
              @changegantview="gantview=false"
            />
          </v-card>
        </v-slide-x-reverse-transition> 
    </template>

    <template #informations>
      <project-informationorder
        
        :chat="activedCh"
        :chatview="chatview"                                
        ref="pifo"                        
        @saveproject="saveproject"
        @switch_mode="switch_mode"
        @chatviewer="chatviewer" 
        @createtabchat="createtabchat"
        @changestatus="changestatus"
      />  
      
        <div>
          <v-dialog
            v-model="show_change_dialog"
            width="75vw"
          >
            <project-stepper-pattern
              @closes="show_change_dialog=!show_change_dialog"
              @newproject='newproject'
              @showuserinfo='showuserinfo'
            />
          </v-dialog>
        </div>
    </template>
    
    <template #projdocs>
      <ProjectDocks
        ref="projectdoc"
        :documents="documents"
        @savedock="savedock"
      />
    </template>
    
    <template #chat>
      <mMessegeListRight
        class="box2" 
        ref="mychat"
        :chatplace="'rightchat'"
        :header= false
        :chat="activedCh"
        :waiter="waiter"
        @waiting="waiter=true"
      />  
    </template>
                                 
    <template #filess>    

      <filelist
        :statid="statid"
        :files="project.project_files"
        :level="1"
        :status="project.status.id"
        :currentid="project.id"
        @uploadfile="uploadfile"
        @deletefile="deletefile"
        @VisSwitcher="VisSwitcher"
      />                
      </template>

      <template #graphic>

          <work-pie-chart
            :title="'Статусы задач в проекте'"
            :data="task_statuses_calc"
          />
      </template>
    
  </work-task-ass-project>

  
</template>


<script>
import LeftList from '@/components/carddetails/pattern/leftList.vue';
import { bus } from "@/main";
import ProjectDocks from '@/components/projects/ProjectDocks.vue'
import Gant from '@/components/visual/Gant.vue'
import SelectUserMenu from '@/components/UI/SelectUserMenu.vue'
import ColText from '@/components/projects/ColText.vue'
import WorkTaskAssProject from './pattern/work-task-ass-project.vue';
import workPieChart from '@/components/UI/GRAPHICS/workPieChart.vue';
import CardsButtons from '@/components/projects/CardsButtons.vue'
import filelist from '@/components/carddetails/files/filelist.vue';
import projectInformationorder from '../components/assignments/project-informationorder.vue';
import uf from '@/utils/universal_functions'
import wtasp from '@/utils/wtasp' //Содержит функции для Project, Task, Work
import Datepiker from '@/components/UI/Datepiker.vue'
import projectStepperPattern from  '@/components/UI/projectsteppersteps/projectStepperPattern.vue';
// import chat from '@/components/chats/chat.vue'

import Postpone from '@/components/dialog/fill/postpone.vue';
import {axiosInstance} from '@/utils/api'
import { createNamespacedHelpers } from "vuex";
const projectstate = createNamespacedHelpers("projectstate");
const taskstate = createNamespacedHelpers("taskstate");
const workstate = createNamespacedHelpers("workstate");
const globalstore=createNamespacedHelpers("globalstore");
const auth = createNamespacedHelpers('auth')
const { mapMutations, mapActions } = createNamespacedHelpers("filterslogic");
// import getFilters from '@/utils/filterutil'
import moment from "moment";
  import mMessegeListRight from '@/components/supogramm/mess_layouts/m-messege-list-right.vue';

export default {
  name: "project",
  mixins:[ uf, wtasp],
    components: {  
       LeftList,
      ProjectDocks, 
      Gant,     
      SelectUserMenu,
      ColText,
      CardsButtons,
      workPieChart,
      filelist,
      history,
      projectInformationorder,
      Datepiker,
      mMessegeListRight,
        WorkTaskAssProject,
        Postpone,
        // ProjectStepper
      projectStepperPattern

       
       
    },
    
    data: () => ({
      show_change_dialog:false,
      statid: [1, 3, 4, 5, 6],
      message: {mes:"", show: false},
      comment:"",
      tabProj: null,
      
              
        tasksaccepted:0,
        gantview:false,
        show:false,
        
        
        menu:null,
         waiter:false,
     
        chatview:true,
        task:{name:"",datestart:"",dateend:"",responsible:{id:""},status:{id:0,name:"",description:""}},
        activedCh: {},
        ws: null,
        
        documents:[],
        project:{
          id:0,
          name: "",          
       
          status: {
            id: 1,
           
          },
         
         
          users: [  ],      
          
          ptype: {
            id: 0
          },
          datestart:'',
       
          tasks: [],
          author: {
            id: 0
          },
         
},        
          selectdatafields:{},
          selectfields:{project__type:{name:"Тип",basefield:'ptype'},
                        project__status:{name:"Статус",basefield:'status'}},
       


         

          
          userFields: [
                    {text: 'Директор', icons: 'mdi-account-plus', model: 'director',modelrole:1},
                    {text: 'Руководитель', icons: 'mdi-account-plus', model: 'rp',modelrole:2},
                    {text: 'Секретарь', icons: 'mdi-account-plus', model: 'secretary',modelrole:3},
                    {text: 'Координатор', icons: 'mdi-account-plus', model: 'coordinator',modelrole:4},
          ],

        
                  
          chalenge: {'ИСУП': [{name: 'Карточка задания'}, 
                  
                  {name: 'Всплывающее окно'},
                  {name: 'Все дер'}],
                  'УКД': [{name: 'Статистика по пользователем'}] } 
          
    }),

    computed:{
      ...projectstate.mapGetters(["getProject","getProjectwatchers","getProjectusers"]),
      ...auth.mapGetters(["getUser"]),
        history(){
        return this.getProject.history
              
      },
        checkRP() {
            let obl = false
            this.projectPopoject.users.filter(e=> {
              
              if ([2].includes(e.role.id) && e.user.id == this.getUser.id) {
                console.log(e, '---------');
                obl = true
              }})
            return obl
          },

  

      task_statuses_calc(){
          return this.pie_statuses_calc(this.project.tasks)
        },

      projectPopoject(){
        let {name, dateend, datestart, status, description, comment, users}={...this.project}
        return {name, dateend, datestart, status, description, comment, users, type:'Проект:', role: 'Руководитель проекта:'}
      },          
    
    },
    methods: {
      ...projectstate.mapMutations(["setProject","setProjectusers", "clearProject"]),
       ...mapActions(["getFilters"]),
       ...mapMutations(["setFields"]),
      ...taskstate.mapGetters(["gettasks"]),
       ...workstate.mapGetters(["getworks"]),
      ...globalstore.mapGetters(["getLoad"]),
      ...globalstore.mapMutations(["setLoad"]),
     

    newproject(val) {
      console.log('nude', val);
      this.ws.send({"action":"update","payload":val})
      this.show_change_dialog= false
    },
    rout(val) {
        this.$router.push({ path: `${this.$route.fullPath}/task/${val}` })
      },


      comm(val){
      this.comment =val
    },

    showuserinfo(id){
      this.$refs.pifo.showuserinfo(id)
    },

    idtonewdock(payload){
      
      
      this.$refs.projectdoc.idtonewdock(payload)
      
    },

 
     filerenew(payload){
        
            payload.forEach((el,index)=> payload[index].visible = el.visible.split("") )
            this.project.project_files = payload

         },


takeprev(payload){
               
                // let ind = this.mychats.findIndex(el=>el.id==payload.chat)   
                
                if  (this.activedCh.lastmessage.length<20){
                    this.activedCh.lastmessage=payload.res
                    this.activedCh.lastmessage=this.activedCh.lastmessage
                }
                else{
                this.activedCh.lastmessage = payload.res.concat(this.activedCh.lastmessage)
                 }
            

                this.waiter=false


    },
 messagedeleted(payload){
                try{               
                let ind2=this.activedCh.lastmessage.findIndex(e=>e.id==payload.id)
                this.activedCh.lastmessage.splice(ind2,1)
                }
                catch{
               
                }
                
                } ,
filedeleted(payload){                
                
            let ind = this.project.project_files.findIndex(el=>el.id==payload.id)
            this.project.project_files.splice(ind,1)
            
        },
   
    createnewTask(){
     
      this.$refs.gantproject.createnewTask()
    },

      savedock(val){
        console.log("PROJECT_SAVEDOCK",val);
       
        this.ws.send({"action":val[0],"payload":val[1]})
 },
     

        
     
     
      VisSwitcher(file){      
       
        this.ws.send({"action":"updateFile","payload":{id:file.id,visible: file.visible.join("")}})
     
           },

      rebuild(){        

          this.ws.send({"action":"rebuild","payload": this.project.id})
        },


    chatviewer(){    
      this.chatview=!this.chatview
    },

     createtabchat(){
    let name = this.getProject.name
    let level = 1
    let parent =this.getProject.id
    let users = new Set()
    this.getProject.users.forEach((e)=>  {if(e.role.id<5) users.add(e.user.id)})
      
   
   this.chatview=true
    bus.$emit("supogrammchatcreate",{users:Array.from(users),name, level,parent})   

  },

          async uploadfile(formData){
            let fileinfo = {project:this.getProject.id, visible: '1000'}
          
          //   // Тут же заделаем потом на другие уровни - задачи и проекты
            formData.append('info', JSON.stringify(fileinfo))
           
            let res = await axiosInstance.post( `/main/uploader`, formData,{
                                        headers: {
                                            "Content-Type": "multipart/form-data",
                                        },
                            })
            if ("created" in res.data){
                this.ws.send({"action":"fileuploaded","payload":this.getProject.id})
            }
        },


      changetabProject(value){
        if (value=="2"){
          this.ws.send({"action":'getprojectdocks',"payload":""})
        }
        
      },
      
      addTask(val){       
        console.log(val,"!!!!!!!!!!!!!!!!!!!!!!!!!");
        delete val.val.history
        this.ws.send({"action":val.am.method,"payload":val.val})
        // this.ws.send({"action":val.method,"payload":this[`get${val.level}`]()})
      },
   

      clickRow(e,row){
      
        this.$router.push(`${this.$route.path}/task/${row.item.id}`)
      },
      build(data){  
   
         data.project_files.forEach((el,index)=> data.project_files[index].visible =el.visible.split("") )    
         this.project=data;   
         console.log(this.project, 'this.project _2load');     
          this.setProject(this.project)

          this.tasksaccepted=this.getProject.tasks.filter(el=>el.status.id==5).length*100/this.getProject.tasks.length
          
          this.setLoad(false)
          // if (this.gantview) this.$refs.gantproject.rebuild()
        if("datachat" in data){
          this.activedCh = data.datachat
          this.chatview = "id" in this.activedCh
          this.$refs.mychat.scrollbottom(this.activedCh.lastmessage[this.activedCh.lastmessage.length-1].id)
        }
          
      },
    

      deluser(id, mod){        
        let users = this.getProject.users      
        let ind = users.findIndex(e=>(e.user.id==id && e.role.id ==mod))        
        users.splice(ind,1)       
        this.setProjectusers(users)
      },
     
        
                 newmessageincome(payload){               
                this.activedCh.lastmessage.push(payload)
                
                this.$refs.mychat.scrollbottom(payload.id)
            },

        saveproject() {
          console.log(this.getProject, 'сюда');
          this.ws.send({"action":"update","payload":this.getProject})
        },

      changestatus(chang){   
  
      let action = "workstatus"  
  
      let payload = {
        id: chang.val.id,
        status: chang.action,
        
      }
      
      let check = this.getProject
      
       
      payload['project_status_update'] = check.status.id ==3?true:false
      payload['task_status_update']= this.task.status.id < 2 ?true:false
      
      if (this.tab>0){
        payload['work_status_update']= this.work.status.id < 2 ? true:false 
        action = "assignmentstatus"
      }
        this.ws.send({action,payload})
    },

        switch_mode() {
          this.show_change_dialog=!this.show_change_dialog
        },

        async createtask(){            
            let res = await axiosInstance.get(`/createtask/?parent=${this.project.id}`)
           
            this.$router.push(`/task/${res.data.id}`)
        },
        buildDocspage(data){
          this.documents = data
          
        },
        closeDocdialog(data){
          this.$refs.projectdoc.dialog=false
        },
        async opendoc(data){
            console.log("JOOOOOOOOOOO");
            await this.$refs.projectdoc.copyrunview(data);
        },
          gantviewer(){
      this.gantview=!this.gantview
      if (this.gantview) this.$refs.gantproject.rebuild()
    },


       confirmation(payload){ 
      
         
          // let n = this.project.tasks.findIndex(el=>el.id==payload.id)

          this.project.tasks.forEach(el=> {
                                                  // console.log(el, "wttf")
                                                  el.menu=false 
                                                  el.action_confirm=false})
          // payload['task_status_update'] = this.project.tasks[n].task_work.every(el=>{ if(el.id==work.elm.id && work.res==5){return true}
          //                                                                       else if(el.status.id==5){return true}
                                
          //                       return false
        
          //                                                                     })
                                                                              // ?
                                                                              // {"res":true}:{'res':false}
          this.ws.send({"action":"confirmation","payload":payload})

          this.comment=""
          this.comment_up=""
        },
    },

    beforeDestroy(){
        console.log("destroy");
        this.clearProject()
        this.ws.stop()
    },
   


     mounted() {
        this.setLoad(true)
         this.setFields({role:{module:"mult"},project__type: { module: "mult" } });     

        this.getFilters([{"project__type": { "sort": "id", "filters":{},"exclude":["projects"]}},
                          {role:{name:"role",sort:"id"}}
        ])
     
        
        this.ws = new this.$pws()
        this.ws.start(this.$route.fullPath);
        this.ws.addEvent('onmessage', (event) => {
            const data = JSON.parse(event.data);
            console.log(data,"все данные");
            if ("mess" in data){
                console.log(data.mess + " - сообщение")
                this.message.mes=data.mess
                this.message.show=true
            }
            if ("action" in data) {
              try{
              this[data.action](data.payload)}
              catch(e){
                console.log(e)
              }
            }
           
            
           
        })
  
    },

        
      
      
}
</script>

<style lang="scss">
@import "@/utils/colors.scss";

.alerts {
  position: absolute;
margin-left: auto;
margin-right: auto;
bottom: 5%;
left: 0;
right: 0;
text-align: center;
z-index: 2;
max-width: 20%;
}


.project_css .v-window-item--active,.project_css  .v-window__container, .project_css .v-window {
  flex-grow: 1;
  display: flex !important;
  flex-direction: column;
}

.v-menu__content {
    box-shadow: 0px 5px 5px -3px rgb(0 0 0 / 0%), 0px 8px 10px 1px rgb(0 0 0 / 0%), 0px 3px 14px 2px rgb(0 0 0 / 10%);
    border-radius: 2px;
}

.inputext {
  font-size: 0.9rem;
}



.grow-table {

  overflow-y: scroll;
  .v-list-group :nth-child(1) {
  color:  var(--v-inyand2-base)!important;
  font-size: 0.8rem;
  // background: var(--v-scrollbar-base)!important;
}
}
 

.inputext {
  font-size: 0.9rem;
  color: black;
}

.chat {
  min-height: 25%;
}

.iconsh 
  .v-icon.v-icon {
    font-size: 14px!important;
}

.v-tab-item >>> .v-window__container {
  flex-grow: 1 !important;

}



.v-input__append-inner{
  cursor: pointer;
}

@media (min-width: 1904px) {
   .maxHi {
height: 0px;
}
}

@media (min-width: 1264px) and (max-width: 1904px) {
   .maxHi {
   height: 100px;
}

}

.v-window, .v-window__container {
  display: flex;
  flex-grow: 1;
  flex-direction: column;

}

.theme--light .v-tabs-items, .theme--dark .v-tabs-items {
  background-color: transparent!important;
}

.v-window-item {
    display: flex;
  flex-grow: 1;
  flex-direction: column;
}

.tabproject { 
  min-width: 47px;
}


</style>