<template lang="">
 <v-row class="ma-0">
    <v-col class="kitr flex-col align-items-center justify-content-center">
                    <Cards
                        :ma="'ma-2'"
                        class="sizecard"
              
                      >
                        <template #cards>
                          <Cards
                            color="inyand"
                            :elevation= "0"
                          >
                            <template #cards>
                                <v-row class="flex-grow-0 bghead mb-1">
                                    <v-col class="body-2 text-nowrap font-weight-medium textcolor">Отчет о выполнненой работе за : 17.07.2023</v-col>
                                    <v-col class="pa-0 pt-2">
                                        <v-icon small 
                                        color="white">fa-calendar-days</v-icon>
                                    </v-col>
                                    <v-col class="text-end  textcolor font-weight-medium body-2 text-nowrap">Гришина Ирина Сергеевна</v-col>
                                </v-row>
                                <v-row class="my-1 overflow-y-auto h-0">
            <v-col class="rounded-sm flex-col" >
                <v-expansion-panels class="exp" flat focusable accordion
                active-class="ddd"
               
   
      
                
      >
    <v-expansion-panel
      v-for="(item,i) in blocks"
      :key="i"
      class="mb-3 rounded"

   
    >
          <!-- color="#F1F1F1"
      class="rounded font-weight-medium caption " -->
      <v-expansion-panel-header
      color="#F1F1F1"
      class="rounded font-weight-medium caption "
     >


     {{item.block_name}}
     <template #actions>
        <v-icon color="white">$expand</v-icon>
     </template>
    </v-expansion-panel-header>
      <v-expansion-panel-content
      class="mt-2"
     >
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      
    </v-expansion-panel-content>
    <v-divider></v-divider>
    </v-expansion-panel>
  </v-expansion-panels>

         
               
            </v-col>
            
        </v-row>
        <v-row class="flex-grow-0">
            <v-col class="px-0">
                <v-divider></v-divider>
            </v-col>
        </v-row>
      
        <v-row class="flex-grow-0 mb-0">
            
            <v-col class="py-0 mr-4  flex-row">
                <v-btn
      tile
      color="error"
      small
      min-width=120
    >
      <!-- <v-icon left>
        mdi-pencil
      </v-icon> -->
      Выйти
    </v-btn>
            </v-col>
    <v-col class="py-0 flex-row justify-content-end">
        <v-btn
      tile
      color="success"
      small
      min-width=120
    >
      <!-- <v-icon left>
        mdi-pencil
      </v-icon> -->
     Просмотр
    </v-btn>
            </v-col>
        </v-row>

        <v-row class="flex-grow-0">
            <v-col class="px-0 pt-0 pb-0">
                <v-divider></v-divider>
            </v-col>
        </v-row>

                            </template>
                          </Cards>
                        </template>
                    </Cards>
        </v-col>
    </v-row>
</template>
<script>
export default {
    data: () => ({

        blocks: [{block_name: 'Работа с базой знаний'},
        {block_name: 'Работа со сценарием'},
        {block_name: 'Работа с классификатором'},
        {block_name: 'Мониторинг качества работы чат-бота'},
        {block_name: 'Иное'},
    ],
    })
}
</script>
<style >
    .sizecard {
        width: 50vw;
        max-height: 80vh;
    }

    .kitr {
        background-color: #5b894c8f;
    }

    .exp  .v-icon.v-icon {

    font-size: 10px;
    }

    .bet {
        justify-content: space-between
    }

    .bghead {
            background-color:#6F6F6F!important;
            min-height: 3%;
        }

    .textcolor {
        color:white
    }

  
.theme--light.v-expansion-panels.v-expansion-panels--focusable .v-expansion-panel-header--active:hover::before, .theme--light.v-expansion-panels.v-expansion-panels--focusable .v-expansion-panel-header--active::before {
    opacity: 1.0!important;
    background-color:#4C3F99;
}

.v-expansion-panel--active > .v-expansion-panel-header, .v-expansion-panel-header {
    max-height: 30px!important;
}

.v-expansion-panel-header {
    min-height: 30px!important;
}
    /* .v-expansion-panel--active .ddd{
        background-color: blue!important;
    }
    .mmm{
        background-color: red !important;
    }

  */

   /* .exp .theme--light.v-expansion-panels .v-expansion-panel {
    background-color: red;
    color: rgba(0, 0, 0, 0.87);
} */
/* .theme--light.v-expansion-panels .v-expansion-panel {
    background-color: blue!important;
    color: rgba(0, 0, 0, 0.87);
}

     .theme--light.v-expansion-panels.v-expansion-panels--focusable .v-expansion-panel-header--active:hover::before, .theme--light.v-expansion-panels.v-expansion-panels--focusable .v-expansion-panel-header--active::before {

    background: red!important;
} */


/*
    .bgpannel {
        background: 
    } */
</style>