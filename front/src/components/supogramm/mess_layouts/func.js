export default  {

    title:"func",

    methods:{

      chatTitle(mychat) {

        if(mychat.name != null){
          return mychat.name
        }
        else {
          let nam = ''
          mychat.users.forEach(el => {
          if(el.id != this.getUser.id){
              let snn = el.givenName.split(' ')
              nam = el.sn + ' ' + snn[0][0] + '.'
          }
          })
          return nam
        }
      },

      getName(mychat) {

        let splitted = mychat.split(' ')
        let i=0
        let shn=''
        while (i<2 && i<splitted.length) {
                shn += splitted[i][0].toUpperCase()
                i++
        }
        return shn
      },

      lightdark(lvl ,tema) {
          
          let coloricons = {
              1: {dark: "grinblack", light: "grinlight"},
              2: {dark: "auchdark", light: "auchlight"},
              3: {dark: "auchdark", light: "auchlight"},
              4: {dark: "reddark", light: "redlight"},
              null : {dark: "pinksdark", light: "pinkslight"}
          }
              return coloricons[lvl][tema?'dark':'light']
        },


    }
}