
export default {
    namespaced: true,
    state: {
        Assignment: {
        id:0,
        responsible:{},
        datestart:'',
        dateend:'',
        name:"",
        longname:"",
        difficult:3,
        description:"",
        history:[]

    },
    
      
    },

    getters:{
        getAssignmentdatestart(state){           
            return state.Assignment.datestart
        },

        getAssignmentdateend(state){          
            return state.Assignment.dateend
        },

        getAssignments(state){
            return state.Assignment
        },

        getAssignmentsusers(state){
            return state.Assignment.responsible
        },

     
    },

    mutations: {
        setAssignments(state, Assignment){
            state.Assignment = Assignment
        },
        setAssignmentname(state,value){
            state.Assignment.name = value
        },
        setAssignmentresponsible(state,value){
            state.Assignment.responsible = value},
        setAssignmentdatestart(state, value){           
            state.Assignment.datestart = value
          
        },
        setAssignmentdescript(state,value){
            state.Assignment.description =  value
        },
        
        setAssignmentdateend(state, value){  
            state.Assignment.dateend =  value
        }

    }
}