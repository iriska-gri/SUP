<template>
  <v-app> 
    <v-navigation-drawer
      app
      stateless
      v-model="drawer"
      :mini-variant="mini"
      width="190"          
      color="main_theme"
    >
<!-- название сайта начало -->
      
      <namePrograms
        @minis="minis"
        :mini="mini"
      />
      <v-divider></v-divider>
      <navigationPanel
        :items="items"
        :mini="mini"
        :messengerview="messengerview"
        :messengertotal="messengertotal"
        @messengervi="messengerview=!messengerview"
     
      />

<!-- название сайта конец -->
    </v-navigation-drawer>

    <v-main class="flex-col">
  
     <!-- Центр сайта и выплывающий ватсуп -->
      <v-app-bar
        dense
        flat
        class="main_theme flex-grow-0 "
      >         
              <v-col class="flex-grow-1">
                 <v-row>
                  
                    <template v-for="(value, i) in dateCalendar" >
                      <month
                        :key="i"
                        :class="{ 'month-calendar': value.month }"
                        :value="value"
                      />
                      <v-divider v-if="i<dateCalendar.length-1"
                        :key="'div' + i"
                        vertical
                        inset
                    
                      ></v-divider>
                    </template>
                  </v-row>
              </v-col>
      
          <v-divider
           
            vertical
          />
          <!-- <v-col class="flex-grow-0 px-0">
          
            <MyIco
              @click="closeCalenadar"
              :icons ="calendar?'mdi-chevron-right':'mdi-chevron-left'"
            />
          </v-col> -->
          <!-- <v-divider vertical/> -->
          <!-- </v-app-bar> -->
          
    <div class="flex-row">      
      
      <v-col class="py-0">
        <v-row class="flex-row align-self-center">
      <v-col class="flex-grow-0 mb-0">
        <v-avatar size="45">
          <img
            :alt="getUser.sn"
            :src="'photo'in getUser?getUser.photo:`http://${serverurl}/static/default/avatardef.png`"
          >
        </v-avatar>
      </v-col>
      
      <v-col class="mb-0">

               <div class="subtitle-2">{{ getUser.sn }} {{ getUser.givenName }}</div>                       
                  <div class="caption">{{ getUser.otdel.name }} </div>
         
      </v-col>
        </v-row>
      </v-col>
    <toggle-theme class="align-self-center"/>
      <v-col class="flex-grow-0  align-self-center">
        <MyIco
          @click="logout"
          size="medium"
          icons = 'mdi-logout-variant'
        />
      </v-col>

    </div>
    
      
       
      </v-app-bar>
      <v-container
        fluid
        class="flex-grow-1 flex-col pa-0"
        v-if="loadPage"
      >
        <v-slide-x-transition>
          <v-row
            v-show="messengerview"
            style="position:fixed; z-index:50; top:95px; left: 202px;"
          >
            <v-col class="nl_whatsup">
              <messengerMain
                @totaller="totaller"
                @closesupogramm="messengerview=false"
              />
            </v-col>
          </v-row>
        </v-slide-x-transition>
        <slot />
      </v-container>

    </v-main>
  </v-app>
</template>

<script>
import moment from "moment";
import messengerMain from "@/components/supogramm/messenger-main.vue";
import ToggleTheme from '@/components/UI/ToggleTheme.vue';
import { syncUpdateToken, logout, URL } from "@/utils/api";
import { createNamespacedHelpers } from "vuex";

import namePrograms from './navigation/name-programs.vue';
import month from './calendar/month.vue';
import NavigationPanel from './navigation/navigation-panel.vue';

