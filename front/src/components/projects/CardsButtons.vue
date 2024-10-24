<template>
<Cards>
    <template #cards>
        <v-card-actions>
            <v-row class="pa-2">
                <v-col
                  v-for ="(btns_name) in btns_otchet"
                  :key="btns_name"
                  lg=6
                  sm=6
                  class="pa-1 "
                >
                    <BtnsOut
                        :outlined = true
                        :block = true
                        :title = btns_name
                    />
                </v-col>
            </v-row>
        </v-card-actions>
    </template>
</Cards>
    <!-- <v-card color="main_theme">
        <v-card-actions>
           
        </v-card-actions>
    </v-card> -->
</template>

<script>

import Cards from '@/components/UI/Cards.vue'

export default {
    
    name:"Cards-Buttons",

    components: {        

      Cards
    },

    props:{
        btns_otchet: []
    }

}
</script>

<style lang="scss">
@import "@/utils/colors.scss";

</style>