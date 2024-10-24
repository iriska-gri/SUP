import Vue from 'vue';
import Vuex from 'vuex';
import authModule from '@/store/modules/auth';
import {version} from '../../package'
import filterslogic from "@/store/modules/filters/filterslogic";
import projectstate from "@/store/modules/pages/projectstate";
import taskstate from "@/store/modules/pages/taskstate";
import workstate from "@/store/modules/pages/workstate";
import assignmentstate from "@/store/modules/pages/assignmentstate";
import globalstore  from "@/store/modules/globalstore"
Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    appVersion: version || '0',
    // menulevel: ""
  },
  mutations: {
  },
  getters: {
    appVersion: (state) => {       
      return state.appVersion
    }, 
    // menulevel(state){return state.menulevel
    // }
  },
  actions: {
  },
  modules: {
    globalstore:globalstore,
    auth: authModule,
    filterslogic:filterslogic,
    projectstate:projectstate,
    taskstate:taskstate,
    workstate:workstate,
    assignmentstate:assignmentstate
    
  }
})
