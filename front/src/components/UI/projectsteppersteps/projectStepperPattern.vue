<template>
    <v-card
      
    >
        <v-stepper v-model="e1" >
            <v-row class="ma-0 justify-content-end">
                <div class="align-self-center positionname flex-col flex-grow-1">
                  <span class="px-0 pb-0 hstep text-center text-subtitle-1 font-weight-medium text-uppercase texthead--text">
                    {{name}}
                </span>  
                </div>
                <v-col class="flex-grow-0 ">
                    <MyIco
                        @click="$emit('closes')"
                        icons = 'mdi-close-thick'
                        color="close_icons"  
                        size="small"  
                    />         
                </v-col>
            </v-row>
           
            <v-row class="ma-0">
                <v-col class="flex-grow-0 text-nowrap pa-0 ">
                     <v-divider />
                    <template v-for="(x, index) in projstep" >
                        <v-stepper-step
                            :complete="e1 > index+1"
                            :step="index+1"
                            :key="x"
                            color="open_icons"
                            
                            edit-icon="mdi-reply"
                            @click="validstep(index+1)"
                            
                        >
                            {{x}}
                            
                        </v-stepper-step>
                        <v-divider :key="index"/>
                    </template>
                </v-col>
   

                <v-col class="px-0 pt-0 flex-col">
                                    <v-row class="flex-grow-0">
                    <v-col class="px-3 ">
                        <v-divider />
                    </v-col>
                </v-row>
                    <v-stepper-items
                        
                        :class="!$vuetify.theme.dark?'auchlight':'auchdark'"
                    >
                    

                    
                        <v-stepper-content
                            v-for="(x, index) in projstep"
                            :key="index+1"
                            :step="index+1"
                            class="pa-0"
                        >
                  
                          
                            <v-card
                            class="ma-1"
                            elevation="2"
                            height='600'
                            style="overflow: auto"
                            >                    
                                <component :is="['step-one','step-two','step-three','step-four','step-five'][index]" 
                                ref="childform"
                                :newproject="newproject"
                                @showuserinfo="showuserinfo"
                                
                                ></component> 
                                <!-- <step-one ref="childform" :newproject="newproject" v-if="index==0"/> -->
                                <!-- <step-two ref="childform" :newproject="newproject" v-if="index==1" @showuserinfo="showuserinfo"/> -->
                                <!-- <step-three ref="childform" :newproject="newproject" v-if="index==2"/> -->
                                <!-- <step-four ref="childform" :newproject="newproject" v-if="index==3"/> -->
                                <!-- <step-five ref="childform" :newproject="newproject" v-if="index==0"/>                                -->

                            </v-card>
                                
                                   
                 
                        </v-stepper-content>
                  
        
                    </v-stepper-items>
                                 <v-row class=" mt-1">
                            <v-col class="pt-1">
                                <MyIco
                                    v-if="e1!=1"
                                    @click="e1--"
                                    icons = 'mdi-menu-left'
                                    color="btns"
                                    size="32"
                                />
                            </v-col>
                            <v-col class="flex-grow-0"
                            :class="e1<projstep.length?'pt-1':'pt-2'">
                                <MyIco
                                   
                                    @click="nextstep"
                                    :icons ="e1<projstep.length?'mdi-menu-right':'mdi-check'"
                                    :color="e1<projstep.length?'btns':'open_icons'"  
                                    :tooltip="true"
                                    :text_tool="e1<projstep.length?'Далее':'Сохранить проект'"
                                    size="32"  
                                />
                                <!-- <MyIco 
                                    v-else
                                    @click="$emit('create_or_update')"
                                    icons = 'mdi-check'
                                    color='open_icons'
                                    :tooltip= true
                                    size="25"  
                                    :text_tool="'Сохранить проект'"
                                /> -->
                    
                            </v-col>
                        </v-row>
                </v-col>
                <v-col class="pa-0 flex-grow-0 pl-0 rama" >
                 

                </v-col>
            </v-row>
        </v-stepper>
    </v-card>
</template>

<script>
import stepOne from "@/components/UI/projectsteppersteps/stepOne.vue"
import stepTwo from "@/components/UI/projectsteppersteps/stepTwo.vue"
import stepThree from "@/components/UI/projectsteppersteps/stepThree.vue"
import stepFour from "@/components/UI/projectsteppersteps/stepFour.vue"
import stepFive from "@/components/UI/projectsteppersteps/stepFive.vue"
import { createNamespacedHelpers } from "vuex";
const projectstate = createNamespacedHelpers("projectstate");
export default {
    
    name: "project_stepper_pattern",
    components: { stepOne, stepTwo, stepThree,stepFour,stepFive},
    props: {
        name: {
            type: String,
            default: "Новый проект"
        }
    },

    data: () => ({
            e1: 1,
            projstep: ['Основные положения', 'Персоны', 'Идея проекта', 'Задачи/работы', 'Отчетные даты'],
            newproject:{
                                            longname: '',
                                            name: '',
                                            difficult:0,
                                            datestart: undefined,
                                            dateend: undefined,
                                            ptype: { "id": 2 },
                                            project_checkpoint: [],
                                            info:{
                                                financial_support:"",
                                                project_sphere:"",
                                                passport_last_date:"",
                                                influence: "",
                                                grounds: '',
                                                target:[],
                                                result:[],
                                                criteria:[],
                                                risks:[],
                                                interactions:[],
                                                dop_info: ''
                                            },
                                            users:[],
                                            tasks:[]
                                        } 
            
    })
    ,

    methods:{
        nextstep(){
           
            if(this.e1<this.projstep.length && this.$refs.childform[0].$refs.form.validate()){
                this.e1++
            }
            else if(this.e1==this.projstep.length){
                this.create_or_update()
            }
        },

        validstep(ind){
            if(this.$refs.childform[0].$refs.form.validate()){
                this.e1=ind
            }
            
            
        },
        setpercent(val){
            console.log(val,"VAAAAAAAA");
            this.newproject.users.find(e=>e.role.id==val.id).percent=val.percent
        },

    
        showuserinfo(id){
        this.$emit("showuserinfo",id)
    },

    create_or_update() {
           
            console.log(this.newproject,"ddddddddddddddddddd");
            let deletion = this.newproject.deletion
            this.newproject.users = this.getProject.users
            delete this.newproject.history
            delete this.newproject.project_files
            delete this.newproject.deletion
            delete this.newproject.datachat
            console.log(this.newproject,"ddddddddddddddddddd");
            this.$emit('newproject', {project: this.newproject, delete:deletion} )
       
        },


    
    },
    

     mounted() {          
                this.newproject = JSON.parse(JSON.stringify(this.getProject))
                console.log(`----------this.newproject.tasks 22------`, this.newproject);
                if (this.newproject.tasks.length<1)
                {
                    this.newproject.tasks = []
                }
                else{
                    this.newproject.tasks.forEach((e)=>{e.fakeid = `t-${e.id}`;
                                                        e.task_work.forEach(n=>n.fakeid=`w-${n.id}`)
                    })
                    console.log(this.newproject.tasks,"fake");
                }
              
            

        
       },
    computed:{
            ...projectstate.mapGetters(["getProject", "getprojectuniqueusers",'getprojectuniquePersons']),
            }
    


}
</script>

<style>
.hstep {
    height: 10%;
}

.bgstep {
    background: #e3e3e3;
}
</style>