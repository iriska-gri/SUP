
export default {
    namespaced: true,
    state: {
    Works: {
        id:0,
        responsible:{id:0},
        datestart:'',
        dateend:'',
        status:{id:0,name:""},
        work_assignment:[{status:{id:0}}],
        history:[],
        difficult:3,
        longname:"",
        name:""

    },
    
      
    },
   

    getters:{
        getworkidname(state){            
            return {id: state.Works.id, 
                    name: state.Works.name===null?null: state.Works.name,                    
                    resp: state.Works.responsible===null?null:state.Works.responsible.id,
                    
                }
        },
        getWorkdatestart(state){           
            return state.Works.datestart
        },

        getWorkdateend(state){          
            return state.Works.dateend
        },

        getworks(state){
            return state.Works
        },

        getWorksusers(state){
            return state.Works.users
        },

        getWorksdirector(state){
            return state.Works.director
        },
        
        getWorksrp(state){
            return state.Works.rp
        },

        getWorkscoordinator(state){
            return state.Works.coordinator
        },

        getWorkssecretary(state){
            return state.Works.secretary
        },

        // getWorksuniqueusers(state){
        //     let a =[...state.Works.users,state.Works.director,state.Works.coordinator,state.Works.rp,state.Works.secretary]
        //     let b = []
        //     a.forEach(el=> {if( (el!=undefined && b.findIndex(e=>el.id===e.id)==-1))b.push({id:el.id, text:el.fullname})})
        //     return b
        // }

    },

    mutations: {
       
        setWorks(state, Works){
            state.Works = Works
        },
        setworksname(state,value){
            state.Works.name = value
        },
        setworksresponsible(state,value){
            state.Works.responsible = value},
        setWorkdatestart(state, value){           
            state.Works.datestart = value
          
        },
        setworksdescription(state, value){  
            state.Works.description =  value},
        
        setWorkdateend(state, value){  
            state.Works.dateend =  value
        },
   
    setworkslongname(state,value){
        state.Works.longname = value
    },
    setworksdifficult(state,value){
        state.Works.difficult = value
    },


    }
}