const { mapGetters } = createNamespacedHelpers("auth");
export default {
      components: {
        ToggleTheme,
        messengerMain,
        namePrograms,
            NavigationPanel,
            month
     },
  data() {
    return {
      calendar:false,
      messengertotal:0,
      serverurl:URL,
      messengerview:false,
      groupexpand:true,
      calendarLength: 7,
      dateCalendar: [],
      dataCalendar: {},
      loadPage: false,
      drawer: true,
      user: {},
      items: [
        {title: "Главная", icon: "mdi-home-variant-outline", link: "/"},
        {
          title: "Проектная деятельность",
            sub: [
            { title: "Проекты и задачи", icon: "fa-list-ol", link: "/projects", sub:
                        [{ title: "Проекты", icon: "mdi-vector-circle", link: "/projects"},
                        { title: "Задачи", icon: "mdi-calendar-edit-outline", link: "/tasks"},
                         { title: "Работы", icon: "mdi-archive-edit", link: "/works"},
                        { title: "Поручения", icon: "mdi-account-arrow-left-outline", link: "/assignments"}
                        
                        
                        ]
                        },
              { title: "Совещания", icon: "mdi-account-group-outline", link: "/events" },
              { title: "Календарь", icon: "mdi-calendar-month-outline", link: "/calendar" },
              {
              title: "Документация",
              icon: "mdi-file-document-multiple-outline",
              link: "/documentation",
              },
              { title: "Компетенции", icon: "mdi-head-check-outline", link: "/competence" },
              { title: "Итерации", icon: "mdi-repeat", link: "/iteration" },
              ]
          
        },
        {
          title: "Статистика и аналитика",
          sub: [
            { title: "Дашборд", icon: "mdi-monitor-dashboard", link: "/dashboard" },
            { title: "Отчеты", icon: "mdi-file-chart-outline ", link: "/raport" },
            { title: "Стратегии", icon: "mdi-chess-queen", link: "/strategy" },
          ],
        },
        // {title:"ВатСУП", icon:"mdi-forum"}
      ],
      mini: false,
    };
  },
  methods: {
    totaller(val){
      this.messengertotal=val
    },
    createCalendar() {
      
      const nowDate = moment(Date.now());
      let month = "";
      for (let i = 0; i < 7; i++) {
        let changeDate = nowDate.clone().add(i, "days");
        if (changeDate.locale("ru").format("MM") != month) {
          month = changeDate.locale("ru").format("MM");
          this.dateCalendar.push({ text: month.toUpperCase(), month: true });
        }
        this.dataCalendar[changeDate.format("YYYY-MM-DD")] = {
          assignment: "",
        };
        this.dateCalendar.push({
          text: `${changeDate
            .locale("ru")
            .format("ddd")
            .toUpperCase()}, ${changeDate.locale("ru").format("DD")}`,
          month: false,
          data: this.dataCalendar[changeDate.format("YYYY-MM-DD")],
        });
      }
      console.log(this.dateCalendar);
    },
    build() {
      this.user = this.getDrawUser;
   
      this.createCalendar();
      this.dataCalendar[moment().add(5, 'days').format("YYYY-MM-DD")].assignment = 1;
    },
    logout() {
      logout(this.$store);
    },
    minis(){
      this.mini = !this.mini
    },
    messengervi(mes){
      this.messengerview = mes

    },
    // collapselist(datas) {
     
    //         // this.$refs[datas.key].forEach((el, index) => {
    //         //     if (index != datas.i) el.$children[0].isActive = false;
    //         // })
    //          console.log(datas, 'mkkoookop');
    //     },
    //         closeCalenadar() {
    //   this.calendar=!this.calendar
    // }
  },
  
  computed: {
    ...mapGetters(["getUser", ]),


  },
  mounted() {
    // console.log(moment().add(5, 'days').format("YYYY-MM-DD"), 'lllllllllll');
    if (!this.getUser) {
      syncUpdateToken(this.$store).then(() => {
      this.build()
      this.loadPage = true;
    })
    } else {
      this.build()
      this.loadPage = true;
    }
    
  },
};
</script>


<style lang="scss">
@import "@/utils/colors.scss";
$top_diff: 75px;

.v-main__wrap {
  display: flex !important;
    flex-direction: column;
}

  
.allitems {
  border-left: 3px solid transparent;
  font-size: .5rem;
 
}
.bold {
  font-weight: bold;
}
.top-height {
  height: $top_diff;
}
.calendar-main {
  position: absolute;
  width: 100%;
  background: white;
}
.topcalendar-item {
  border-left: 3px solid white;
}
// .main-block-content {
//   width: 100%;
//   flex-grow: 3;
// }
.month-calendar {
  display: flex;
  // align-items: start;
  // justify-content: start;
  flex-grow: 0;
  margin-left: 0px;
  transform: rotate(180deg);
  
  color:  var(--v-inyand2-base);
  font-size: .65rem;
  writing-mode: tb-rl;
}
// .shell-content .divider-calendar {
//   border-color: #737d8f;
// }
// .shell-content .divider-calendar-before {
//   border: 2px solid #5a0303;
// }
.text-card-calendar {
  font-size: 0.7rem;
  color:  var(--v-inyand2-base);
}
.icon-card-calendar i {
  font-size: 1.2rem;
  color: white;
}
.calendar-count {
  font-size: 0.5rem;
  line-height: 1.1;
  color: white;
  background: #ff698c;
  margin: 0 2px;
}
.right-side-user-info > div {
  flex-grow: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  
}
.right-side-user-info > div i {
color: white;
font-size: 1em;
}
.initial-user {
  // text-transform: uppercase;
  font-weight: bold;
}


.nl_whatsup {
    background: var(--v-chat-base)!important;
}

   
.hidden{
  opacity: 0;
}

.v-toolbar__content {
  padding: 0!important;
}
.v-application--is-ltr .v-list-item__icon:last-of-type:not(:only-child) {
margin: 0!important;
  
}

.infobar {
  min-width: 25vw;
}



</style>