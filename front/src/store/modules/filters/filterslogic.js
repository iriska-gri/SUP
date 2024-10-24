import {axiosInstance} from "@/utils/api";
import multifilters from "@/store/modules/filters/multifilters";
import inputfilters from "@/store/modules/filters/inputfilters";
import datepickers from "@/store/modules/filters/datepickers";

export default {
    namespaced: true,
    state: {
      // Служебные
      activefilters: {}, 
      fieldsfilter:{}    
     
    },

    mutations: {
      clear_select(state, key){
        state.select[key] = '';
        delete state.activefilters[key]
        
      },
      
      setFields(state, fieldsfilter) {  
      
        state.fieldsfilter = fieldsfilter;
       
      
      },
      setIncludeFilters(state, value) {      
        state.includeFilters = value;
      },
      filtersClear(state) {           
        state.activefilters = {};
        
      },
      clear_mult(state, key) {
        state.mult[key] = [];
        delete state.activefilters[key]
      },
      clear_datepicker(state, key){
        state.datepicker[key] = "";
        delete state.activefilters[key]
      },
      clear_input(state, key) {
        state.input[key] = "";
        delete state.activefilters[key]
      },
      clear_chain(state, key) {
        const type = key.slice(-5);
        if (state.interpritateChain[type]) {
          let field = key.slice(0, -5);
          if (!state.includeFilters.includes(field)) {
            state.chain[`${state.interpritateChain[type]}${field}`] = "";
            delete state.activefilters[key];
          }
          
        } else {
          if (!state.includeFilters.includes(key)) {
            state.chain[`with_${key}`] = "";
            state.chain[`by_${key}`] = "";
            delete state.activefilters[key];
          }
        }
      },
    },
    actions: {
      cleartypeerror({ state, commit }){
        commit(`clear_select`, 'type_error');
      },
   
      clear({ state, commit }) {
       
        for (let [key, { module } = val] of Object.entries(state.activefilters)) {
          
          commit(`clear_${module}`, key);
        }
      },
  
      async addFilter({ dispatch, state }, { key, value }) {
       
        await dispatch(`${state.fieldsfilter[key].module}/addFilter`, { key, value });
      },
  
      async addDate({dispatch}, {value, period, field}) {
        const arr = ['with', 'by'];
        value.forEach((date, index) => {
          dispatch('chain/addDate', {key: `${arr[index]}_${field}`, value: date, period, field, type: arr[index]})
        })
        
      },
      
  
  
  
      async getFilters({ state }, settingsFilt, role=false) {
         try {
          console.log(state, settingsFilt, role, "roooooole");
          const res = await axiosInstance.post(
            "/filters/",
            settingsFilt
          );
            if(role){
              console.log(res,"reeees");
            }
          for (let [key, val] of Object.entries(res.data)) {
            console.log(key,val);
            state[state.fieldsfilter[key].module][`mult_${key}`] = val;
           
          }
        

             
          
          return res.data;
        } catch (e) {
          console.log(e,"xcxxccxxcx");
          return e;
        }
      },

      activefilters({ state }, includesField = []) {
        
        const obj = {};
        for (let [key, item] of Object.entries(state.activefilters)) {   
                           
            obj[`${key}${item.postfix}`] = item.value
        }
    
        return obj;
      },
    },
  
    modules: {
      mult: multifilters,
      input: inputfilters,
      datepicker: datepickers
    //   chain: chainfilters,
    //   select: selectfilters,
  
    },
  };
  