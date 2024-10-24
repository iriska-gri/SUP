import jwt_decode from "jwt-decode";

export default {
  namespaced: true,
  state: {
    token: "",
    user: "",
    statusReg: false
  },

  getters: {
    getToken(state) {      
      return state.token
    },
    getUser(state) {
      console.log("Пользователь", state.user);
      return state.user
      // JSON.parse(localStorage.getItem('user'))
    },
    // getDrawUser(state) {
    //   console.log(state.user,"STATEUSER");
    //   let user = state.user
    //   // JSON.parse(localStorage.getItem('user'))
    //   return { 
        
    //     initial: `${user.sn} ${user.givenName}`,
    //     otdel: "name" in user.otdel? user.otdel.name: ""
    //   }
    // },

    getStatusReg(state) {
      return state.statusReg 
    },

    getSuperUser(state) {
      return state.superuser 
      // JSON.parse(localStorage.getItem('user')).superuser
    }
  },
  mutations: {

    setStatusReg(state, statusReg) {
      state.statusReg = statusReg;
    },

    setToken(state, token) {
        state.token = token;
        state.user = jwt_decode(token).user
        
        // localStorage.setItem('token',JSON.stringify(token))
        // console.log("Токен установлен");
        // localStorage.setItem('user', JSON.stringify(jwt_decode(token).user))
    },
    removeToken(state) {
      state.token = '';
      // localStorage.removeItem('token')
    }
  },
};
