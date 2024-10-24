<template>
  <work-task-ass-project
   
    :cards="$options.name"
    :chatview="chatview"
    :show="show"
    :tabProj="'1'"
    @afterLeave="afterLeave"
    @afterEnter="afterEnter"
    @createnewass="createnewass"
    :title="work.name"
    @listchangetab="listchangetab"
    :breadcrumbs="breadcrumbs"
    @allCard="allCard"
  >
    <template #spisok>
      <left-list       
        :level="3"       
        @listchangetab="listchangetab"
        @confirmation="confirmation"
      />
       <!-- :cardname="$options.name"
        :status="work.status.id"
        :itemList="work.work_assignment" -->
      <v-row class="flex-grow-0 ">
        <v-col class="pa-0">
          <v-divider/>
        </v-col>
      </v-row>
      <v-row class="flex-grow-0 justify-end">
        <v-col class="flex-grow-0">
          <MyIco
            @click="gantviewer"
            icons = 'mdi-chart-gantt'
            size="large"
          />  
        </v-col>
                <v-col class="flex-grow-0">
          <!-- <MyIco
            @click="hello"
            icons = 'mdi-chart-gantt'
          />   -->
        </v-col>
      </v-row>
      <v-slide-x-reverse-transition>
        <v-card
          v-show="gantview"
          class="gantPosition"
        >        
          <gant-work
            class="pa-1"
            :startlevel="'work'"
            ref="gantwork"
            @saver="gantsaver" 
            @changetab="changetab"  
            @changegantview="changegantview"
          />
        </v-card>
      </v-slide-x-reverse-transition>
    </template>

    <template #informations>
       <informationorders
          :chat="activedCh"
          :chatview="chatview"         
          :indx="tab"
          :level="tab==0?3:4"
       
          @changetab="changetab"
          @chatviewer="chatviewer" 
          @createtabchat="createtabchat"
          @changestatus="changestatus"
          @listchangetab="listchangetab"
          :breadcrumbs="breadcrumbs"
        />     
    </template>
             <!-- :levelup="task"
          :level="fullinfo[tab]" -->
<!-- :chat="activedCh"
          :chatview="chatview"
          :val="fullinfo[tab]"
          :task="task"
          
          :workaccepted="workaccepted"
          @changestatus="changestatus"
          @createtabchat="createtabchat"
          @chatviewer="chatviewer" -->
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
          :files="work.work_files"
          :level="level"
          :status="work.status.id"
          :currentid="[work,...work.work_assignment][tab].id"
          @uploadfile="uploadfile"
          @deletefile="deletefile"
          @VisSwitcher="VisSwitcher"
        />
        </template>

        <template #graphic>
          <work-pie-chart
            :title="'Статусы поручений в работе'"
            :data="ass_statuses_calc"
          />

          
        </template>
            <v-dialog
      overlay-opacity= ".1"
      v-model="delete_dialog"
      max-width="490px"
    >
      <DialogNewAssigment
        text="Удалить поручение"
      >
        <template #textarea>
          <delAssigment/>
        </template>
        <template #btn1>
          <v-btn
            color="green darken-1"
            text
            @click="delete_dialog = false"
          >
            Отменить
          </v-btn>
        </template>
        <template #btn2>
          <v-btn
            color="green darken-1"
            text
            @click="assignment_del_run"
          >
            Удалить
          </v-btn>
        </template>
      </DialogNewAssigment>
    </v-dialog>
</work-task-ass-project>

</template>

<script>
import GantWork from '@/components/visual/GantWork.vue'
import moment from "moment";
import { createNamespacedHelpers } from "vuex";
import {axiosInstance} from '@/utils/api'
import informationorders from '@/components/assignments/informationorders.vue';
import filelist from '@/components/carddetails/files/filelist.vue';
import assignment from '@/components/assignments/assignment.vue';
import { bus } from "@/main";
import mMessegeListRight from '@/components/supogramm/mess_layouts/m-messege-list-right.vue';
import uf from '@/utils/universal_functions'
const globalstore = createNamespacedHelpers("globalstore");
const assignmentstate = createNamespacedHelpers("assignmentstate");
const projectstate = createNamespacedHelpers("projectstate");
const taskstate = createNamespacedHelpers("taskstate");
const workstate = createNamespacedHelpers("workstate");

