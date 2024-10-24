  <template>
  <v-form  ref="form" class="pa-3 pt-0 flex-grow-1 flex-col  overflow-auto overflow-x-hidden stepper" 
                                           
                                                >
            <exp-panel
                :completion="true"
                :addremrow="addremrow"
                :newproject="newproject"
                @remove="remove"
                @addRows="addRows"
            />

    

  </v-form>
</template>  

<script>
import ExpPanel from '@/components/assignments/UI/exp-panel.vue';
export default {
    name:"step-three",
    components: { ExpPanel },
    props:{
        newproject:{type:Object, 
                    default:()=>{}}
    },

    data:()=>({
        addremrow: [{field: 'target', text: "Цель (цели) проекта"},
                {field: 'result', text: "Результат (результаты) проекта"},
                {field: 'criteria', text: "Критерии успеха проекта"},
                {field: 'risks', text: "Риски реализации проекта"},
                {field: 'interactions', text: "Взаимосвязи с другими проектами и программами"},
                ],
    }),


    methods:{
            addRows(row) {     
            this.newproject.info[row].push('')
            },
            remove(rem) {
                this.newproject.info[rem.field].splice(rem.key, 1)
            },






    }
}
</script>

<style>

</style>