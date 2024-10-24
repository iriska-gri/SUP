import axios from "axios";

const URL = process.env.NODE_ENV == 'development'? '127.0.0.1:8000': '10.252.44.60:8500';
// '127.0.0.1:8000': '10.252.44.28';
// '172.16.200.33:8000':'10.252.44.28'

const baseURL = `http://${URL}/api/`;
const wsURL = `ws://${URL}/ws`

const axiosClear = axios.create({
  baseURL,
  withCredentials: true,
  headers: {
    "Content-Type": "application/json",
  },
});
const axiosMp = axios.create({
  baseURL,
  withCredentials: true,
  headers: {
    'Content-Type': 'multipart/form-data'
    // "Authorization": store.getters("/auth/access")
  },
});

const axiosInstance = axios.create({
    baseURL,
    withCredentials: true,
    headers: {
      "Content-Type": "application/json",
      // "Authorization": store.getters("/auth/access")
    },
});

function logout(store) {
  localStorage.removeItem("status_login");
  store.commit("auth/removeToken");
  window.location.href = '/';
}

async function updateToken(store, cb=null) {
    let refresh = localStorage.getItem("refresh_token");      
    

  try {            
    const rs = await axiosClear.post("/auth/refresh",{},{headers:{"Authorization":'Bearer '+refresh}});
    
    const access_token  = rs.data.access_token;

    store.commit("auth/setToken", access_token);
    

    return cb? cb(): Promise.resolve();

  } catch (_error) {
    

   
    return Promise.reject(_error);
  }
   
}

function syncUpdateToken(store) {
  let refresh = localStorage.getItem("refresh_token");   
  return new Promise((resolve, reject) => {
    
    axiosClear.post("/auth/refresh",{},{headers:{"Authorization":'Bearer '+refresh}})
    .then((data) => {
      store.commit("auth/setToken", data.data.access_token);
      resolve();
    })
    .catch(() => {
      logout(store)
      reject();
    }) 
  })
}

class protectWebsocket {

  constructor(store) {
    this.url = wsURL;
    this.conn = null;
    this.events = {};
    this._retry = false;
  
  }

  start(url=null) {

    if (url) this.url = wsURL + url;  
    
    this.conn = new WebSocket(this.url + `?token=${this.store.getters["auth/getToken"]}`);
    
    for (let [name, func] of Object.entries(this.events)) {
      this.conn[name] = func;
    }

    this.conn.onopen = () => {
      console.log("Соединение WS открыто", this.url);
    }

    this.conn.onclose = async (event) => {
        console.log(event.code, "EVENT CODE",this.url);
      if (event.code == 1008 && !this._retry) {
        this._retry = !this._retry;
        
        await updateToken(this.store).then(() => {
          
          this.start();
        })
      } 
      if (event.code==1000 && this._retry){
        this.start()
      }
      console.log("Соединение WS закрыто", this.url);
      
    }
    this.conn.onerror=async (event)=>{
      console.log("ERROR");
    }
  }

  stop() {
    this.conn.close();
  }

  addEvent(name, func) {
    this.events[name] = func;
    this.conn[name] = func;
  }
  send(data){
    this.conn.send(JSON.stringify(data))
  }
}

export {axiosClear, axiosInstance,axiosMp, URL, wsURL, updateToken, protectWebsocket, syncUpdateToken, logout};