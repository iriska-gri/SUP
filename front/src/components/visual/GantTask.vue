<template>
  <div id="gant">
    <!--   <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/22.2.3/css/dx.dark.compact.css" /> -->
    <!-- <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/22.2.3/css/dx-gantt.css" /> -->

    <div class="" >
 
      <DxGantt
        :start-date-range="startDateRange"
        :end-date-range="endDateRange"
        :first-day-of-week="1"
        :task-list-width="150"
        :height="350"
        :scale-type="scale"
        :task-content-template="'taskContentTemplate'"
        :task-tooltip-content-template="'TooltipContentTemplate'"
        :ref="ganttRef"
        :on-custom-command="onCustomCommandClick"
        :on-context-menu-preparing="onContextMenuPreparing"
        @task-dbl-click="onTaskDblClick"
      >
       <!--   -->
       <DxContextMenu
          :items="contextMenuItems"
        />
           <DxScaleTypeRange
            min="days"
            max="years"
        />



     <DxToolbar>
           <DxItem>
            <template #default>   
        <v-btn   
        icon
        class="mx-auto px-auto pl-1"
         @click.stop="$emit('changegantview')"    
                x-small
               
                color="btns"
                ><v-icon
                color="primary"
                >mdi-close</v-icon>
                </v-btn>
        </template>
            </DxItem>  



        <DxItem name="undo"/>
        <DxItem name="redo"/>
        <DxItem name="separator"/>
        <DxItem name="collapseAll"/>
        <DxItem name="expandAll"/>
        <DxItem name="separator"/>
      
        <DxItem name="zoomIn"/>
        <DxItem name="zoomOut"/>
         <DxItem name="fullScreen"/>
        <DxItem name="separator"/>
        <DxItem>
            <template #default>       
         
        <v-btn      
         @click.stop="createnewTask"    
                x-small
                class="inyand--text"
                color="btns"
                >
                Создать работу</v-btn>
      
                
 
                   
            </template>
                    </DxItem>

      </DxToolbar>

        <DxTasks :data-source="tasks"/>
     
        <DxResources     
        :data-source="resources"/>

        <DxResourceAssignments 
        
        
        :data-source="resourceAssignments"/>

        <DxEditing :enabled="false"
           
        />
         :allow-resource-adding = false
        :allow-resource-deleting = false    

       <DxColumn
         
          data-field="title"
          caption=""
           :width="1"
        />


       <template #TooltipContentTemplate="{ data: taskk }">
            <div class="custom-task-edit-tooltip pa-2">
                <div class="custom-tooltip-title">"{{ taskk.title }}"</div>
            <div>
                Дата начала: {{taskk.start.toLocaleDateString()}}
            </div>
            <div>Дата окончания: {{taskk.end.toLocaleDateString()}}</div>
            </div>
        </template>








        
        <template #taskContentTemplate="{ data: item }">
           
          <div
            class="custom-task"
            :class="getTaskColor(item.taskData.id)"
            :style="{width: item.taskSize.width + 'px'}"
          >

            <div class="custom-task-wrapper">

            
              <div class="custom-task-row">   {{ item.taskData.title }} -- 
                 {{(item && 'taskResources' in item && item.taskResources.length)? item.taskResources[0].text:'' }}</div>
            </div>
   
          </div>
        </template>
      </DxGantt>
    </div>



  <v-dialog
      overlay-opacity= ".1"
      v-model="dialog"
      
      max-width="700px"
    >
         <DialogNewAssigment
        :text="actionmethod.text"
        :height= 350
      >
        <template #textarea>
          <add-assigment
            :actionmethod="actionmethod"       
            :resources="resources"
            :dialoginfo="dialoginfo" 
            @changeddialog="changeddialog"    
          />
        </template>
        <template #btn1>
          <BtnsOut
            title="Отмена"
            @click="dialog=false"
          />
        </template>
        <template #btn2>
          <BtnsOut
            title="Сохранить"
            @click="saveit"
          />
        </template>
      </DialogNewAssigment>
     
    </v-dialog>


<v-dialog
      overlay-opacity= ".1"
      v-model="deldialog"
      
      max-width="600px"
    >
   
      <v-card>
        <v-card-title>
          <span class="text-h5">{{actionmethod.text}}</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col
                cols="12"
                
              >
              Вы уверены что хотите удалить "{{dialoginfo.name}}"?
              Также будут удалены все связанные объекты
       
              </v-col>
            
         
            </v-row>
          </v-container>
        
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <BtnsOut
          title="Отмена"
          @click="deldialog=false"
          />
          <BtnsOut
          title="Подтвердить"
          @click="saveit"
          />
        </v-card-actions>
      </v-card>
    </v-dialog>















  </div> 
