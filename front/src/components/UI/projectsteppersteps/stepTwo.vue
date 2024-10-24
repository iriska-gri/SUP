 <template>
            

              <v-form  ref="form" class="pa-3 pt-0 flex-grow-1 flex-col  overflow-x-hidden stepper" 
                                           
                                                >
            <v-row class="mb-2 mt-0  flex-grow-0 font-weight-bold text-overline main_theme">
                <v-col lg=4 class="py-0" >Роли</v-col>
                <v-col lg=4 class="py-0">Сотрудники</v-col>
                <v-col class="py-0">Процент занятости</v-col>
                <v-col class="text-end py-0">Добавить/удалить</v-col>
            </v-row>
             <v-divider class="mb-3 mt-1"/>
            <roles-single
             
                :show= true
                @showuserinfo="showuserinfo"
              
            />
            <v-divider class="my-2"/>
            <roles-many
                :roles="5"
                :show="true"
                @showuserinfo="showuserinfo"
            />
             <v-divider class="mt-5"/>
            <roles-many
                :show="true"
                @showuserinfo="showuserinfo"
            />
            <v-divider class="mt-5"/>
          
        
              </v-form>
</template>

<script>
import RolesSingle from '@/components/assignments/UI/roles-single.vue';
import rolesMany from '@/components/assignments/UI/roles-many.vue';
export default {
    name:"step-two",
    components: { RolesSingle, rolesMany},
    props:{
        newproject:{type:Object, 
                    default:()=>{}}
    },
    methods:{
        showuserinfo(id){
        this.$emit("showuserinfo",id)
    },

    }

}
</script>

<style>

</style>