const { mapGetters } = createNamespacedHelpers("auth");

import delAssigment from '@/components/dialog/fill/del-assigment.vue';
import Postpone from '../components/dialog/fill/postpone.vue';
import workPieChart from '@/components/UI/GRAPHICS/workPieChart.vue';
import WorkTaskAssProject from './pattern/work-task-ass-project.vue';
import LeftList from '@/components/carddetails/pattern/leftList.vue';
import wtasp from '@/utils/wtasp' //Содержит функции для Project, Task, Work

export default {

  name:"work",

  mixins:[uf, wtasp],

  components:
    {
      GantWork,
      informationorders,
      assignment,
      mMessegeListRight,
      filelist,
      delAssigment,
      Postpone,
      workPieChart,
      WorkTaskAssProject,
      LeftList
    },

    data: () => ({
     
      myid:null,
      currentid:0,
      waiter:false,
      delete_dialog:false,  
      assign_del_id: null,
      activedCh: {},
      chatview:true,
      gantview: false,
      breadcrumbs:[{href:'',disabled:true,text:""}],
      comment:"",
      // workaccepted:0,
      level:3,
      task:{name:"",task_work:[],datestart:"",dateend:"",responsible:{id:""},status:{id:0,name:""},description:""},
      show:true,
      tab: 0,
      nedotab: 0,   
      ws:null,
      work: {name:"", parent:{name:""}, status:{name:""}, comment:[],
            responsible:{fullname:"", position:{name:""}},
            work_assignment:[{name:"", status:{name:""},comment:[],
            author:{fullname:"", position:{name:""}},
            responsible:{fullname:"", position:{name:""}}}]
          }
    }),
    
    computed: {
      ...mapGetters(["getUser", ]),
      ...globalstore.mapGetters(["getassign_id"]),

      fullinfo(){
        return [this.work,...this.work.work_assignment]
      },

      ass_statuses_calc(){
        return this.pie_statuses_calc(this.work.work_assignment)
      },

    //  cardinfo(){ 
    //     if(this.tab==0){
    //       return {...this.work,parent:this.task, type:'Задача:', role: 'Ответсвенный:'}
    //     } else{
    //        let assignment = this.work.work_assignment.find(t=>t.id == this.currentid)        
    //       return {...assignment,parent:this.work, type:'Работа:', role: 'Ответсвенный:'}
    //     }   
       
    //   },      
    
    },


    mounted(){
        moment.locales('ru')  
       
        this.ws = new this.$pws()
        this.ws.start(this.$route.fullPath);
         this.ws.addEvent('onmessage', (event) => {
            const data = JSON.parse(event.data);
        
            if ("action" in data) {
              try{
                    this[data.action](data.payload)
              }catch(e){console.log(e)
              console.log(data.action)
              }
              }
            else{
              console.log(data)
         
              }
           
        })

    

    },
   
    methods:{
        ...globalstore.mapMutations(['set_assign_id']),
        ...projectstate.mapMutations(["setProject", "clearProject"]),
        ...projectstate.mapGetters(["getProject","getprojectuniqueusers"]),
        ...workstate.mapGetters(['getworks']),
        ...workstate.mapMutations(["setWorks"]),
        ...taskstate.mapMutations(["settasks"]),
        ...assignmentstate.mapGetters(['getAssignments','getAssignmentdatestart','getAssignmentdateend']),

      newmessageincome(payload){               
        console.log(`payload`, payload);
        let index = this.mychats.findIndex(el=> el.id == payload.chat.id)
        if (this.mychats[index].lastmessage.length==0 || this.mychats[index].lastmessage[this.mychats[index].lastmessage.length-1].id!=payload.id)
        {this.mychats[index].lastmessage.push(payload)}
        this.$refs.mychat.scrollbottom(payload.id)
      },

      filerenew(payload){
        payload.forEach((el,index)=> payload[index].visible =el.visible.split("") )
        this.work.work_files = payload
      },

      fileupdated(payload){            
        let ind = this.work.work_files.findIndex(el=>el.id==payload.id)        
        this.work.work_files[ind].visible=payload.visible.split("")
      },

      takeprev(payload){
        let ind = this.mychats.findIndex(el=>el.id==payload.chat)   
        if  (this.mychats[ind].lastmessage.length<20){
            this.mychats[ind].lastmessage=payload.res
            this.mychats[ind].lastmessage=this.mychats[ind].lastmessage
        }
        else{
          this.mychats[ind].lastmessage = payload.res.concat(this.mychats[ind].lastmessage)
        }
        this.waiter=false
      },

      messagedeleted(payload){
        try{
          let ind = this.mychats.findIndex(e=>e.id==payload.chat)
          let ind2=this.mychats[ind].lastmessage.findIndex(e=>e.id==payload.id)
          this.mychats[ind].lastmessage.splice(ind2,1)
          console.log(this.mychats[ind].lastmessage, "slice");}
        catch{}
      } ,

      assupdate(payload){
        if(payload.bigbuild){
          this.rebuild()
        }
          let ind = this.work.work_assignment.findIndex(el=>el.id==payload.assignment.id)
          for (let [key,val] of Object.entries(payload.assignment))
            {
                this.work.work_assignment[ind][key]=val
            }
        },
   
      tab0update(payload){
          this.work.status = payload.status
        },

      renew(payload){
        this.ws.stop()
              console.log("aaaaad")
              this.ws.start(this.$route.fullPath);
        this.activeChat()
      },

      filedeleted(payload){     
        console.log("pl");
        let ind = this.work.work_files.findIndex(el=>el.id==payload.id)
        this.work.work_files.splice(ind,1)
      },

      listchangetab(tab){
          if (this.tab!=Number(tab)) {
            this.show = false   
            this.nedotab=Number(tab)

         

          }
        this.afterLeave()
        this.level=this.tab==0?3:4       

      },
      
      
      afterEnter(){
        console.log("@after-enter=")
      },
      afterLeave(){   
            
        this.tab=this.nedotab
        console.log(`afterLeave`,this.tab, this.work); 

        this.currentid = this.tab==0?this.work.id:this.work.work_assignment[this.tab-1].id
      
        this.activeChat()
        this.show=true
        this.breadcrumbsBuildier()
      },
                     
    createnewass(){
      this.$refs.gantwork.createAssignment()
    },

    changegantview(){
      this.gantview=false
    },
    chatviewer(){
    
      this.chatview=!this.chatview
    },
  
  createtabchat(){
    let name = this.work.name
    let level = 3
    let parent = this.work.id
    let users = new Set()
    if (this.tab==0){      
      this.work.work_assignment.forEach(e=> users.add(e.responsible.id).add(e.author.id))
      users.add(this.work.responsible.id)
    }
   
   else{
    level = 4
    parent=this.fullinfo[this.tab].id  
    users.add(this.fullinfo[this.tab].responsible.id).add(this.fullinfo[this.tab].author.id)
    name =this.fullinfo[this.tab].name

   }
   this.chatview=true
    bus.$emit("supogrammchatcreate",{users:Array.from(users),name, level,parent})   

  },



  gantviewer(){
      this.gantview=!this.gantview
      if (this.gantview) this.$refs.gantwork.rebuild()
    },


    changetab(id){      
      let tab=this.work.work_assignment.findIndex(el=>el.id==id)+1
      this.listchangetab(tab)
    },





  

    gantsaver(val){
        delete val.val.history
        this.ws.send({"action":val.am.method,"payload":val.val})
        // this.set
    },

    changestatus(chang){ 
      console.log(chang);  
      let action = "workstatus"  
      let payload = {
        id: chang.val.id,
        status: chang.action,
        comment: chang.comment,
        ididit:chang.ididit,
        h_action:chang.h_action
        
      }
      
      let check = this.getProject()
      
       
      payload['project_status_update'] = check.status.id ==3?true:false
      payload['task_status_update']= this.task.status.id < 2 ?true:false
      
      if (this.tab>0){
        payload['work_status_update']= this.work.status.id < 2 ? true:false 
        action = "assignmentstatus"
      }
        this.ws.send({action,payload})
    },



        build(payload){         
            console.log(payload);
            if ("project" in payload)             this.setProject(payload.project)
             this.myid=null!= this.getassign_id? this.getassign_id.id:null
             this.set_assign_id(null)
             
             let wc = 0
             payload.work.work_files.forEach((el,index)=> payload.work.work_files[index].visible =el.visible.split("") )         
           
            this.setWorks(payload.work)
            this.work = this.getworks()
            
            this.task = payload.task
            this.settasks(payload.task)
            console.log(`------------------fullinfo`, this.fullinfo, this.tab);
            
            if (this.myid!=null) this.changetab(this.myid)
            this.currentid = this.tab==0?this.work.id:this.work.work_assignment[this.tab-1].id
            this.breadcrumbsBuildier()
          
            this.mychats = payload["datachat"]
            this.activeChat()
            this.level=this.tab==0?3:4

        },

        breadcrumbsBuildier(){
          this.breadcrumbs=[
                                { text: this.getProject().name, disabled: false, href: `/project/${this.getProject().id}` },                               
                                   { text: this.task.name, disabled: false, href: `/project/${this.getProject().id}/task/${this.task.id}`  }]
          if (this.tab>0)this.breadcrumbs.push( { text: this.work.name, disabled: false, href: `` }, )
          
            
        },


         activeChat(){          
                let level = this.tab==0?3:4  
                console.log(this.currentid,"currentid");  
                try{
                    this.activedCh = this.mychats.find(e=> e.parent == this.currentid && e.level ==level) 
                    console.log("измененный чат",this.activedCh);
                if (this.activedCh.lastmessage.length>0)
               {this.$refs.mychat.scrollbottom(this.activedCh.lastmessage[this.activedCh.lastmessage.length-1].id)}
              //  console.log(this.activedCh,"actived");
                }
                catch{
                  this.activedCh ={}
                }
                this.chatview="id" in this.activedCh
            },

        


        confirmation(payload){
          
          this.work.work_assignment.forEach(el=> {
                         
                                                  el.menu=false 
                                                  el.action_confirm=false})
          payload['work_status_update'] = this.work.work_assignment.every(el=>{ if(el.id==payload.id && payload.status==5){return true}
                                                                                else if(el.status.id==5){return true}
                                                                                return false
        
                                                                              })
                                                                              ?
                                                                              {"res":true,"project":this.getProject().id}:{'res':false}
          this.ws.send({"action":"confirmation","payload":payload})

  
        },
        
        VisSwitcher(file){     
   

        this.ws.send({"action":"updateFile","payload":{id:file.id,visible: file.visible.join("")}})
     
           },

        assignment_del_run(){    
            
          
          this.ws.send({"action":"delasygmnt","payload":this.assign_del_id})
          this.assign_del_id=null
          this.delete_dialog=false
      
        },











        rebuild(){
         

          this.ws.send({"action":"rebuild","payload": this.work.id})
        },


        async uploadfile(formData){
            let fileinfo = {project:this.getProject().id, work:this.work.id, task:this.work.parent.id, visible: '0010'}
            if (this.tab>0){
                fileinfo['assignment']=this.work.work_assignment[this.tab-1].id
                fileinfo.visible='0001'
            }
           // Тут же заделаем потом на другие уровни - задачи и проекты
            formData.append('info', JSON.stringify(fileinfo))
           
            let res = await axiosInstance.post( `/main/uploader`, formData,{
                                        headers: {
                                            "Content-Type": "multipart/form-data",
                                        },
                            })
            if ("created" in res.data){
                this.ws.send({"action":"fileuploaded","payload":this.work.id})
            }
        }


    }   ,
        beforeDestroy() {
      this.clearProject()
    }
        

}
</script>

<style>



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