export default {
  namespaced: true,
  state: {
    // Фильтры
    project__name: "",
    name:"",
    user_project__user__sn:"",
    responsible__sn:""
  
  },
  getters: {
    // Геттеры фильтров
    project__name(state) {
      
      return state.project__name;
    },
    name(state) {
      
      return state.name;
    },
    user_project__user__sn(state){
      return state.user_project__user__sn
    },
    responsible__sn(state){
      return state.responsible__sn
    }

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
      rootState.filterslogic.activefilters[key] = { value, postfix: "__startswith", module: 'input', correct:value };
    },
  }
};
