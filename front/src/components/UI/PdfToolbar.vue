<template>
<!-- НЕ знаю почему, но цикл не работает -->
<div class="flex-grow-1">
  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                       :id="idConfig.zoomOut"
                        color="primary"
                       
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-magnify-minus-cursor 
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>Отдалить</span>
                  </v-tooltip>


      <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                       :id="idConfig.zoomIn"
                        color="primary"
                       
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-magnify-plus-cursor 
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>Приблизить</span>
                  </v-tooltip>



      <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                       :id="idConfig.previousPage"
                        color="primary"
                       
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-step-backward
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>На предыдущую страницу</span>
                  </v-tooltip>




  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                       :id="idConfig.nextPage"
                        color="primary"
                       
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-step-forward
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>На следующую страницу</span>
                  </v-tooltip>

  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        icon
                       :id="idConfig.presentationMode"
                        color="primary"
                       
                        v-bind="attrs"
                        v-on="on"
                      >
                        <v-icon color="btns">
                          mdi-fullscreen
                        </v-icon>
                      </v-btn>
                    </template>
                    <span>На весь экран</span>
                  </v-tooltip>




</div>

</template>

<script>
export default {
    name:"pdf-toolbar",
    data(){
        return{
            
            idConfig: { zoomIn: "zoomInId",
                  zoomOut: "zoomOutId",
                  download:"downloadId",
                  presentationMode:"presentationModeId",
                  previousPage:'previousPage',
                  // pageNumber:"pageNumberId",
                  nextPage:"nextPageId"
                  },
            scale: 100,
            page:1
        }
    },
  
}
</script>

<style>

</style>