import moment from "moment";

export  default  {

  title:"gantff",

  methods:{

    date_watch(date_s, date_e){           
      let dates = [ {}, {text:'days',num:14}, {text:'weeks',num:84}, {text:'months',num:500}, {text:'quarters',num:1260},{text:'years',num:99999999999999}, ]                   
      let days_diff = Math.ceil(Math.abs(new Date(date_s).getTime() - new Date(date_e).getTime())/86400000)            
    for (let i=0; i<dates.length; i++){
      if(days_diff <= dates[i].num){         
        return dates[i-1].text}
    }
  },
  changeddialog(val){
   
    this.dialoginfo= val
   },

   rebuild(){
    setTimeout( this.reb,5);

 },  
 
 reb(){
   this.gantt.repaint()       
 },
 stype_starter() {    
  return  this.date_watch(this.getTaskdatestart(), this.getTaskdateend(), this.$refs.ganttRef)  
},

onSelectionChanged(e) {   
        
  this.disableContextMenu= e.selectedRowKey!='p-0'?false:true},
  onContextMenuPreparing(e) {
      
    if (e.targetKey!=undefined && e.targetKey.split('-')[0]!='parent'){
      let tel = this.tasks.find(el=>el.id==e.targetKey)        
      let u = this.resourceAssignments.find(el=>el.taskId==tel.id)
      if ([1,3].includes(tel.status.id)|| this.resources.findIndex(e=>e.id==u.resourceId)==-1){
      this.contextMenuItems = this.getContextMenuItems(e.targetKey.split('-')[0])
            e.cancel = this.disableContextMenu
            this.selectedkey= e.data   

      }else{e.cancel=true }
     
   
    } else{e.cancel=true }

  },
  onPreventContextMenuShowing(e) {
     
    this.disableContextMenu = e.value;
  },
  onCustomCommandClick(e) {   
    this[e.name]()  
  },
  
  getContextMenuItems(type){
    
    return this[type]
},
saveit(){   
        
console.log(this.dialoginfo,"dialoginfo");
  this.$emit('saver',{am:this.actionmethod, val:this.dialoginfo})
  
  this.dialog=false
  this.deldialog=false
},

topline(idname,datestart, dateend){
    
  let {name:title, id:id, resp:resp, parentId, start, end, }={...idname, parentId:0, start: new Date(datestart), end: new Date(dateend)}
      let parent=Object.assign({},{title,id, parentId, start,end,resp})      
      parent.id= `parent-${parent.id}`
  console.log(parent);
      return parent
 },




  }
}