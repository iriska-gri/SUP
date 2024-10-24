export default {
    namespaced: true,
    state: {
    project:   {
        longname: '',
        name: '',
        difficult:0,
        ptype: { "id": 2 },
        project_checkpoint:  [],
        info:{
          financial_support:"",
          project_sphere:"",
          passport_last_date:"",
          influence: "",
          grounds: '',
          target:[],
          result:[],
          criteria:[],
          risks:[],
          interactions:[],
          dop_info: '',
          docnumber:"",
          
        },

        users:[{id:0, role:{id:0}, user:{id:0, fullname:''}, percent: 0} ],
        status:{id:0},
      
        
        id:0,
        datestart: "",
        dateend: "",
        history:[],
        difficult:0,
        
       
        tasks:[]
      }
      
    },

    getters:{

        getprojectIdName(state){
            
            return {id: state.project.id, 
                    name: state.project.name===null?null: state.project.name,
                    resp: "users" in state.project && state.project.users.length?state.project.users.find(e=>e.role.id==2).user.id:null}
        },
        allpersons(state){
          
            return [...state.project.users]
        },
        getProjectdatestart(state){
           
            return state.project.datestart
        },
        getProjectdateend(state){
            
            return state.project.dateend
        },
        getProject(state){
            return state.project
        },
        // getProjectfordock(state){            
        //     let ob = Object.assign({},state.project)
        //     Object.keys(ob).forEach(n => ['history',"project_files"].includes(n) && delete ob[n])
        //     return ob
        // },
        getProjectusers(state){
            return state.project.users.filter(e=>e.role.id==5)
        },
         getProjectwatchers(state){
            return state.project.users.filter(e=>e.role.id==6)
        },
        getProjectdirector(state){
            return state.project.users.find(e=>e.role.id==1).user
        },
        getProjectrp(state){
            // console.log(state.project.users);
            return state.project.users.length? state.project.users.find(e=>e.role.id==2).user:{id:0}
        },
        getProjectcoordinator(state){
            return state.project.users.find(e=>e.role.id==4).user
        },
        getProjectsecretary(state){
            return state.project.users.find(e=>e.role.id==3).user
        },
        getprojectTasks(state){
            return state.project.tasks
        },

        getprojectWorks(state){            
            let works = []
            state.project.tasks.forEach(e=> works= works.concat(e.task_work) )
            return works
        },



        getprojectuniqueusers(state){
            // let a =[...state.project.users]
            let a = []
            let b=[]
            state.project.users.forEach((el=> {if(!b.includes(el.user.id) && el.user.id!=0){
                            a.push({id:el.user.id, text:el.user.fullname, role:el.role})
                            b.push(el.user.id)    
                            }}
            ))
            // a.forEach(el=> {if( (el!=undefined && b.findIndex(e=>el.id===e.id)==-1))b.push({id:el.id, text:el.fullname})})
            return a
        },

        getprojectuniquePersons(state){
            let a =[...state.project.users]
            let b = []
            a.forEach(el=> {if( (el!=undefined && b.findIndex(e=>el.user.id===e.id)==-1))b.push(el.user)})
            return b
        },

        
    },

    mutations: {

        setProject(state, project){
            state.project = project
        },
        setProjectname(state, name){
            state.project.name = name
        },
        setProjectusers(state, users){
            state.project.users = users
        },

        setProjectType(state, type) {
            state.project.ptype = type
        },

        setProjectStatus(state, status) {
            state.project.status = status
        },

        setProjectUserPercent(state, value){
            
            state.project.users.find(e=>e.role.id==value.id).percent=value.percent

        
        },

        setProjectUserPercentId(state, value)
        {
            state.project.users.find(e=>e.user.id==value.id && e.role.id == value.role).percent=value.percent

        },

        clearProject(state)
        {
            state.project = 
            {
                longname: '',
                name: '',
                difficult:0,
                ptype: { "id": 2 },
                project_checkpoint:  [],
                info:{
                  financial_support:"",
                  project_sphere:"",
                  passport_last_date:"",
                  influence: "",
                  grounds: '',
                  target:[],
                  result:[],
                  criteria:[],
                  risks:[],
                  interactions:[],
                  dop_info: '',
                  docnumber:"",
                },
                users:[{id:0, role:{id:0}, user:{id:0, fullname:''}, percent: 0} ],
                status:{id:0},

                id:0,
                datestart: "",
                dateend: "",
                history:[],
                difficult:0,
                tasks:[{task_work:[],status:{id:0},responsible:{sn:""}}]
              }
        },
        // setProjectdirector(state,user){
        //     state.project.director = user
        // },
        // setProjectcoordinator(state,user){
        //     state.project.coordinator = user
        // },
        // setProjectsecretary(state,user){
        //     state.project.secretary = user
        // },
        // setProjectrp(state,user){
        //     state.project.rp = user
        // },
        setProjectdatestart(state, value){           
            state.project.datestart = value
          
        },
        
        setProjectdateend(state, value){  
            state.project.dateend =  value
        }

    }
}