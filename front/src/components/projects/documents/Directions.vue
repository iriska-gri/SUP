<template>
    <div>
        <v-row class="">
            <v-col >
                <v-row>
                    <v-col class="text-center pa-0"  id="general">
                        <dockhead 
                            :title="'РАСПОРЯЖЕНИЕ'"/>
                    </v-col>
                </v-row>
                
                <v-row class="justify-space-between ma-0">
                    <v-col xl=2 class=" pa-0">
                        <v-menu v-if="editable"
                        v-model="picker0"
                        :close-on-content-click="false"
                        transition="scale-transition"
                        offset-y
                        min-width="auto"
                        >
                            <template
                                v-slot:activator="{on, attrs}"
                                class="ma-0 align-self-start "
                            >
                                <v-text-field
                                    dense
                                    :value="formatDate(orderdock.orderdate)"              
                                    type="date-local"              
                                    placeholder="дд.мм.гггг"
                                
                                @input="event=>oninputnostore(event, ['orderdock','orderdate'], orderdock.datestart)"
                                    v-bind="attrs"
                                    hide-details
                                    v-on="on"
                                    class="pt-1 mb-2 inputext"
                                >
                                </v-text-field>
                            </template>
                            <v-date-picker
                                :first-day-of-week="1"                                         
                                v-model="orderdock.orderdate"
                                :max="orderdock.datestart"
                            
                            >
                            </v-date-picker>
                        </v-menu>
                        <v-col class="text-nowrap px-0" v-else>от {{momentext(orderdock.orderdate)}} года</v-col>
                    </v-col>
                    <v-col class="text-end">
                        N
                    </v-col>
                    <v-col
                        class="flex-grow-0 text-nowrap w-75 pa-0 align-self-center"
                        xl=3
                    >
                        <v-text-field
                            v-if="editable"
                            v-model="orderdock.tabler.docnumber"
                            hide-details="auto"
                            dense
                        >
                        </v-text-field>
                        <span v-else>{{orderdock.tabler.docnumber}}</span>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col class="text-center pa-0">
                        Об утверждении Паспорта Проекта, плана контрольных событий Проекта и состава Рабочей группы по реализации Проекта 
                        <br> "{{orderdock.name}}"
                    </v-col>
                </v-row>
                <v-row>
                    <v-col>
                        <p class="text-center pa-0">
                            В целях контроля реализации направлений деятельности ФНС России в сфере  
                            <v-text-field
                                v-if="editable"
                                v-model="orderdock.workField"
                                hide-details="auto"
                                dense
                                placeholder="Укажите сферу Проекта"
                                class="pt-1 mb-2 inputext inpcent"
                            >
                            </v-text-field>
                        </p>
                        <p class="test1">
                            1.Утвердить:
                        </p>
                        <p class="test1 px-4">
                            - Паспорт Проекта согласно приложению №1 к настоящему распоряжению;
                        </p>
                        <p class="test1 px-4">
                            - План контрольных событий Проекта согласно приложению №2 к настоящему распоряжению;
                        </p>
                        <p class="test1 px-4">
                            - Состав Рабочей группы по реализации Проекта согласно приложению №3 к настоящему распоряжению.
                        </p>
                        <p class="test1">
                            2.Контроль за исполнением настоящего распоряжения оставляю за собой.
                        </p>
                        <v-row class="mt-0">
                            <v-col class="text-end pa-0 d-flex justify-space-between" v-if="'approver' in orderdock">
                            {{position(orderdock.approver)}} {{initial(orderdock.approver)}}{{orderdock.approver.sn}}
                        </v-col> 
                        <v-col class="text-end pa-0 d-flex justify-space-between" v-else>
                            {{position(approver)}} {{initial(approver)}}{{(approver&& 'sn' in approver)? approver.sn:""}}
                        </v-col>
                        </v-row>
                    </v-col>
                </v-row>
                <!-- {{ orderdock.tasks }} -->
                <!-- {{ dialogdata }} -->
                {{ getProject() }}
                <!-- {{ getprojectuniquePersons() }} -->
                <!-- {{ getprojectuniqueusers() }} -->
            </v-col>
        </v-row>
        <v-row class="mt-6">
            <v-col>
                <v-row>
                    <v-col class="text-end" id="appen1">
                        <p>
                            Приложение №1
                        </p>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col class="d-flex justify-end">
                        <div>
                            <div>
                            УТВЕРЖДЕН
                            </div>
                            <div>
                                распоряжением ФНС России
                            </div>
                            <div
                            dense
                            :value="formatDate(orderdock.orderdate)"              
                            type="date-local"              
                            >
                                от {{ momentext(orderdock.orderdate) }} г.
                            </div>
                            <div>
                                N {{ orderdock.tabler.docnumber }}
                            </div>
                        </div>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col class="text-center pa-0">
                        ПАСПОРТ Проекта
                    </v-col>
                </v-row>
                <v-row>
                    <v-col>
                        <p class="test1">
                            ОСНОВНЫЕ ПОЛОЖЕНИЯ:
                        </p>
                        <table id='tab1'>
                            <tr>
                                <td>Наименование проекта</td>
                                <td>{{ orderdock.name }}</td>
                            </tr>
                            <tr>
                                <td>Директор проекта</td>
                                <td>{{ orderdock.director }}</td>
                            </tr>
                            <tr>
                                <td>Руководитель проекта</td>
                                <td>{{ orderdock.rp }}</td>
                            </tr>
                            <tr>
                                <td>Координатор</td>
                                <td>{{ orderdock.coordinator }}</td>
                            </tr>
                            <tr>
                                <td>Секретарь</td>
                                <td>{{ orderdock.secretary }}</td>
                            </tr>
                            <tr>
                                <td>Участники проекта</td>
                                <td>
                                    <v-list-item v-for="(user,i) in orderdock.users" :key="i">
                                        {{ i+1 }}. {{ user.fullname }}
                                    </v-list-item>
                                </td>
                            </tr>
                        </table>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col>
                        <p class="test1">
                            СОДЕРЖАНИЕ ПРОЕКТА:
                        </p>
                        <table id='tab2'>
                            <tr>
                                <td>Основание для инициации проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            v-model="orderdock.reason"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                            </tr>
                            <tr>
                                <td>Цель (цели) проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                            <v-icon
                                                slot="append"
                                            >
                                                mdi-plus
                                            </v-icon>
                                        </v-text-field>
                                    </slot>
                                </td>
                            </tr>
                            <tr>
                                <td>Задачи проекта</td>
                                <td>
                                    <v-list-item v-for="(task,i) in orderdock.tasks" :key="i">
                                        {{ i+1 }}. {{ task.name }}<br>
                                    </v-list-item>
                                </td>
                            </tr>
                            <tr>
                                <td>Критерии успеха проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                            <v-icon
                                                slot="append"
                                            >
                                                mdi-plus
                                            </v-icon>
                                        </v-text-field>
                                    </slot>
                                </td>
                            </tr>
                            <tr>
                                <td>Период реализации проекта</td>
                                <td>
                                    <slot>
                                        {{ momentext(orderdock.datestart) }} - {{ momentext(orderdock.dateend) }}
                                    </slot>
                                    <div>
                                        <v-dialog
                                            v-if="editable"
                                            v-model="dialog"
                                            width="500"
                                            persistent
                                        >
                                            <template v-slot:activator="{ on,attrs }">
                                                <v-btn 
                                                    slot="append"
                                                    v-bind="attrs"
                                                    v-on="on"
                                                    elevation="2"
                                                    x-small
                                                >
                                                    создать этапы проекта
                                                </v-btn>
                                            </template>
                                            <v-card>
                                                <v-card-title class="">
                                                    Создание этапов проекта:
                                                </v-card-title>

                                                <v-card-text>
                                                    <div>
                                                        <v-text-field
                                                            label="Введите название этапа"
                                                            :rules="rules"
                                                            hide-details="auto"
                                                            prefix
                                                        ></v-text-field>
                                                        <v-autocomplete 
                                                            v-model="stageTasks"
                                                            :items="orderdock.tasks"
                                                            label="Выберите задачи входящие в этап"
                                                            multiple
                                                            chips
                                                            item-text="name"
                                                            item-value="name"
                                                        >
                                                            <template v-slot:selection="data">
                                                                <v-chip
                                                                v-bind="data.attrs"
                                                                :input-value="data.selected"
                                                                close
                                                                @click="data.select"
                                                                @click:close="remove(data.item)"
                                                                >
                                                                {{ data.item.name }} 
                                                                </v-chip>
                                                            </template>
                                                            <template v-slot:item="data">
                                                                <template>
                                                                    <v-list-item-content>
                                                                        <v-list-item-title>{{ data.item.name }}</v-list-item-title>
                                                                        <v-list-item-subtitle>{{ formatDate(data.item.datestart) }} - {{ formatDate(data.item.dateend) }}</v-list-item-subtitle>
                                                                    </v-list-item-content>
                                                                </template>
                                                            </template>
                                                        </v-autocomplete>
                                                    </div> 
                                                    <v-btn
                                                        small
                                                        @click="addStage"
                                                    >
                                                        Добавить
                                                    </v-btn>  
                                                </v-card-text>

                                                <v-divider></v-divider>

                                                <v-card-actions>
                                                    <v-spacer></v-spacer>
                                                    <v-btn
                                                        text
                                                        @click="dialog = false"
                                                    >
                                                        Закрыть
                                                    </v-btn>
                                                    <v-btn
                                                        text
                                                        @click="dialog = false"
                                                    >
                                                        Сохранить
                                                    </v-btn>
                                                </v-card-actions>
                                            </v-card>
                                        </v-dialog>
                                    </div>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td>Риски реализации проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                            <v-icon
                                                slot="append"
                                                @click="risks"
                                            >
                                                mdi-plus
                                            </v-icon>
                                        </v-text-field>
                                    </slot>
                                </td>
                            </tr>
                            <tr>
                                <td>Влияние результата проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                            </tr>
                            <tr>
                                <td>Взаимосвязи с другими проектами и программами</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                            </tr>
                            <tr>
                                <td>Дополнительная информация</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            v-model="orderdock.dopInfo"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                            </tr>
                            <tr>
                                <td>Результаты проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            v-model="orderdock.results"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                            </tr>
                        </table>
                    </v-col>
                </v-row>
            </v-col>
        </v-row> 
        <v-row class="mt-6">
            <v-col>
                <v-row>
                    <v-col class="text-end" id="appen2">
                        Приложение №2
                    </v-col>
                </v-row>
                <v-row>
                    <v-col class="d-flex justify-end">
                        <div>
                            <div>
                            УТВЕРЖДЕН
                            </div>
                            <div>
                                распоряжением ФНС России
                            </div>
                            <div
                            dense
                            :value="formatDate(orderdock.orderdate)"              
                            type="date-local"              
                            >
                                от {{ momentext(orderdock.orderdate) }} г.
                            </div>
                            <div>
                                N {{ orderdock.tabler.docnumber }}
                            </div>
                        </div>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col class="text-center pa-0">
                        План контрольных событий проекта "{{ orderdock.name }}""
                    </v-col>
                </v-row>
                <v-row>
                    <v-col>
                        <table id='tab3'>
                            <tr>
                                <th style="white-space: nowrap;">п/п</th>
                                <th>Наименование задачи/контрольного события</th>
                                <th>Ответственный исполнитель</th>
                                <th>Дата решения задачи/наступления контрольного события</th>
                            </tr>
                            <tbody v-for="(task,i) in orderdock.tasks" :key="i">
                                <tr>
                                    <td>{{ i+1 }}</td>
                                    <td>{{ task.name }}</td>
                                    <td>{{ getRespUser(task.responsible.id) }}</td>
                                    <td>{{ momentext(task.dateend) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </v-col>
                </v-row>
            </v-col>
        </v-row> 
        <v-row class="mt-6">
            <v-col>
                <v-row>
                    <v-col class="text-end" id="appen3">
                        Приложение №3
                    </v-col>
                </v-row>
                <v-row>
                    <v-col class="d-flex justify-end">
                        <div>
                            <div>
                            УТВЕРЖДЕН
                            </div>
                            <div>
                                распоряжением ФНС России
                            </div>
                            <div
                            dense
                            :value="formatDate(orderdock.orderdate)"              
                            type="date-local"            
                            >
                                от {{ momentext(orderdock.orderdate) }} г.
                            </div>
                            <div>
                                N {{ orderdock.tabler.docnumber }}
                            </div>
                        </div>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col class="text-center pa-0">
                        Состав рабочей группы по реализации проекта "{{ orderdock.name }}""
                    </v-col>
                </v-row>
                <v-row>
                    <v-col>
                        <table id='tab4'>
                            <tr>
                                <th style="white-space: nowrap;">п/п</th>
                                <th>Наименование проектной роли</th>
                                <th>Процент загрузки на проекте</th>
                                <th>Ф.И.О должностного лица</th>
                                <th>Наименование подразделения и должности</th>
                            </tr>
                            <tr>
                                <td>1</td>
                                <td>Директор проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                                <td>{{ orderdock.director }}</td>
                                <td>{{ getProject().director.position.name }}</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Руководитель проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                                <td>{{ orderdock.rp }}</td>
                                <td>{{ getProject().rp.position.name }}</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Координатор</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                                <td>{{ orderdock.coordinator }}</td>
                                <td>{{ getProject().coordinator.position.name }}</td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td>Секретарь</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                                <td>{{ orderdock.secretary }}</td>
                                <td>{{ getProject().secretary.position.name }}</td>
                            </tr>
                            <tr v-for="(user,i) in orderdock.users" :key="i">
                                <td>{{ i+5 }}</td>
                                <td>Участник проекта</td>
                                <td>
                                    <slot>
                                        <v-text-field
                                            v-if="editable"
                                            hide-details="auto"
                                            dense
                                        >
                                        </v-text-field>
                                    </slot>
                                </td>
                                <td>{{user.fullname}}</td>
                                <td>{{ user.position.name }}</td>
                            </tr>
                        </table>
                    </v-col>
                </v-row>
            </v-col>
        </v-row>
    </div> 
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import moment from "moment";
import datepicker from "@/utils/datepiker.js"
const  projectstate =createNamespacedHelpers("projectstate");
import Dockhead from '@/components/projects/documents/dockhead'

export default {
    name:"Directions",
    mixins:[datepicker],

    components: {
        Dockhead
    },

    props: {
        editable: {
            type: Boolean,
            default: false
        },
        dialogdata:{
            type: Object,
            default:()=>{return{}}
        },
        approver:{
            type: Object,
            default:()=>{return {position:{name:""}}}
        },
    },

    data() {
        return{

            picker0:false,
            dialog: false,
            stageTasks:[],


            rules: [
                value => !!value || 'Не указано название',
            ],
            
            orderdock:{orderdate: moment().format("YYYY-MM-DD"),
                // confirmation: "",
                name: this.getProject().name,
                datestart:this.getProject().datestart,
                dateend:this.getProject().dateend,
                coordinator:this.getProject().coordinator.fullname,
                director:this.getProject().director.fullname,
                rp:this.getProject().rp.fullname,
                secretary:this.getProject().secretary.fullname,
                tasks:this.getProject().tasks,
                users:this.getProject().users,
                workField:'',
                reason:'',
                dopInfo:'',
                results:'',
                // controller:{fullname:""},
                tabler:{docnumber:""},
            },
        }
    },

    mounted(){
    if ('id' in this.dialogdata){      
       
        this.orderdock = this.dialogdata.vrersion
        this.orderdock['tabler']={docnumber:this.dialogdata.docnumber}

        }
       
    },

    watch:{
        dialogdata: function(val, newval ){    
            console.log(val, newval,"CHANGED");
            if ('id' in val){
                if ( !(val.path===null)&& val.path.length){
                    console.log(val.path);
                }else{
                    this.orderdock = val.vrersion
                        this.approver=val.approver
                        this.orderdock['tabler']={docnumber:val.docnumber}
                }  
        
            }
            else
            {
                console.log("НОВЫЯ ШТУКА");
                this.orderdock={orderdate: moment().format("YYYY-MM-DD"),
                        // confirmation: "",
                        name: this.getProject().name,
                        datestart:this.getProject().datestart,
                        dateend:this.getProject().dateend,
                        coordinator:this.getProject().coordinator.fullname,
                        director:this.getProject().director.fullname,
                        rp:this.getProject().rp.fullname,
                        tasks:this.getProject().tasks,
                        users:this.getProject().users,
                        workField:'',
                        // controller:{fullname:""},
                        tabler:{docnumber:""}
                }
            
            }
        }
    },

    methods: {
        ...projectstate.mapGetters(["getProject","getprojectuniquePersons","getprojectuniqueusers"]),

        risks () {
            console.log('ok');
        },

        addStage () {
            console.log(this.stageTasks);
        },

        remove (item) {
            const index = this.stageTasks.indexOf(item.name)
            if (index >= 0) this.stageTasks.splice(index, 1)
            console.log(item);
        },

        momentext (value) {
            if (value) {
                return moment(value).locale('Ru').format('DD MMMM YYYY')
            }
        },

        position(ob){ 
            try{
                return ob.position.name
            }
            catch{
                return ""
            }
        },
        initial(ob){
            try{
                let init = ob.givenName.split(" ")
                return `${init[0][0]}.${init[1][0]}. `
            }
            catch {
                return ""
            }
        },

        oninputnostore(val,value,max){
            // console.log(min,max);
            // console.log(storiter,"storiter");
            let minmax = false
            if (max.length) {
                minmax = true
                max = moment(max)
            }
            try{
                let str=this.formatDateRev(val)
                const newdate=moment(str)
      
                if ((newdate.isValid()) && minmax){
            
                    if (newdate<=max){
                            this[value[0]][value[1]]=str
                    }

                } else if(newdate.isValid() && (!minmax)) {
                     this[value[0]][value[1]]=str
                }
            } catch(e) {
                console.log(e);
            }
        },

        getRespUser (value) {
            let it = this.orderdock.users.find(el=> el.id == value)
            return it.fullname
        } 
    }
}

</script>

<style>

    .test1 { 
        text-indent: 25px; text-align: justify;
    }

    .inpcent {
        text-align-last: center;
    }

    #tab1 tr td,#tab2 tr td {
        border: 1px solid;
        padding: .5em;
    }

    #tab1, #tab2, #tab3, #tab4 {
        border-collapse: collapse;
        width: 100%;
    }

    #tab3 td, #tab4 td{
        border: 1px solid;
        padding: .5em;
    }
    #tab3 th, #tab4 th{
        border: 1px solid;
        padding: .5em;
        font-size: .9em;
    }

</style>