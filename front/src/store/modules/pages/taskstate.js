
export default {
    namespaced: true,
    state: {
    tasks: {
        id:0,
        responsible:{},
        datestart:'',
        dateend:'',
        status:{id:0,name:""},
        history:[],
        name:"",
        longname:"",
        difficult:0
    },
    
      
    },

    getters:{
        getTaskdatestart(state){           
            return state.tasks.datestart
        },

        getTaskdateend(state){          
            return state.tasks.dateend
        },

        gettasks(state){
            return state.tasks
        },

        gettasksusers(state){
            return state.tasks.users
        },

        gettasksdirector(state){
            return state.tasks.director
        },
        
        gettasksrp(state){
            return state.tasks.rp
        },

        gettaskscoordinator(state){
            return state.tasks.coordinator
        },

        gettaskssecretary(state){
            return state.tasks.secretary
        },

        gettasksuniqueusers(state){
            let a =[...state.tasks.users,state.tasks.director,state.tasks.coordinator,state.tasks.rp,state.tasks.secretary]
            let b = []
            a.forEach(el=> {if( (el!=undefined && b.findIndex(e=>el.id===e.id)==-1))b.push({id:el.id, text:el.fullname})})
            return b
        }

    },

    mutations: {
        settasks(state, tasks){
            state.tasks = tasks
        },
        settasksname(state,value){
            state.tasks.name = value
        },
        settaskslongname(state,value){
            state.tasks.longname = value
        },
        settasksdifficult(state,value){
            state.tasks.difficult = value
        },
        settasksresponsible(state,value){
            state.tasks.responsible = value},

        setTaskdatestart(state, value){           
            state.tasks.datestart = value
          
        },
        settasksdescription(state, value){  
            state.tasks.description =  value},
        
        setTaskdateend(state, value){  
            state.tasks.dateend =  value
        }

    }
}