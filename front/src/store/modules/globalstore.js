
export default {
    namespaced: true,
    state: {
    loading:false,
    assignid: null
    },

    getters:{
        getLoad(state) {      
            return state.loading
          },
        getassign_id(state){
          return state.assignid
        }
    },
    mutations: {
        setLoad(state, loading) {
          state.loading = loading;
        },
        set_assign_id(state,val){
          
          state.assignid = val
        }
    }
}    