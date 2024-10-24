<template>
  <div id="gant" ref="divgant">
    <!--   <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/22.2.3/css/dx.dark.compact.css" /> -->
    <!-- <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/22.2.3/css/dx-gantt.css" /> -->

    <div class="gantRef">
 
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
        <!-- <DxItem name="addTask"/>
        <DxItem name="deleteTask"/> 
        <DxItem name="separator"/>-->
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
                Создать задачу</v-btn>
      
                
                
                
                
                
                
               

                   
            </template>
                    </DxItem>
       <!-- <DxItem name="showResources"/>
        <DxItem name="showDependencies"/>
        <DxItem name="separator"/> -->
        <!-- <DxItem
          :options="aboutButtonOptions"
          widget="dxButton"
        /> -->
      </DxToolbar>

        <DxTasks :data-source="tasks"/>
        <!-- <DxDependencies :data-source="dependencies"/> -->
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
        <!-- <DxColumn
          data-field="start"
          caption="Начало"
          :width="80"
        />
        <DxColumn
          data-field="end"
          caption="Окончание"
            :width="80"
        />
         <DxColumn
          data-field="status.name"
          caption="Статус"
          :width="80"
        /> -->

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
          
            <!-- <div class="custom-task-img-wrapper">
              <img
                class="custom-task-img"
                :src="getImagePath(item.taskData.id)"
              >
            </div> -->
            <div class="custom-task-wrapper">
              <!-- <div class="custom-task-title"></div> -->
            
              <div class="custom-task-row">   {{ item.taskData.title }} -- 
                 {{(item && 'taskResources' in item && item.taskResources.length)? item.taskResources[0].text:'' }}</div>
            </div>
            <!-- <div
              class="custom-task-progress"
              :style="{width: item.taskData.progress + '%'}"
            /> -->
          </div>
        </template>
      </DxGantt>
    </div>



    <v-dialog
      overlay-opacity= ".1"
      v-model="dialog"
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
                <v-text-field 
                  v-model="name"
                  label="Краткое название"
                  required
                ></v-text-field>
              
              </v-col>
               <v-col
                cols="12"
                
              >
                <v-text-field 
                  v-model="longname"
                  label="Название"
                  required
                ></v-text-field>
              
              </v-col>
            
              <v-col cols="12">
               <Datepiker
                 :min="actionmethod.min"
                 :max="actionmethod.max"
                 :datestartstore="actionmethod.datestartstore"
                 :dateendstore="actionmethod.dateendstore"
               />
              </v-col>
              <v-col
                cols="12"
                
              >
                <div>
                <v-select 
                 v-model="responsible"
                 item-text="text"
                item-value="id"
                  :items='resources'
                  @change="console"
                  label="Ответственный"
                  required
                  return-object
                ></v-select>
                  <v-row class="flex-grow-0 px-5">
            <v-col class="pb-0 pt-2 d-flex">  <span class="caption">Сложность:</span> <v-rating
          class="pb-2"
          color="warning"
          empty-icon="mdi-star-outline"
          full-icon="mdi-star"
          half-icon="mdi-star-half-full"
          hover
          length="5"
          
          size="16"
          v-model="difficult"
        ></v-rating>
            </v-col>
            </v-row>
                  <v-textarea
                v-model="description"
                rows=5
                no-resize
                label="Описание"
                >

                </v-textarea>
                </div>
               
              
              </v-col>
         
            </v-row>
          </v-container>
        
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <BtnsOut
          title="Отмена"
          @click="dialog=false"
          />
          <BtnsOut
          title="Сохранить"
          @click="saveit"
          />
        </v-card-actions>
      </v-card>
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
              Вы уверены что хотите удалить "{{name}}"?
              Также будут удалены все связанные объекты
                <!-- <v-text-field
                  v-model="name"
                  label="Название"
                  required
                ></v-text-field> -->
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
        <!-- {{date_watch(2023-01-12, 2023-02-24)}}  -->
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
  DxContextMenu
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
    DxItem
  },
  mixins:[gantff],
  data() {
    return {
      // description:"",
      scale:"year",
      selectedkey:"",
      ganttRef,
      actionmethod:{method:"addTask", text:"Создание задачи",dateendstore:"",datestartstore:"",min:"",max:"", level:"tasks"},
      dialog:false,
      deldialog:false,
      tasks:[],
      task:[ { name: 'edittask', text: 'Редактировать задачу' },{ name: 'addwork', text: 'Создать Работу' },  {name: 'deltask', text: 'Удалить'} ],
      work:[ { name: 'editwork', text: 'Редактировать работу' },  {name: 'delwork', text: 'Удалить'} ],
      dialoginfo:{},
      contextMenuItems: [],
      resourceAssignments:[],
      disableContextMenu: false,
    };
  },
  created(){
        loadMessages(deMessages);
        locale(navigator.language);
         
         
  },
  mounted(){       
        
  },
  computed:{

    name:{
      get(){        
        return  this[`get${this.actionmethod.level}`]().name
      },
      set(value){
         this[`set${this.actionmethod.level}name`](value)
      }
    },
    longname:{
      get(){        
        return  this[`get${this.actionmethod.level}`]().longname
      },
      set(value){
        console.log(this.actionmethod.level);
         this[`set${this.actionmethod.level}longname`](value)
      }
    },
  
    description:{
       get(){
        return  this[`get${this.actionmethod.level}`]().description
      },
      set(value){
        this[`set${this.actionmethod.level}description`](value)
          
      }     

    },    
  

     difficult:{
       get(){
        return  this[`get${this.actionmethod.level}`]().difficult
      },
      set(value){
           this[`set${this.actionmethod.level}difficult`](value)
      }      
      

    },
    responsible: {
      get(){
        return  this[`get${this.actionmethod.level}`]().responsible
      },
      set(value){
        this[`set${this.actionmethod.level}responsible`](value)
       
      }
    },

    gantt: function() {
      this.scale  = this.date_watch(this.getProjectdatestart(), this.getProjectdateend())
      return this.$refs[ganttRef].instance;},
    resources:{
        get(){
          
            return this.getprojectuniqueusers().filter(e=>e.role.id!=6)         
        }
    },
    
  //  rpchange(){return this.getProjectrp()},
   tasksOR(){ return this.getprojectTasks() },
    startDateRange(){
         let newd= new Date(this.getProjectdatestart())
        if (this.tasks.length>0 && newd!=this.tasks[0].start) 
        {  
            this.tasks[0].start= newd 
             this.gantt.refresh();       
            }
        let mindate = newd
        this.tasks.forEach(e => { mindate = ((e.start<newd)&& (e.start.getTime()!=0))?e.start:mindate });
        
        return mindate},
    endDateRange(){
       
        let newd= new Date(this.getProjectdateend())
    
        let maxdate = newd
    
        return maxdate},
    

  },

  watch:{

    tasksOR(val){  
        try{
        let parent =  this.topline(this.getprojectIdName(),this.getProjectdatestart(),this.getProjectdateend()) 
         
        this.tasks=[parent]    

        this.resourceAssignments=[{id:-1, taskId:`${parent.id}`, resourceId: this.getProjectrp().id }]
        console.log(val,"VAL");
        if (val.length){        
          
            for (let i=0;i<val.length;i++){
                this.tasks.push({id:`task-${val[i].id}`, title:val[i].name, parentId:this.tasks[0].id, start:new Date(val[i].datestart),end:new Date(val[i].dateend), status:val[i].status})
                this.resourceAssignments.push({id:i, taskId:`task-${val[i].id}`, resourceId: val[i].responsible.id })
                  let indx = 0
                 val[i].task_work.forEach(e=>
                  {this.tasks.push({id:`work-${e.id}`, title:e.name, parentId:`task-${val[i].id}`, start:new Date(e.datestart),end:new Date(e.dateend), status:e.status})
                  this.resourceAssignments.push({id:(e.id+7000000), taskId:`work-${e.id}`, resourceId: e.responsible.id })
                  indx++
                  }
                 )
                 
                
           }               
        }      
    }
    catch(e){}
    }
  },
  
  methods: {

     ...projectstate.mapGetters(["getprojectuniqueusers",'getprojectTasks','getprojectWorks','getProjectdatestart','getProjectdateend','getprojectIdName','getProjectrp']),
     ...taskstate.mapGetters(["getTaskdatestart","getTaskdateend","gettasks"]),
     ...taskstate.mapMutations(["setTaskdateend","setTaskdatestart",'settasks','settasksresponsible','settasksname','settasksdescription','settaskslongname','settasksdifficult']),
     ...workstate.mapGetters(["getWorkdatestart","getWorkdateend","getworks"]),
     ...workstate.mapMutations(["setWorkdateend","setWorkdatestart",'setWorks','setworksresponsible','setworksname','setworksdescription','setworkslongname','setworksdifficult']),


  
   createnewTask(){
    this.actionmethod={method:"addTask", 
                      level:"tasks",
                      text:"Создание задачи",
                      min:this.getProjectdatestart(), 
                      max:this.getProjectdateend(),
                      datestartstore:'Taskdatestart',
                      dateendstore:'Taskdateend'}

    this.settasks({name:"", parent: this.getprojectIdName().id,datestart:"",dateend:"", responsible:"", status:1,longname:"",difficult:0})
    this.dialog = true
   },

    console(val){
        console.log(val)
    },
    // saveito(){   

    //     this.$emit('saver',this.actionmethod)
    //     this.dialog=false
    //     this.deldialog=false
    // },

    onTaskDblClick(e){
         e.cancel = true;
        console.log(e.data,this.$route);

        let path = this.$route.path
        if(e.data.id.split("-")[0]!='parent'){ 
              let splitted = e.data.id.split("-")
                if (splitted[0]=="task"){
                  path+=`/${splitted[0]}/${splitted[1]}`
                }
                else{
                  let sp = e.data.parentId.split("-")
                  path+=`/${sp[0]}/${sp[1]}/${splitted[0]}/${splitted[1]}`
                }
            this.$router.push(path)
            }
    },
   

    getTaskColor(taskId) {
        let id = taskId.split("-")[1]
     
      const color = Number(id) % 6;
      return `custom-task-color-${color}`;
    },



    addwork(){
       let t = this.getprojectTasks()
      this.settasks(t[t.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.id.split("-")[0]=='task')])
      let w = this.getprojectWorks()
      console.log(this.selectedkey);
      this.setWorks({name:"", parent:Number(this.selectedkey.id.split("-")[1]),datestart:"",dateend:"", responsible:"",status:1,longname:"",difficult:0})
      
      // (t[t.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.title==e.name && this.selectedkey.id.split("-")[0]=='work')])
      
      this.actionmethod={method:"creatework",
                        level:"works", 
                        text:"Создание работы",
                        min:this.getTaskdatestart(), 
                        max:this.getTaskdateend(),
                        datestartstore:'Workdatestart',
                        dateendstore:'Workdateend'}
                        
      this.dialoginfo= this.getworks()                  
      this.dialog = true
    },
    editwork(){
      let t = this.getprojectTasks()
      this.settasks(t[t.findIndex(e=>e.id==this.selectedkey.parentId.split("-")[1] && this.selectedkey.parentId.split("-")[0]=='task')])
     
       let w = this.getprojectWorks()
      this.setWorks(w[w.findIndex(e=>e.id==this.selectedkey.id.split("-")[1]  && this.selectedkey.id.split("-")[0]=='work')])
      this.actionmethod={method:"editwork", 
                          level:"works", 
                          text:"Редактирование работы",
                        min:this.getTaskdatestart(), 
                        max:this.getTaskdateend(),
                        datestartstore:'Workdatestart',
                        dateendstore:'Workdateend'}
      this.dialog=true
      this.dialoginfo= this.getworks()
    },
    deltask(){
      
      let t = this.getprojectTasks()
     
      this.actionmethod={method:"deltask", 
                             level:'tasks',
                          text:"Удаление задачи",
                           datestartstore:'Workdatestart',
                        dateendstore:'Workdateend'}
      this.deldialog=true
       this.settasks(t[t.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] &&  this.selectedkey.id.split("-")[0]=='task')])
      this.dialoginfo= this.gettasks()
    },
    delwork(){
      let w = this.getprojectWorks()
      this.setWorks(w[w.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] &&  this.selectedkey.id.split("-")[0]=='work')])
      this.actionmethod={method:"delwork", 
                             level:'works',
                            text:"Удаление работы",
                            datestartstore:'Workdatestart',
                            dateendstore:'Workdateend'}
                            
                            
      this.deldialog=true
      this.dialoginfo= this.getworks()
      
      
      
      
      console.log(this.selectedkey);
       
    },
    edittask(){
      // this.description=""
      let t = this.getprojectTasks()
      console.log(t[t.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] &&  this.selectedkey.id.split("-")[0]=='task')]);
      this.settasks(t[t.findIndex(e=>e.id==this.selectedkey.id.split("-")[1] && this.selectedkey.id.split("-")[0]=='task')])
       this.actionmethod={method:"updatetask", 
                      level:'tasks',
                      text:"Редактирование задачи",
                      min:this.getProjectdatestart(), 
                      max:this.getProjectdateend(),
                      datestartstore:'Taskdatestart',
                      dateendstore:'Taskdateend'}
      
     this.dialoginfo= this.gettasks()
      
      this.dialog=true

    }
   
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




</style>
