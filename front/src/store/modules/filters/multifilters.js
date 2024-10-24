import moment from "moment";
export default {
  namespaced: true,
  state: {
    // Фильтры
    project__status:[],
    mult_project__status:[],
    role:[],
    mult_role:[],
    task__status:[],
    mult_task__status:[],
    work__status:[],
    mult_work__status:[],
    assignment__status:[],
    mult_assignment__status:[],
    project__type:[],
    mult_project__type:[]
  },
  getters: {
    // Геттеры фильтров
    user_project__role(state){
      return state.role
    },
    mult_user_project__role(state){
      return state.mult_role
    },
    project__type(state){
      return state.project__type
    },
    mult_project__type(state){
      return state.mult_project__type
    },


    role(state){
      return state.role
    },
    mult_role(state){
      return state.mult_role
    },

    status(state) {      
      return state.project__status;
    },
    
    mult_status(state) {   
      return state.mult_project__status
    },
    mult_task__status(state) {   
      return state.mult_task__status
    },
    work__status(state) {   
      return state.work__status
    },
    mult_work__status(state) {   
      return state.mult_work__status
    },
    task__status(state) {   
      return state.task__status
    },
    assignment__status(state){
      return state.assignment__status
    },
    mult_assignment__status(state){
      return state.mult_assignment__status
    }
    
  },
  mutations: {
    addFilter(state, { key, value }) {
      state[key] = value;
    }
  },
  actions: {
    addFilter({state, commit, rootState}, { key, value }) {
      // Добавляет фильтр в хранилище
      
      commit('addFilter', {key, value})    
      if (key.slice(0, 4) != "mult") {
        if (value.length == 0) {          
          delete rootState.filterslogic.activefilters[key];
          return;
        }
        
        rootState.filterslogic.activefilters[key] = {value, postfix: '__in', module: 'mult'};
        
      }
      
    
      
    },
  }
};