<template>
<div>
    <v-row class="flex-grow-0 pb-1"
    :class="roles==5?' mt-0':' mt-3'"
    >
        <v-col
            xl=4
            lg=4
            md=6
            sm=6,
            cols=6
            class="align-self-center py-1"
        >
            <strong>
                {{nameroles}}
            </strong> 
            </v-col>
            <v-col
                class="pb-1 pt-0 text-nowrap flex-grow-1 flex-col"
                v-if="exhibitor(roles).length>0"
            >
                <v-row
                    class="mt-0"
                    v-for="x in exhibitor(roles)"
                    :key= x.id
                >
                    <v-col
                        lg=8
                        class="card-text   pt-2 pb-1"
                    >
                        <span
                            class="pointer"
                            @click="$emit('showuserinfo', x.user.id)"
                        >
                            {{searchUserFullName(x.user.id, allpersons)}}
                        </span>
                    </v-col>
                    <v-col
                        lg=1
                        class="pa-0 pt-2"
                        
                    >
                        <v-text-field
                            class="mt-n1 text-last-center"
                            dense
                            v-if="show"
                            type="number"
                            :value="getProject.users.find(e=> e.role.id == roles && e.user.id == x.user.id).percent"
                            @input="perce"
                            @focus="input=x.user.id"
                            :rules="[percentrule.minmax]"
                        />
                        <span v-else>
                            {{getProject.users.find(e=> e.role.id == roles && e.user.id == x.user.id).percent}}%
                        </span>
                    </v-col>
                </v-row>             
            </v-col>
            <v-col
                class="flex-grow-1 text-nowrap"
               
                v-else
            >
                Не назначены
            </v-col>
            <v-col
                
                class="text-nowrap  py-1 flex-grow-0 flex-row align-self-center justify-content-end"
            >
            <SelectUserMenu
                v-if="show"
                :mod="roles"
                :addtext="exhibitor(roles).length==0?'Добавить':'Изменить'"
            />
        </v-col>
        
    </v-row>
</div>
</template>

<script>
import ui from '../users-initialization.js'
import uf from '@/utils/universal_functions'
import SelectUserMenu from '@/components/UI/SelectUserMenu.vue'
import { createNamespacedHelpers } from "vuex";

const projectstate = createNamespacedHelpers("projectstate");
export default {
    name: "rolesMany",

    mixins:[ui, uf],

    props: {
        roles: {
            type: Number,
            default: 6
        },

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
        SelectUserMenu
    },

    computed: {
        ...projectstate.mapGetters(["getProject"]),

        nameroles() {
            if (this.roles == 5) {
                 return this.exhibitor(this.roles).length==1?'Участник:':'Участники:'
            }
            if (this.roles == 6) {
                 return this.exhibitor(this.roles).length==1?'Наблюдатель:':'Наблюдатели:'
            }            
           
        }
    },

      methods: {
        ...projectstate.mapMutations(["setProjectUserPercentId"]),
        
        perce(val) {
           
            this.setProjectUserPercentId({id:this.input, percent:val, role:this.roles})
          
        }
    },
    
}
</script>

<style>

</style>