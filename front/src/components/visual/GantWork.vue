<template>
  <div id="gant">
    <!--   <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/22.2.3/css/dx.dark.compact.css" /> -->
    <!-- <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/22.2.3/css/dx-gantt.css" /> -->

    <div class="" >
 
      <DxGantt
       :show-row-lines="false"
        :start-date-range="startDateRange"
        :end-date-range="endDateRange"
        :first-day-of-week="1"
        :task-list-width="0"
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
     <DxToolbar
    
     >
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
        
         @click.stop="createAssignment"    
                x-small
                class="inyand--text"
                color="btns"
                >
                Создать поручение</v-btn>
      
                
 
                   
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
            <div class="custom-task-edit-tooltip pa-2" v-if="statuser(taskk.id)!=false">
                <div class="custom-tooltip-title">"{{ taskk.title }}"</div>
            <div>
                Дата начала: {{taskk.start.toLocaleDateString()}}
            </div>
            <div>Дата окончания: {{taskk.end.toLocaleDateString()}}</div>
            <div>Статус: {{statuser(taskk.id)}}</div>
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
        ma="heightCard"
        class="dialog_gantWork_create_assignment"
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
      max-width="490px"
    >
      <DialogNewAssigment
        text="Удалить поручение"
      >
        <template #textarea>
          <delAssigment/>
        </template>
        <template #btn1>
          <BtnsOut
            title="Отмена"
            :outlined="true"
            @click="back"
          />
        </template>
        <template #btn2>
          <BtnsOut
            :outlined="true"
            :text="true"
            title="Удалить"
            @click="saveit"
          />
        </template>
      </DialogNewAssigment>
    </v-dialog>



  </div> 
</template>

<script>
const ganttRef = 'gantt'

import addAssigment from '@/components/dialog/fill/add-assigment.vue'

import  gantff  from '@/utils/gant.js'
import { createNamespacedHelpers } from "vuex";
const projectstate = createNamespacedHelpers("projectstate");
const taskstate = createNamespacedHelpers("taskstate");
const workstate = createNamespacedHelpers("workstate");
const assignmentstate = createNamespacedHelpers("assignmentstate");
import deMessages from "devextreme/localization/messages/ru.json";
import { locale, loadMessages } from "devextreme/localization"
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

;
import DialogNewAssigment from '@/components/dialog/UI/dialog-new-assignment.vue';
import delAssigment from '@/components/dialog/fill/del-assigment.vue';