</template>

<script>
// import 'devexpress-gantt/dist/dx-gantt.css';

// import 'devextreme/dist/css/dx.light.css';
const ganttRef = 'gantt'

import Datepiker from '@/components/UI/Datepiker.vue'
import gantff from '@/utils/gant.js'
import { createNamespacedHelpers } from "vuex";
const projectstate = createNamespacedHelpers("projectstate");
const taskstate = createNamespacedHelpers("taskstate");
const workstate = createNamespacedHelpers("workstate");
const assignmentstate = createNamespacedHelpers("assignmentstate");
import deMessages from "devextreme/localization/messages/ru.json";
import { locale, loadMessages } from "devextreme/localization"
const globalstore = createNamespacedHelpers("globalstore");
import addAssigment from '@/components/dialog/fill/add-assigment.vue'

import {
DxToolbar,
  DxScaleTypeRange, 
  DxItem,
  DxGantt,
  DxTasks,
  DxDependencies,
  DxResources,
  DxResourceAssignments,
  DxColumn,
  DxEditing,
  DxContextMenu,
} from 'devextreme-vue/gantt';

export default {
  components: {
    DxScaleTypeRange, 
    Datepiker,
    DxContextMenu,
    DxGantt,
    DxTasks,
    DxDependencies,
    DxResources,
    DxResourceAssignments,
    DxColumn,
    DxEditing,
    DxToolbar,
    DxItem,
    addAssigment
  },
  mixins:[gantff],
  data() {
    return {
      dialoginfo:{},
      scale:"year",
      selectedkey:"",
      ganttRef,
      actionmethod:{method:"addTask", text:"Создание работы",dateendstore:"",datestartstore:"",min:"",max:"", level:"task"},
      dialog:false,
      deldialog:false,
      tasks:[],
      task:[ { name: 'edittask', text: 'Редактировать задачу' },{ name: 'addwork', text: 'Создать Работу' }, ],
      work:[ { name: 'editwork', text: 'Редактировать работу' }, { name: 'createAssignment', text: 'Создать поручение' }, {name: 'delwork', text: 'Удалить'} ],
      asgmnt:[{ name: 'editasygmnt', text: 'Редактировать поручение' },  {name: 'delasygmnt', text: 'Удалить'}],
      contextMenuItems: [],
      resourceAssignments:[],
      disableContextMenu: false,
    };
  },
  created(){
        loadMessages(deMessages);
        locale(navigator.language);
         
         
  },
  
  computed:{


    gantt: function() {
      this.scale  = this.date_watch(this.startDateRange, this.endDateRange)     
      
      return this.$refs[ganttRef].instance;},
    resources:{
        get(){
          
            return this.getprojectuniqueusers().filter(e=>e.role.id!=6)        
        }
    },
    
  //  rpchange(){return this.getProjectrp()},
   tasksOR(){     
    return  this.gettasks().task_work},

     startDateRange(){
        return this.tasks[0]? this.tasks[0].start:new Date()},
     
    endDateRange(){
        return this.tasks[0]? this.tasks[0].end:new Date()}
 
        ,
    

  },

  watch:{
    // rpchange(){ 
    //  let parent =  this.topline()   
    //  this.tasks[0]=parent
    //  this.resourceAssignments[0]={id:-1, taskId:`${parent.id}`, resourceId: parent.rp }
    //  this.gantt.refresh(); 
    // },
    tasksOR(val){  
      console.log("WTF");
        let parent =  this.topline(this.gettasks(),this.getTaskdatestart(),this.getTaskdateend())   
        this.tasks=[parent]        
        this.resourceAssignments=[{id:-1, taskId:`parent-${this.gettasks().id}`, resourceId: this.getProjectrp().id }]
        // console.log(val);
        if (val.length){        
          
            for (let i=0;i<val.length;i++){
                this.tasks.push({id:`work-${val[i].id}`, title:val[i].name, parentId:this.tasks[0].id, start:new Date(val[i].datestart),end:new Date(val[i].dateend), status:val[i].status})
                this.resourceAssignments.push({id:i, taskId:`work-${val[i].id}`, resourceId: val[i].responsible.id })
                  let indx = 0
      
                  // val[i].work_assignment.forEach(e=>
                  // {this.tasks.push({id:`work-${e.id}`, title:e.name, parentId:`task-${val[i].id}`, start:new Date(e.datestart),end:new Date(e.dateend), status:e.status})
                  // this.resourceAssignments.push({id:(i+e.id+indx+7000000), taskId:`work-${e.id}`, resourceId: e.responsible.id })
                  indx++
                  val[i].work_assignment.forEach(el=>{
                    this.tasks.push({id:`asgmnt-${el.id}`, title:el.name,  parentId:`work-${val[i].id}`, start:new Date(el.datestart),end:new Date(el.dateend), status:el.status})
                  
                    this.resourceAssignments.push({id:(el.id+70000000), taskId:`asgmnt-${el.id}`, resourceId: el.responsible.id })
                  })
                  // }
                //  )
                 
                
           }               
        }      
    }
  },
  
  methods: {
    ...globalstore.mapMutations(['set_assign_id']),
     ...projectstate.mapGetters(["getprojectuniqueusers",'getprojectTasks','getprojectWorks','getProjectdatestart','getProjectdateend','getprojectIdName','getProjectrp','getProject']),
     ...taskstate.mapGetters(["getTaskdatestart","getTaskdateend","gettasks"]),
     ...taskstate.mapMutations(["setTaskdateend","setTaskdatestart",'settasks','settasksresponsible','settasksname']),
     ...workstate.mapGetters(["getWorkdatestart","getWorkdateend","getworks"]),
     ...workstate.mapMutations(["setWorkdateend","setWorkdatestart",'setWorks','setworksresponsible','setworksname']),
    ...assignmentstate.mapGetters(['getAssignments','getAssignmentdatestart','getAssignmentdateend']),
    ...assignmentstate.mapMutations(['setAssignments','setAssignmentname','setAssignmentdateend','setAssignmentdatestart','setAssignmentresponsible']),

   


   createnewTask(){
    this.actionmethod={method:"creatework", 
                      level:"works",
                      text:"Создание работы",
                      responsible_text:"Ответственный",
                      min:this.getTaskdatestart(), 
                      max:this.getTaskdateend(),
                      datestartstore:'Workdatestart',
                      dateendstore:'Workdateend'}

 
    this.setWorks({name:"", parent:Number(this.tasks[0].id.split("-")[1]),datestart:"",dateend:"", responsible:"",status:1})
    this.dialoginfo = this.getworks()
    this.dialog = true
   },

    console(val){
        console.log(val)
    },


    onTaskDblClick(e){
         e.cancel = true;    
         let url = this.$route.path+'/work/'
        
         if(e.data.id.split("-")[0]!='parent'){
            if (e.data.id.split("-")[0]=='work'){
              url+=e.data.id.split("-")[1]
            }
            else {
               url+=e.data.parentId.split("-")[1]
              this.set_assign_id(Number(e.data.id.split("-")[1]))
             }


          this.$router.push(url)
         }
     
    },
   

    
    getTaskColor(taskId) {
        let id = taskId.split("-")[1]
     
      const color = Number(id) % 6;
      return `custom-task-color-${color}`;
    },



    addwork(){
      this.createnewTask()
    },
    editwork(){   

       let w = this.gettasks().task_work
      console.log(w);
      this.setWorks(w[w.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.title==e.name && this.selectedkey.id.split("-")[0]=='work')])
      this.actionmethod={method:"editwork", 
                          level:"works", 
                          text:"Редактирование работы",
                          responsible_text:"Ответственный",
                        min:this.getTaskdatestart(), 
                        max:this.getTaskdateend(),
                        datestartstore:'Workdatestart',
                        dateendstore:'Workdateend'}
      this.dialoginfo = this.getworks()
      this.dialog=true
    },
 
    delwork(){
      let w = this.gettasks().task_work
      this.setWorks(w[w.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.title==e.name && this.selectedkey.id.split("-")[0]=='work')])
      this.actionmethod={method:"delwork", 
                             level:'works',
                            text:"Удаление работы",
                            datestartstore:'Workdatestart',
                            dateendstore:'Workdateend'}
                            
      this.dialoginfo = this.getworks()         
      this.deldialog=true
    
       
    },

   delasygmnt(){
    let w=[]
    this.gettasks().task_work.forEach(e=>{w=w.concat(e.work_assignment)})
 
    this.setAssignments(w[w.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.title==e.name && this.selectedkey.id.split("-")[0]=='asgmnt')])
    this.actionmethod={method:"delasygmnt", 
                             level:'Assignments',
                            text:"Удаление поручения",
                            datestartstore:'Assignmentdatestart',
                            dateendstore:'Assignmentdateend'}
                            
       this.dialoginfo = this.getAssignments()          
      this.deldialog=true
  
  
  
  
  
  
  },
  createAssignment(){
      let wo = this.gettasks().task_work

      this.setWorks(wo[wo.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.id.split("-")[0]=='work')])
      this.setAssignments({name:"",parent:this.getworks().id, responsible:{},datestart:"",dateend:""})
      this.dialoginfo = this.getAssignments()
      this.actionmethod={method:"createasygmnt", 
                          level:"Assignments", 
                          text:"Создание поручения",
                          responsible_text:"Исполнитель",
                        min:this.getWorkdatestart(), 
                        max:this.getWorkdateend(),
                        datestartstore:'Assignmentdatestart',
                        dateendstore:'Assignmentdateend',
                        responsible_text:"Исполнитель"}
      
      this.dialog=true
      

  },

  editasygmnt(){
  let wo = this.gettasks().task_work
  this.setWorks(wo[wo.findIndex(e=>e.id==this.selectedkey.parentId.split("-")[1] && this.selectedkey.parentId.split("-")[0]=='work')])
  let w=[]
   this.gettasks().task_work.forEach(e=>{w=w.concat(e.work_assignment)})
   

      this.setAssignments(w[w.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.title==e.name && this.selectedkey.id.split("-")[0]=='asgmnt')])
    
      this.actionmethod={method:"editasygmnt", 
                          level:"Assignments", 
                          text:"Редактирование поручения",
                          responsible_text:"Исполнитель",
                        min:this.getWorkdatestart(), 
                        max:this.getWorkdateend(),
                        datestartstore:'Assignmentdatestart',
                        dateendstore:'Assignmentdateend'}
      this.dialoginfo = this.getAssignments()
      this.dialog=true


  },

    // edittask(){
    //   let t = [this.getProject().task]
      
    //   this.settasks(t[t.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.title==e.name && this.selectedkey.id.split("-")[0]=='task')])
    //    this.actionmethod={
    //                   method:"updatetask", 
    //                   level:'tasks',
    //                   text:"Редактирование задачи",
    //                   min:this.getProjectdatestart(), 
    //                   max:this.getProjectdateend(),
    //                   datestartstore:'Taskdatestart',
    //                   dateendstore:'Taskdateend'}
      
    
      
    //   this.dialog=true

    // }
   
  },
};
</script>
<style>
 @import './gant.css';
 @import './lightgant.css';
