<template>
<v-container class="flex-col h-100 w-100" fluid>
    <!-- <v-row class="styck">
        <v-col>
            <pre>
            <br>{{breadcrumbs}}
            </pre>
        </v-col>
    </v-row> -->
    <v-row>
        <v-col class="flex-col">
            <Cards>
                <template #cards>
                    <v-row>
                        <v-col
                            class="flex-grow-0"
                        >
                        </v-col>
                         <v-col class="flex-col">
                            <v-row class="flex-grow-0">
                                <v-col class="pa-0">
                                  <v-breadcrumbs
                                    class="pa-0 justify-end pr-2"
                                    :items="breadcrumbs"
                                  >
                                      <template v-slot:item="{ item }">
                                          <v-breadcrumbs-item
                                              :href="item.href"
                                              :disabled="item.disabled"
                                          >
                                              {{ item.text.toUpperCase() }}
                                          </v-breadcrumbs-item>
                                      </template>
                                  </v-breadcrumbs>
                                </v-col>
                            </v-row>
                            <v-row>
                                <v-col>
3
                                </v-col>
                            </v-row>
                        </v-col>
                    </v-row>
                </template>
            </Cards>

        </v-col>
    </v-row>
    <v-row class="flex-grow-0">
        <v-col class="pt-0">
            <v-card 
                class="flex-col flex-grow-1 rounded"
                color="main_theme"
                outlined               
            >
                <v-card-text class="flex-col flex-grow-1 pa-0 inyand">
                    <gant-work
                        class="pa-1"
                        :startlevel="'work'"
                        @saver="gantsaver" 
                        @changetab="changetab"  
                    />
                </v-card-text>
            </v-card>
        </v-col>
    </v-row>