export default {
  components: {
    DxScaleTypeRange, 
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
    DialogNewAssigment,
    addAssigment,
    delAssigment
  },
 mixins:[gantff],
  data() {
    return {
      dialoginfo:{},
      scale:"year",
      selectedkey:"",
      ganttRef,
      actionmethod:{method:"addWork", text:"Создание работы",dateendstore:"",datestartstore:"",min:"",max:"", level:"work"},
      dialog:false,
      deldialog:false,
      tasks:[],
      asgmnts:[],
      // task:[ { name: 'edittask', text: 'Редактировать задачу' },{ name: 'addwork', text: 'Создать Работу' }, ],
      work:[ { name: 'editwork', text: 'Редактировать работу' }, { name: 'createAssignment', text: 'Создать поручение' }, {name: 'delwork', text: 'Удалить'} ],
      ass:[{ name: 'editasygmnt', text: 'Редактировать поручение' },  {name: 'delasygmnt', text: 'Удалить'}],
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
      
    responsible: {
      get(){
        return this.gettasks().responsible
      },
      set(value){
         this.settasksresponsible(value)
      }
    },

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
    return  this.getworks().work_assignment},
    startDateRange(){
        return this.tasks[0]? this.tasks[0].start:new Date()},
     
    endDateRange(){
        return this.tasks[0]? this.tasks[0].end:new Date()}
 
        ,
    

  },

  watch:{
  
    // },
    tasksOR(val){  
      
         this.tasks=[]
        this.tasks[0]=this.topline(this.getworkidname(),this.getWorkdatestart(),this.getWorkdateend())   
        
        
        this.resourceAssignments=[{id:-1, taskId:`parent-${this.getworkidname().id}`, resourceId: this.getworkidname().resp }]
        
        if (val.length){        
          
            for (let i=0;i<val.length;i++){
                
                this.tasks.push({id:`ass-${val[i].id}`, title:val[i].name, parentId:this.tasks[0].id, start:new Date(val[i].datestart),end:new Date(val[i].dateend), status:val[i].status})
               
                this.resourceAssignments.push({id:i, taskId:`ass-${val[i].id}`, resourceId: val[i].responsible.id})
               
                
           }               
        }      
    this.gantt.refresh(); 
    }
  },
  
  methods: {

     ...projectstate.mapGetters(["getprojectuniqueusers",'getprojectTasks','getprojectWorks','getProjectdatestart','getProjectdateend','getprojectIdName','getProjectrp','getProject']),
     ...taskstate.mapGetters(["getTaskdatestart","getTaskdateend","gettasks"]),
     ...taskstate.mapMutations(["setTaskdateend","setTaskdatestart",'settasks','settasksresponsible','settasksname']),
     ...workstate.mapGetters(["getWorkdatestart","getWorkdateend","getworks","getworkidname"]),
     ...workstate.mapMutations(["setWorkdateend","setWorkdatestart",'setWorks','setworksresponsible','setworksname']),
    ...assignmentstate.mapGetters(['getAssignments','getAssignmentdatestart','getAssignmentdateend']),
    ...assignmentstate.mapMutations(['setAssignmentdescript','setAssignments','setAssignmentname','setAssignmentdateend','setAssignmentdatestart','setAssignmentresponsible']),
  
   
  
    statuser(id){
      try{
      let el = this.tasks.find(el=>el.id==id)
     
      return el.status.name}
      catch{
        return false
      }
    },

    back(){
            this.deldialog=false
          

    },
      
  



  

    onTaskDblClick(e){
         e.cancel = true;
        
        if(!(['parent','ass'].includes(e.data.id.split("-")[0])) ){ this.$router.push(`/${e.data.id.split("-").join("/")}`)}
        else if(e.data.id.split("-")[0]=="ass"){
          let id = e.data.id.split("-")[1]
          this.$emit('changetab', id)
        }
    },


    
    getTaskColor(taskId) {
      
      
      let el = this.tasks.find(e=>e.id==taskId)      
      if (el.id.startsWith("parent"))el=this.getworks()
      return `custom-task-color-${el.status.id}`;
    },



   delasygmnt(){
    let w=[] 
 
    this.setAssignments(this.getworks().work_assignment.find(e=> e.id==Number(this.selectedkey.id.split("-")[1])))
    this.dialoginfo= this.getAssignments()
    this.actionmethod={method:"delasygmnt", 
                             level:'Assignments',
                            text:"Удаление поручения",
                            datestartstore:'Assignmentdatestart',
                            dateendstore:'Assignmentdateend'}                            
                            
      this.deldialog=true
  
  
  
  
  
  
  },
  createAssignment(){     
     
      this.setAssignments({name:"",longname:"",difficult:0,parent:this.getworks().id, responsible:{},datestart:"",dateend:""})
      this.dialoginfo= this.getAssignments()
      this.actionmethod={method:"createasygmnt", 
                          level:"Assignments", 
                          responsible_text:"Исполнитель",
                          text:"Создание поручения",
                        min:this.getWorkdatestart(), 
                        max:this.getWorkdateend(),
                        datestartstore:'Assignmentdatestart',
                        dateendstore:'Assignmentdateend'}
      this.dialog=true


  },

  editasygmnt(){

    let el = this.getworks().work_assignment.find(e=>e.id==this.selectedkey.id.split("-")[1]  && this.selectedkey.id.split("-")[0]=='ass')
   console.log(el);
    this.setAssignments(el)
     this.dialoginfo = this.getAssignments()
      this.actionmethod={method:"editasygmnt", 
                          level:"Assignments", 
                          text:"Редактирование поручения",
                          responsible_text:"Исполнитель",
                        min:this.getWorkdatestart(), 
                        max:this.getWorkdateend(),
                        datestartstore:'Assignmentdatestart',
                        dateendstore:'Assignmentdateend'}
      
      this.dialog=true


  },

   
  },
};
</script>
<style>
 @import './gant.css';
 @import './lightgant.css';


.custom-task-color-1 {
  background-color: #8c9a92;
}

.custom-task-color-2 {
  background-color: #006fde;
}

.custom-task-color-3 {
  background-color: #d7a203;
}

.custom-task-color-4 {
  background-color: #ce5b47;
}

.custom-task-color-5 {
  background-color: #35b86b;
}

.custom-task-color-6 {
  background-color: #9f47ce;
}

.custom-task {
  max-height: 40px;
  height: 100%;
  display: block;
  overflow: hidden;
}

.custom-task-wrapper {
  padding: 1px;
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

/* .custom-task-title {
  font-weight: 300;
  font-size: 13px;
} */

.custom-task-row {
  font-size: .8rem;
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
  height: .5rem;
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

.v-input .v-label {
    color: rgb(116 111 111 / 60%);
}
.h_dna {
  height: 220px;
}

.heightCard {
  
    height: 320px;
    margin: 12px;

}

</style>
