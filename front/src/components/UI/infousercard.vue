<template>
  <v-dialog
  v-model="dialogdetail"
  transition="scroll-x-transition"
  max-width="800"
  @click:outside="$emit('dialogdetailoff')"
>
  
    <Cards
      :min_height=500
      :color="!$vuetify.theme.dark?'auchlight':'auchdark'"
 
  
    >
      <template #cards>
                <v-card-actions class="justify-end pa-0 mr-n1 pb-1">
       
                                    <MyIco
                            @click="$emit('dialogdetailoff')"
                            class="pa-0"
                            icons = 'mdi-close-thick'
                            size="x-small"
                            color="passiv_text"
                          />
        </v-card-actions>
        <v-card-text class="flex-col flex-grow-1">
            <v-row class="flex-grow-1 pb-2 px-2">
              <v-col
                class="flex-col "
                cols=7
              >
                <v-row class="flex-grow-0">
                  <v-col 
                    class="flex-col pr-1 pa-0"
                    cols=3
                  >
                    <Cards
                      :min_height=100
                      color="inputcolor"
                      :ma= "'false'"
                    >
                      <template #cards>
                          <v-img
                            class="ma-1"
                            height="90%"
                            :src="`http://${url}${person.avatar}`"
                          >
                        </v-img>
                      </template>
                    </Cards>
                  </v-col>
                  <v-col
                    class="flex-col pa-0 "
                    cols=9
                  >
                    <Cards
                      :min_height=100
                      color="inputcolor"
                      :ma= "'false'"
                    >
                      <template #cards>
                       
                        <v-simple-table class="flex-grow-1 ma-1">
                          <template v-slot:default>
                            <tbody class="flex-grow-1">
                            
                              <tr v-for="(value, key) in detailedit" :key="key" class="transparent">
                                <td class="pr-0 ">
                                  {{value}}
                                </td>
                                <td class="pr-0">
                                    
                                  {{person[key]}}
                                </td>
                              </tr>
                            </tbody>
                          </template>
                        </v-simple-table>               
                      </template>
                    </Cards>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col class="flex-col pa-0 pt-1">
                    <Cards
                      :ma= "'false'"
                      color="inputcolor"
                    >
                      <template #cards>
                        <v-simple-table class="flex-grow-1 py-1 ma-1" dense>
                          <template v-slot:default>
                            <tbody class="flex-grow-1">
                              <tr v-for="(value, key) in detailsextended" :key="key" class="transparent">
                                <td class="pr-0 ">
                                  {{value}}
                                </td>
                                <td class="pr-0">
                                  {{["otdel", "department",'position'].includes(key)? person[key].name:person[key]}}
                                  
                                </td>
                              </tr>
                            </tbody>
                          </template>
                        </v-simple-table>               
                      </template>
                    </Cards>
                  </v-col>
                </v-row>
              </v-col>
              <v-col class="pa-0 pl-1 flex-col">
                <Cards
                  :ma= "'false'"
                  color="inputcolor"
                >
                  <template #cards>
                    <Cards
                      class="ma-1 elevation-0"
                      color="inyand"
                    >
                      <template #cards>
                        <v-row>
                          <v-col class="align-self-center text-center passiv_text--text">
                              <!-- {{person}} -->
                            В проектах не замечен
                          </v-col>
                        </v-row>
                      </template>
                    </Cards>
             <!-- {{detailedit1}} -->
                  </template>
                </Cards>
              </v-col>
            </v-row>
          <!-- <div class="text-caption pa-12">
            {{detailedit}}
          </div> -->
        </v-card-text>

      </template>
    </Cards>

</v-dialog>
</template>

<script>
import {URL} from '@/utils/api'
import MyIco from '@/components/UI/MyIco.vue'
import Cards from '@/components/UI/Cards.vue'
export default {
    name:"infousercard",
    props:
    {
        dialogdetail:{
            type: Boolean,
            default: false
        },
        person:{
            type:Object,
            default:()=>{}
        }







    },
    components:{
        MyIco,
        Cards
    },
    data(){
        return{
            url:URL,
            detailedit:
            { fullname:'ФИО:',
            telephoneNumber: 'Телефон:'
            },
           detailsextended:
            {
              username:  'Имя компьютера:',
              phone: 'Личный телефон:',
              email: 'Почта',
              physicalDeliveryOfficeName: 'Адрес офиса',
              department:  'Департамент',
              otdel: 'Отдел',
              position:"Должность"
              
            }




        }
       
    },
    




}
</script>

<style>

</style>