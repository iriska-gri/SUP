<template>
    <v-row>
        <v-col class=""
        :class="value.month?'ml-2 pr-0 pl-1 ':''"
        >
            <div v-if="value.month" class="text-center">
                {{monthhelp[value.text]}}
            </div>



        <div class="px-2 pt-1 pb-2 d-flex flex-col" v-else>
          <div
            class="align-self-end flex-grow-0 text-card-calendar pb-1"
          >
            {{ value.text }},
          </div>
                <div
                  class="flex-grow-1 flex-col d-flex justify-space-around align-center icon-card-calendar"
                  v-if="value.data.assignment"
                  
                >
                <v-row >
                  <v-col class="pa-0">
                      <MyIco
              size="small"
              icons = 'mdi-format-list-bulleted'/>

        
                  </v-col>
                </v-row>
                  <v-row class="mt-2">

                  <v-col class="py-0 calendar-count text-center">
                      {{ value.data.assignment }}
                  </v-col>
                </v-row>
                                                          <!-- <div v-if="value.data.assignment">
                                                            <div>
                                                              <v-icon >mdi-format-list-bulleted</v-icon>
                                                            </div>
                                                                <div class="calendar-count text-center">
                                                                  {{ value.data.assignment }}
                                                                </div>
                                                              </div> -->
                                                        <!-- <div v-if="value.data.assignment">
                                                          <div>
                                                            <v-icon>mdi-pencil-outline</v-icon>
                                                          </div>
                                                          <div class="calendar-count text-center">
                                                            {{ value.data.assignment }}
                                                          </div>
                                                        </div>
                                                        <div v-if="value.data.assignment">
                                                          <div><v-icon>mdi-handshake-outline</v-icon></div>
                                                          <div class="calendar-count text-center">
                                                            {{ value.data.assignment }}
                                                          </div>
                                                      </div> -->
                                                    </div>
        </div>
                                            </v-col> 

</v-row>
  
</template>

<script>
export default {
  props: {
    
      value: {
      type: Object,
      default: ()=>{}
    },
},
data(){
return{
  monthhelp:{
    "01":"январь",
    "02":"февраль",
    "03":"март",
    "04":"апрель",
    "05":"май",
    "06":"июнь",
    "07":"июль",
    "08":"август",    
    "09":"cентябрь",
    "10":"октябрь",
    "11":"ноябрь",
    "12":"декабрь"
    }
}
}



}
</script>

<style>

</style>