<template>
  <work-task-ass-project
    
    :cards="$options.name"
    :chatview="chatview"
    :show="show"
    @afterLeave="afterLeave"
    @afterEnter="afterEnter"
    @createnewWork="createnewWork"
    @allCard="allCard"
    :title="'Задача ' + gettasks.name"
    :breadcrumbs="breadcrumbs"
  >
    <template #spisok>


      <left-list
        :level="2" 
        
        @confirmation="confirmation"
        @rout="rout"
      />
      <v-row class="flex-grow-0 ">
        <v-col class="pa-0">
          <v-divider></v-divider>
        </v-col>
      </v-row>
      <v-row class="flex-grow-0 justify-end">
        <v-col class="flex-grow-0">
            <MyIco
            @click="gantviewer"
            size="large"
            icons = 'mdi-chart-gantt'
          />  
        </v-col>
      </v-row>
      <v-slide-x-reverse-transition>
        <v-card
          v-show="gantview"
          class="gantPosition"
        >        
          <gant-task
            :startlevel="'task'"
            ref="ganttask"
            @saver = "addTask"  
            @changegantview="changegantview"    
          />
        </v-card>
      </v-slide-x-reverse-transition> 
    </template>
    <template #informations>
      <informationorders
        :chat="activedCh"
        :chatview="chatview"      
        :indx="0"
        :level="2"      
        @chatviewer="chatviewer" 
        @createtabchat="createtabchat"
        @changestatus="changestatus"
        @confirmation="confirmation"
        :breadcrumbs="breadcrumbs"
      />  
    </template>
    <template #chat>
      <mMessegeListRight
        class="box2" v-show="Object.keys(activedCh).length>0"
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
        :files="task.task_files"
        :level="2"
        :status="task.status.id"
        :currentid="task.id"
        @uploadfile="uploadfile"
        @deletefile="deletefile"
        @VisSwitcher="VisSwitcher"
      />                
    </template>
    <template #graphic>
      <work-pie-chart
        :title="'Статусы работ в задаче'"
        :data="task_statuses_calc"
      />
    </template>   
  </work-task-ass-project>
</template>

<script>
import { bus } from "@/main";
import Cards from '@/components/UI/Cards.vue'
import GantTask from '@/components/visual/GantTask.vue'
import {axiosInstance} from '@/utils/api'
import { createNamespacedHelpers } from "vuex";
import uf from '@/utils/universal_functions'
import wtasp from '@/utils/wtasp' //Содержит функции для Project, Task, Work
import filelist from '@/components/carddetails/files/filelist.vue';
import informationorders from '../components/assignments/informationorders.vue';
import mMessegeListRight from '@/components/supogramm/mess_layouts/m-messege-list-right.vue';
import workPieChart from '@/components/UI/GRAPHICS/workPieChart.vue';
import WorkTaskAssProject from './pattern/work-task-ass-project.vue';
import LeftList from '@/components/carddetails/pattern/leftList.vue';
const assignmentstate = createNamespacedHelpers("assignmentstate");
const projectstate = createNamespacedHelpers("projectstate");
const taskstate = createNamespacedHelpers("taskstate");
const workstate = createNamespacedHelpers("workstate");

