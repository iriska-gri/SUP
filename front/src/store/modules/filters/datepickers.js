export default {
    namespaced: true,
    state: {
      // Фильтры
      dateend__lte: "",
      dateend__gte:"",
      datestart__lte:"",
      datestart__gte:""
    },
    getters: {
      // Геттеры фильтров
      dateend__lte(state) {
        
        return state.dateend__lte;
      },
      dateend__gte(state) {
        
        return state.dateend__gte;
      },
      datestart__lte(state) {
        
        return state.datestart__lte;
      },
      datestart__gte(state) {
        
        return state.datestart__gte;
      },
 
     
     
  
    },
    mutations: {
      addFilter(state, { key, value }) {
        state[key] = value;
      },
    },
    actions: {
      addFilter({ state, commit, rootState }, { key, value }) {
        // Добавляет фильтр в хранилище
  
        commit("addFilter", { key, value });
  
        if ( ["", null].includes(value)) {
          delete rootState.filterslogic.activefilters[key];
          return;
        }
        rootState.filterslogic.activefilters[key] = { value, postfix: "", module: 'datepicker', correct:value };
      },
    }
  };