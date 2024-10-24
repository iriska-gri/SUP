

import moment from "moment";
import { axiosInstance } from '@/utils/api'
export  default  {

  title:"uf",

  data() {
    return {
        pers: ''
    }
  },

  methods:{
    finishdate(id, level){
      let inst = level==2?'task':'work'
      let ob = this.getProject.history.find(e=>e.action.id== 4 && e.level==level && e[inst]==id && e.info.status.id==5 )
      // return ob.creratedate
      return this.momentext(ob.createdate,"DD.MM.YYYY")
  },  
    momentext (value, format='DD MMMM YYYY') {
      if (value) {
          return moment(value).locale('Ru').format(format)
      }
    },
    
    error(ob, fiel) {
      let errors = []
       for (let [key, val] of Object.entries(this.$v[ob][fiel]))
       { 
      
          if (key[0] != '$' && !val) {
              errors.push(this.errortext[fiel][key])
                 
       }
             
       } 
  
      return errors
  },
  getPersonShortFromId(it){
    console.log(it);
    try{
    let person= this.getProject.users.find(el => el.user.id==it);
    let init = person.user.givenName.split(" ")
    return `${person.user.sn} ${init[0][0]}.${init[1][0]}.` 
    }
    catch{
      return "Не назначен"
    }
  },

      filename(file){
        let fn = file.split("/")
        fn=fn[fn.length-1].split('.')
        fn.shift()
        return fn.join('.')
    },

      // currentDay(val) {
      //   return moment(val).locale("Ru").format("DD-MM-YYYY")
      // },
      // currentDaytvo(val) {
      //   return moment(val).locale("Ru").format("YYYY-MM-DD")
      // },
      // currentDayComa(val) {
      //   return moment(val).locale("Ru").format("DD.MM.YYYY")
      // },
      momentedtime(val){
          return moment(val).locale("Ru").format("HH:mm DD MMMM YYYY")
      },

      momentedDay(val){
          return moment(val).locale("Ru").format("DD MMMM YYYY")
      },


      getDate(date) {
          return moment(date).locale('ru').format('LT')
      }, 
      textdays(int){       
        let subint= Math.abs(int)>100?  Math.abs(int)% Number(String(Math.abs(int)).split("").slice(1).map((e,index)=> e=index==0?  1:0).join("")): Math.abs(int)
        let nint = Math.abs(subint)%10       
        if (![11,12,13,14].includes(Math.abs(subint))){     
        if ([2, 3, 4].includes(nint)) {
          return `${Math.abs(int)} дня`
        }
        else if (nint==1){
          return `${Math.abs(int)} день`
        }
      }
        return `${Math.abs(int)} дней`

      },

      timediff(date){
        let today =  new Date().setHours(0,0,0,0);        
        let days = moment(date).diff(today, 'days')
        let text= 'срок сегодня'
        if (days<0) 
              {
                text = `просрочено на ${this.textdays(days)}`
              }
        else if (days>0){
              text = `до срока ${this.textdays(days)}`
        }
        return text
     
      }, 

      userclicked(user){
        axiosInstance.get( `/user/${user}`)     
            .then(res => 
                this.pers = res.data.fullname )
      return this.pers
      },

      reName(user) {
        try{
          
        // this.userclicked(user)
        let sn = user.givenName.split(' ')
        return user.sn + ' ' + sn[0][0] + '.' + sn[1][0]+ '.'
        }
        catch{return "Нет ничего"}
      },

      searchUserFullName(id, fromarr){
            let fn= fromarr.find(el=>el.user.id==id)   
  
        return fn!=undefined && "fullname" in fn.user? fn.user.fullname:"Не назначен"
      },

      searchUser(id, fromarr){
        let fn= fromarr.find(el=>el.user.id==id)       
        return fn!=undefined ? fn.user:{}
      },

      // Круговая диаграмма
      pie_statuses_calc(arr){  
        let total = arr.length
        let oneinperc = 100/total;
        let result = []
        arr.forEach((e)=>{
          let ind = result.findIndex(el=>el.title==e.status.name)
          if (ind==-1){
            result.push({title:e.status.name, percent: Number(oneinperc.toFixed(1))})
          }else{
            result[ind].percent += Number(oneinperc.toFixed(1))
          }
        } )
      return result
      },

      calcdays(datestart, dateend, status, priost, end){
        let totald = moment(dateend).diff(moment(datestart),"days")
        let today = moment().diff(moment(datestart),"days") 
        let res= {progress:100*today/totald, fifteen:Math.round(totald *0.15)}
        res.color = this.calccolor(res.progress, status, priost, end )
        return res
      },

      calccolor(totheend, status, priost, end){
        try{
       
           if(status.id==priost){
          return "prliniarstop"
        }
        else if (status.id!=end){
          if (totheend>=100)
            {return "prliniar100"}
          else if(totheend>=85){
            return "prliniar85"
          }
          else{
            return "prliniarelse"
          }
        }
        else{
          return ""
        }
      }catch{return ""}
    }

    },



}