export default {

    name:"task",

    mixins:[uf, wtasp],

    components:{
        Cards,        
        GantTask, 
        filelist,
        informationorders,
        mMessegeListRight,
        workPieChart,
        WorkTaskAssProject,
        LeftList
    },

    data(){
      return{
        waiter:false,
        activedCh: {},
        gantview:false,
        chatview:true,
        project:{
          name:"",
          status:{id:0,name:""},
          task:{name:"",datestart:"",dateend:"", responsible:{id:""}},
          users:[{role: {id: 0}, user:{id: 0}}]
        },
        breadcrumbs:[{href:'',disabled:true,text:""}],
        task:{name:"",task_work:[],datestart:"",dateend:"",responsible:{id:""},status:{id:0,name:""},description:""},
        show:true,
        level:2,
        workaccepted:0,
        executed: 0

    }},

    async mounted() {
      this.ws = new this.$pws()
      this.ws.start(this.$route.fullPath);
      this.ws.addEvent('onmessage', (event) => {
      const data = JSON.parse(event.data);
      console.log(data, 'data');
        if ("action" in data) {
          try{
            this[data.action](data.payload)
          }
          catch(e)
          {
            console.log(e)
          }
          }
        else{console.log(data)} 
        })
    },

    computed:{
      ...workstate.mapGetters(['getworks']),
      ...taskstate.mapGetters(['gettasks']),
      ...assignmentstate.mapGetters(['getAssignments']),
      ...projectstate.mapGetters(["getProject","getprojectuniqueusers"]),

      task_statuses_calc(){
          return this.pie_statuses_calc(this.task.task_work)
      },

      // projectPopoject(){
        
      //   // let {name: nameup, dateend: dateendup, datestart: datestartup, users: usersup}={...this.project}
      //   // let {name, dateend, datestart, responsible, status, description, comment}={...this.task}
      //   this.project.responsible = this.project.users.find(e=>e.role.id==2).user
      //   console.log({...this.task,parent:this.project, type:'Проект:', role: 'Руководитель проекта:'},"GHJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ")
      //   return {...this.task,parent:this.project, type:'Проект:', role: 'Руководитель проекта:'}
      // },  

    },

    methods:{    
      ...taskstate.mapMutations(["settasks"]),   
      ...projectstate.mapMutations(["setProject", "clearProject"]),
    renew(payload){
            this.ws.stop()
                console.log("aaaaad")
                this.ws.start(this.$route.fullPath);
        
        
            
        },
      

       changestatus(chang){   
      let action = "taskstatus"  
      let payload = {
        id: chang.val.id,
        status: chang.action,
        comment: chang.comment,
        h_action:chang.h_action
      }
      
      // let check = this.getProject
      
       
      // payload['project_status_update'] = check.status.id ==3?true:false
      // payload['task_status_update']= this.task.status.id < 2 ?true:false
      
      // if (this.tab>0){
        // payload['work_status_update']= this.work.status.id < 2 ? true:false 
        // action = "assignmentstatus"
      // }
        this.ws.send({action,payload})
    },




      changegantview(){
        this.gantview=false
      },

        fileupdated(payload){            
            let ind = this.task.task_files.findIndex(el=>el.id==payload.id)        
             this.task.task_files[ind].visible=payload.visible.split("")
         
         
        },
         newmessageincome(payload){               
                this.activedCh.lastmessage.push(payload)
                
                this.$refs.mychat.scrollbottom(payload.id)
            },

      rout(val) {
        this.$router.push({ path: `${this.$route.fullPath}/work/${val}` })
      },
       async uploadfile(formData){
            let fileinfo = {project:this.getProject.id, task:this.task.id, visible: '0100'}
           
          //   // Тут же заделаем потом на другие уровни - задачи и проекты
            formData.append('info', JSON.stringify(fileinfo))
           
            let res = await axiosInstance.post( `/main/uploader`, formData,{
                                        headers: {
                                            "Content-Type": "multipart/form-data",
                                        },
                            })
            if ("created" in res.data){
                this.ws.send({"action":"fileuploaded","payload":this.task.id})
            }

       },
         filerenew(payload){
        
            payload.forEach((el,index)=> payload[index].visible = el.visible.split("") )
            this.task.task_files = payload

         },

    
      build(data){
        console.log("BUILD" ,data);
        data.task.task_files.forEach((el,index)=> data.task.task_files[index].visible =el.visible.split("") )
        
        this.project = data.project
        this.task = data.task
        console.log('this.project',this.project);
        console.log('this.task',this.task);

        this.setProject(this.project)
         this.breadcrumbs=[
                          { text: this.getProject.name, disabled: false, href: `/project/${this.getProject.id}` },                               
                        ]
        let wc = 0
        this.executed = data.task.task_work.filter(el=>el.status.id==5).length
        console.log(this.executed, 'this.executed');
        data.task.task_work.forEach(el=> {if(el.status.id==5) wc+=1} )
        this.workaccepted=wc/data.task.task_work.length*100        
        this.settasks(data.task)

        if("datachat" in data){
          this.activedCh = data.datachat
          this.chatview = "id" in this.activedCh
          this.$refs.mychat.scrollbottom(this.activedCh.lastmessage[this.activedCh.lastmessage.length-1].id)
        }

       
      },



               messagedeleted(payload){
                try{
               
                // console.log(this.mychats[ind].lastmessage)
                let ind2=this.activedCh.lastmessage.findIndex(e=>e.id==payload.id)
                this.activedCh.lastmessage.splice(ind2,1)
                console.log(this.activedCh.lastmessage, "slice");}
                catch{
               
                }
                
                } ,

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
      afterEnter(){
        console.log("@after-enter=")
      },

      afterLeave(){   
        console.log(`afterLeave`);     
        this.tab=this.nedotab
        this.currentid = this.tab==0?this.work.id:this.work.work_assignment[this.tab-1].id
        this.activeChat()
        this.show=true
      },
                
      VisSwitcher(file){     
        console.log("VisSwitcher", file)
        this.ws.send({"action":"updateFile","payload":{id:file.id,visible: file.visible.join("")}})
      },

      rebuild(){
        this.ws.send({"action":"rebuild","payload": this.task.id})
      },
      filedeleted(payload){     
        console.log("pl");
        let ind = this.task.task_files.findIndex(el=>el.id==payload.id)
       this.task.task_files.splice(ind,1)
      },
      chatviewer(){
        this.chatview=!this.chatview
      },
        
      createtabchat(){
        let name = this.task.name
        let level = 2
        let parent = this.task.id
        let users = new Set()
        this.task.task_work.forEach(e=> users.add(e.responsible.id))
        users.add(this.task.responsible.id)
        bus.$emit("supogrammchatcreate",{users:Array.from(users),name, level,parent})   
      },

      async uploadfile(formData){
        let fileinfo = {project:this.getProject.id, task:this.task.id, visible: '0100'}
        // Тут же заделаем потом на другие уровни - задачи и проекты
        formData.append('info', JSON.stringify(fileinfo))
        let res = await axiosInstance.post( `/main/uploader`, formData,{
          headers: {
              "Content-Type": "multipart/form-data",
          },
        })
          if ("created" in res.data){
            this.ws.send({"action":"fileuploaded","payload":this.task.id})
          }
      },

        createnewWork(){
          this.$refs.ganttask.createnewTask()
        },

        gantviewer(){
          this.gantview=!this.gantview
          if (this.gantview) this.$refs.ganttask.rebuild()
        },
      
        addTask(val){          
            console.log(val);
            delete val.val.history
            this.ws.send({"action":val.am.method,"payload":val.val})
        },

        confirmation(payload){
          this.task.task_work.forEach(el=> {
            el.menu=false 
            el.action_confirm=false
          })
          payload['task_status_update'] = this.task.task_work.every(el=>{
            if(el.id==payload.id && payload.status==5){return true}
            else if(el.status.id==5){return true}
            return false
          })?
          {"res":true}:{'res':false}
          this.ws.send({"action":"confirmation","payload":payload})
        },




        },
            beforeDestroy() {
      this.clearProject()
    }

}
</script>

<style lang="scss">

.v-window, .v-window__container {
  display: flex;
  flex-grow: 1;
  flex-direction: column;
}

.theme--light .v-tabs-items {
  background-color: transparent;
}

.v-window-item {
  display: flex;
  flex-grow: 1;
  flex-direction: column;
}

</style>