/* #gantt {
  height: 700px;
} */

.custom-task-color-0 {
  background-color: #5c57c9;
}

.custom-task-color-1 {
  background-color: #35b86b;
}

.custom-task-color-2 {
  background-color: #4796ce;
}

.custom-task-color-3 {
  background-color: #ce4776;
}

.custom-task-color-4 {
  background-color: #ce5b47;
}

.custom-task-color-5 {
  background-color: #f78119;
}

.custom-task-color-6 {
  background-color: #9f47ce;
}

.custom-task {
  max-height: 48px;
  height: 100%;
  display: block;
  overflow: hidden;
}

.custom-task-wrapper {
  padding: 4px;
  color: #fff;
}

.custom-task-wrapper > * {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
}

.custom-task-img-wrapper {
  float: left;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  margin: 8px;
  background-color: #fff;
  overflow: hidden;
}

.custom-task-img {
  width: 32px;
}

.custom-task-title {
  font-weight: 600;
  font-size: 13px;
}

.custom-task-row {
  font-size: .7rem;
}

.custom-task-progress {
  position: absolute;
  left: 0;
  bottom: 0;
  width: 0%;
  height: 4px;
  background: rgba(0, 0, 0, 0.3);
}
 
.dx-gantt .dx-row {
  height: 2rem;
} 
.dx-splitter-wrapper{
    z-index: 8;
}
.dx-gantt-taskWrapper{
     z-index: 7;
}

.custom-task-edit-tooltip{
  background: rgba(17, 17, 17, 0.707);
  color: white;
}


.h_dna {
  height: 220px;
}


</style>
