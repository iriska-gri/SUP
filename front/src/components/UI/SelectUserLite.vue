<template>
    <v-menu
     :close-on-content-click="false"
      :nudge-width="250"
      max-height="350"
      left
      offset-x
    >
      <template v-slot:activator="{ on, attrs }">
        <div 
            v-bind="attrs"
            v-on="on" >
            <BtnsOut              
                :widthi=97
                :icon = true
                :title = "!selectedUs.length ? 'Добавить':'Изменить'"
                
            >
                <template #icons>
                  <!-- size="small" -->
                    <MyIco
                
                    size="large"
                    icons = 'mdi-account-plus'
                />
                </template>                         
            </BtnsOut>
        </div>
      </template>

      <v-card>

        <v-card-title class="">
          На согласование
        </v-card-title>

        <v-card-text>
          <v-data-table
            :search="search"
            hide-default-footer
            :custom-filter="filterme"
            dense
            :headers="headers"
            :items="allusers"
            item-key="id"
            sort-by="sn"
            class="elevation-1  menusH overflow-y-auto"
          >
            <template v-slot:[`header.involve`]            
            >
             <MyIco v-if="allusers.length"
                @click="involvall()"  
                size="small"
                :color='allusers.length==selectedUs.length && selectedUs.length>0?"green":"primaryicons"'
                :icons='selectedUs.length>0 && (allusers.length==selectedUs.length || allusers[0].involve)?"mdi-minus-box-multiple-outline": "mdi-plus-box-multiple"'
              />
          </template>
           <template v-slot:top>
                  <v-text-field
                    v-model="search"
                    label="Поиск"
                    class="mx-4"
                  ></v-text-field>
                </template>
 
            <template v-slot:[`item.involve`]="{ item }">
              <MyIco 
                @click="involving(item)"  
                size="small"
                :color='!(item.involve===null)?item.involve?"green":"primaryicons":""'
                :icons='!(item.involve===null)?item.involve?"mdi-check":"mdi-plus":""'
              />
            </template>
          </v-data-table>
        
        
        </v-card-text>

      </v-card>
    </v-menu>
</template>
  
  <script>
import { createNamespacedHelpers } from 'vuex';
const  projectstate =createNamespacedHelpers("projectstate");
import MyIco from '@/components/UI/MyIco.vue'

  
  export default {

    data () {
      return {
        search: '',
        headers: [
          {
            text: 'ФИО ',
            value: 'fullname',
          },  
          {
            text:"Должность",
            value:"position.name"

          } ,   
     
          {
            text:"",
            value:"involve",
            sortable: false,
          }
        ],
      }
    },

    props: {
      selectedUs: {
        type: Array,
        default: []
      },
      excludeUsers:{
        type: Array,
        default:[]
      }
    },
  
    components: {        
      MyIco
    },
    
    computed:{
      allusers(){
        let all = []
        let accid = []

        this.excludeUsers.forEach(el=>{accid.push(el.id)})
        this.getprojectuniquePersons().forEach(el => {
              let involve=this.selectedUs.find(e=>e.id==el.id)==undefined?false:true
              all.push(Object.assign({'involve':involve, accepted:0},el) )         
        });        
        let i=0
        while (i<all.length){
          if (accid.includes(all[i].id)){
            all[i].involve=null   
          }
          i++
        }
        i=0
         while (i<this.selectedUs.length){
          if (accid.includes(this.selectedUs[i].id)){
            this.selectedUs.splice(i,1)          
          }else{
                i++
          }          
        }
        return all
      }
    },

    methods: {
      ...projectstate.mapGetters(['getprojectuniquePersons']),
      involvall(){
        let res = this.allusers[0].involve===null?true:!this.allusers[0].involve        
        this.allusers.forEach(el=>{          
          el.involve=res
         let ind=this.selectedUs.findIndex(e=>e.id==el.id)
         this.selectedUs.splice(ind,1)         
         }
        )
        if (res){
          
          this.allusers.forEach(el=>{if(!(el.involve===null)){this.selectedUs.push(el)}})        
        }
           },
      filterme(value, search, item) {
        return value != null &&
          search != null &&
          typeof value === 'string' &&
          value.toString().toLocaleUpperCase().indexOf(search.toLocaleUpperCase()) !== -1
      },
      involving(item) {
        if (!(item.involve===null)){
        item.involve=!item.involve
        if(item.involve){
          this.selectedUs.push(item)
        }
        else{
          let ind=this.selectedUs.findIndex(e=>e.id==item.id)
          this.selectedUs.splice(ind,1)
        }
        }
      },

    }

     
  }
  
  </script>
  
  <style lang="scss" scoped>
        .menusH {
          max-height: 300px;
         
        }
  </style>