</v-container>
</template>
<script>
import GantWork from '@/components/visual/GantWork.vue'
import moment from "moment";
import { createNamespacedHelpers } from "vuex";
import {axiosInstance, axiosMp, URL} from '@/utils/api'
const assignmentstate = createNamespacedHelpers("assignmentstate");
const projectstate = createNamespacedHelpers("projectstate");
const taskstate = createNamespacedHelpers("taskstate");
const workstate = createNamespacedHelpers("workstate");
import uf from '@/utils/universal_functions'
const { mapGetters } = createNamespacedHelpers("auth");
export default {
    components:{GantWork},
    mixins:[uf],
    props:{
      myid:{
        type: Number,
        default:0
      }
    },
    data: () => ({
      panel: [0, 1],
    //   length: 15,
      breadcrumbs:[{href:'',disabled:true,text:""}],
      comment:"",
      workaccepted:0,
      level:2,
      textlevels:[{field:'project',text:"В проекте"},{field:'task',text:"В задаче"},{field:'work',text:"В работе"},{field:'assignment',text: "В поручении"}],
      files:null,
      tab: 0,    
      ws:null,
      work:{name:"", parent:{name:""}, status:{name:""}, comment:[],
      responsible:{fullname:"", position:{name:""}},
      work_assignment:[{name:"", status:{name:""},comment:[],
      author:{fullname:"", position:{name:""}},
      responsible:{fullname:"", position:{name:""}}}]}
    }),

    computed: {
    ...mapGetters(["getUser", ]),
    },
    

    watch: {
        tab(val){         
                this.textlevel=val==0?'work':"assignment" 
                this.level=val==0?2:3

        }
        },
    //   length (val) {
    //     this.tab = val - 1
    //   },
    // },

    mounted(){
        moment.locales('ru')  
        this.ws = new this.$pws()
        this.ws.start(this.$route.fullPath);
         this.ws.addEvent('onmessage', (event) => {
            const data = JSON.parse(event.data);
            console.log(data);
            if ("action" in data) {this[data.action](data.payload)}
            else{console.log(data)}
           
        })
    

    },
        beforeDestroy(){
        console.log("destroy");
        this.ws.stop()
    },
    methods:{
        ...projectstate.mapMutations(["setProject"]),
        ...projectstate.mapGetters(["getProject","getprojectuniqueusers"]),
        ...workstate.mapGetters(['getworks']),
        ...workstate.mapMutations(["setWorks"]),
        ...assignmentstate.mapGetters(['getAssignments','getAssignmentdatestart','getAssignmentdateend']),


  momentedtime(val){
      return moment(val).locale("Ru").format("HH:mm DD MMMM YYYY")
    },
        momentedDay(val){
      return moment(val).locale("Ru").format("DD MMMM YYYY")
    },
    assrerady(){
      let result = false
     
      return  this.work.work_assignment.every(el=>[3,5].includes(el.status.id))
    },
    commentsplitter(text){
      let t = text.split(":")
      t.shift()
      return t.join("")
    },
    changetab(id){
      
      this.tab=this.work.work_assignment.findIndex(el=>el.id==id)+1
    },


    gantsaver(val){
      console.log(val.method, this[`get${val.level}`]());
      
        this.ws.send({"action":val.method,"payload":this[`get${val.level}`]()})
        // console.log({"action":val.method,"payload":this[`get${val.level}`]()};
    },
    changestatus(val, action){      
        let payload = {id:val.id,status: action, work_status_update:this.work.status.id<2?true:false}
        let check = this.getProject()
        
        let task = check.tasks.find(el=>el.id == this.work.parent.id)
       
        payload['project_status_update']=check.status.id<2?true:false
        payload['task_status_update']= task.status.id<2?true:false
        payload['projid']=task.parent.id
        console.log(payload['work_status_update']);
      this.ws.send({"action":"assignmentstatus","payload":payload})

    },
    changestatusParent(val, action){
      let payload = {id:val.id, status: action,project:this.getProject().id}
      this.ws.send({"action":"workstatusconfirm","payload":payload})

    },
        build(payload){
            if ("project" in payload)             this.setProject(payload.project)
             
             let wc = 0
             payload.work.work_files.forEach((el,index)=> payload.work.work_files[index].visible =el.visible.split("") )
             payload.work.work_assignment.forEach(el=> {if(el.status.name=="Завершено") wc+=1})
             this.workaccepted=wc/payload.work.work_assignment.length*100
           
            this.setWorks(payload.work)
             this.work = this.getworks()
            if (this.myid>0) this.changetab(this.myid)
            this.breadcrumbs=[
                                { text: this.getProject().name, disabled: false, href: `/project/${this.getProject().id}` },                               
                                   { text: this.work.parent.name, disabled: false, href: `/task/${this.work.parent.id}`  },                                       
                                          { text: this.work.name,  disabled: false,  href: `` }, ]
            
           
            
        },

        confirmation(elm,res, text){
          
          let ob = [moment().locale("Ru").format("HH:mm DD MMMM YYYY"), text + `${this.comment.length>0? ": " + this.comment:""}`]
          let payload = {id:elm.id, status:res, commentadd: ob}
          payload['work_status_update'] = this.work.work_assignment.every(el=>{ if(el.id==elm.id && res==5){return true}
                                                                                else if(el.status.id==5){return true}
                                                                                return false
        
        })?{"res":true,"project":this.getProject().id}:{'res':false}
        // console.log(payload['work_status_update'] );
          this.ws.send({"action":"confirmation","payload":payload})
          this.comment=""
        },
        
        VisSwitcher(file){     
        console.log(file.visible);

        this.ws.send({"action":"updateFile","payload":{id:file.id,visible: file.visible.join("")}})
     
           },


        fileupdated(payload){            
            let ind = this.work.work_files.findIndex(el=>el.id==payload.id)        
             this.work.work_files[ind].visible=payload.visible.split("")
         
         
        },
        deletefile(file){
            this.ws.send({"action":"deletefile","payload":{id:file.id,filepath:file.filepath
}})
        },
        filerenew(payload){
            payload.work_files.forEach((el,index)=> payload.work_files[index].visible =el.visible.split("") )
            this.work.work_files = payload.work_files
        }

        ,

        filedeleted(payload){     
            
                
            let ind = this.work.work_files.findIndex(el=>el.id==payload.id)
            this.work.work_files.splice(ind,1)
            
        },
        assupdate(payload){
          console.log(payload);
          if(payload.bigbuild){
              this.rebuild()
             
            }
            let ind = this.work.work_assignment.findIndex(el=>el.id==payload.assignment.id)
            for (let [key,val] of Object.entries(payload.assignment
        ))
            {
                this.work.work_assignment[ind][key]=val

            }
            
            
        },
        rebuild(){
          this.ws.send({"action":"rebuild","payload": this.work.id})
        },
        async uploadfile(ind){
              
            let formData = new FormData();   
            this.files.forEach(el => {formData.append('file',el)
                
            });
           this.files=null
            let fileinfo = {project:this.getProject().id, work:this.work.id, task:this.work.parent.id, visible: '0010'}
            if (this.level==3){
                fileinfo['assignment']=this.work.work_assignment[ind-1].id
                fileinfo.visible='0001'
            }
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


    }   
        

}
</script>

<style>
.pointer{
  cursor: pointer;
}
fieldset {
  height: 2.5rem;
}
</style>