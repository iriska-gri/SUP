<template>
    <div >
        <row-pirow
            v-for="x in roleusers"
            :key= x.id
            :title="x.name+':'"            
            :rightcolUsed= true
          
        >
        <template #leftcol>
            <v-row class="flex-grow-1">
                <v-col  lg="8">
                    <span
                        class="pointer"
                        @click="searchid(x.id)>0?$emit('showuserinfo', searchid(x.id)):''"
                    >
                        {{searchid(x.id)==0?"Не назначен":respons(x.id)}}
                    </span>
                </v-col>
                <v-col 
                    lg=1
                    class="px-0"
                    v-if="searchid(x.id)>0"
                >
                    <v-text-field
                        class="mt-n1 text-last-center"
                        dense
                        v-if="show"
                        type="number"
                        :value="getProject.users.find(e=> e.role.id == x.id).percent"
                        @input="perce"
                        @focus="input=x.id"
                        :rules="[percentrule.minmax]"
                    />

                    <span v-else>
                            {{getProject.users.find(e=> e.role.id == x.id).percent}}%
                    </span>
                </v-col>
            </v-row>
           

        </template>
        <template #rightcol>            
        <SelectUserMenu
            v-if="show"
            :mod='x.id'
            :addtext="respons(x.id)==0?'Добавить':'Изменить'"
        />
        </template>
        </row-pirow>    

    </div>

</template>
      
<script>
import rowPirow from '@/components/carddetails/pattern/row-pirow.vue';
import ui from '../users-initialization.js'
import SelectUserMenu from '@/components/UI/SelectUserMenu.vue'
import { createNamespacedHelpers } from "vuex";

const projectstate = createNamespacedHelpers("projectstate");
export default {

    name: "rolesSingle",

    mixins:[ui],

    props: {
        show: {
            type: Boolean,
            default: false
        }
    },

    data:() => ({
       
      
        input:0,
        percentrule: {
            minmax: value => value > 0 &&  value <= 100 
           
        }
    }),

    components: {
        rowPirow,
        SelectUserMenu
    },

   
    computed: {

        ...projectstate.mapGetters(["getProject"]),

        roleusers() {
            let allrole = this.$store.getters['filterslogic/mult/mult_role']
            let without = allrole.filter(t=>t.id <5)
            console.log(allrole, 'without---------------');
            return without
        },

          
       
    },

    methods: {
        ...projectstate.mapMutations(["setProjectUserPercent"]),
        perce(val) {
           
            this.setProjectUserPercent({id:this.input, percent:val})
          
        }
    },

  



}
</script>

<style>

</style>