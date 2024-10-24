export default  {
  // Функции для компонентов work, task, project, Assigment
    title:"wtaps",

    data: () => ({
      show_info: true,
    }),

    methods:{
        
        deletefile(file){          
            if (file.length>0) {
                    file.forEach(el=> {                     
                      this.ws.send({"action":"deletefile","payload":{id:el.id,filepath:el.filepath}})
                    }
                    )
            }
            else {
              
              this.ws.send({"action":"deletefile","payload":{id:file.id,filepath:file.filepath}})
            }
        },

        allCard() {
          this.show_info = !this.show_info
          this.chatview = this.show_info
        },

    }
}