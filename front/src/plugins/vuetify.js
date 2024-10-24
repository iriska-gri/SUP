import Vue from 'vue';
import Vuetify from 'vuetify';
import 'vuetify/dist/vuetify.min.css';
import ru from 'vuetify/lib/locale/ru';
import '@fortawesome/fontawesome-free/css/all.css';
import colors from 'vuetify/lib/util/colors'

Vue.use(Vuetify);

export default new Vuetify({
    theme: {
        
        options: {
          customProperties: true,
   
        },
        themes: {
          light: {
            disableds:"#B0B0B0",
            chatik: '#5A7BBD',
            chatiknotme: '#C6637B',
            chatinfo: "#F0F8FF",
            chatinfonotme: "#fff1f4",
            chatmess: "#fefeff",
            chatdevider: "#DCDCDC",
            chatico: '#5A7BBD',
            primary: '#404E67',
            secondary: '#424242',
            accent: '#82B1FF',
            error: '#FF5252',
            info: '#2196F3',
            success: '#4CAF50',
            warning: '#FFC107',
            backfon: '#FFFFFF',// Фон сайта
            inyand: '#FFFFFF', // Белый и черный
            slech: '#C2C6CE',
            inyand2: '#181818', // Черный и белый
            greym: '#404E67', //Серый
            spisok: '#767171', // Логин и пароль
            card_title: '#09182e', // Шапка для карточки
            // btns: '#0D4CD3', // Обычная кнопка
            btns: '#5A7BBD',
            btns_menus: '#3F51B5',
            text_menus: '#0D4CD3',
            inputs: '#E8F0FE', // Кнопка действия
            lines_border: '#FFFFFF', // Границы
            select_lines_border: '#31ffff',  // Границы для карточек и блоков
            icons: '#0D4CD3',
            primaryicons: '#404E67', // Белые и серые цвета для иконок или выделения
            inputcolor: '#e3e3e3', // Область куда вводится текст, фон
            main_theme: '#FFFFFF', //Основа для меню, карточек и кнопок
            active: '#eaeeff', //Выделение активного действия на кнопке или списка
            passiv_text: '#BCBCBC', // Текст для информации, блеклый
            bottom_strip: '#193416', // Выделенный низ активной вкладки
            close_icons: '#e92011', // Цвет на удаление
            paused: colors.orange.accent3, //Цвет для нейтрального значения типо желтого сигнала светофора, пример пауза
            open_icons: '#4CAF50', // Зеленый цвет
            text_card: '#1a1a1a', // Текст для обозначения полей заполнения
            scrollbar: '#073E9B',
            fonback: '#d8dbe1', // Фон за таблицами
            ganttext : '#0D4CD3', //Цвет текста ганта
            gantborder : '#e0e0e0', //Цвет границ ганта
            granica : '#9E9E9E', //цвет границы
            chat: "#F5F5F5", //цыет окна чата
            prliniarstop: "#C1C4CA", //Цвет линии прогрессбара в случае приостановлено
            prliniar85: "#F7D293", //Цвет линии прогрессбара в случае >= 85
            prliniar100: "#F5A593", //Цвет линии прогрессбара в случае >= 100
            prliniarelse: "#A7E3BB", // Цвет линии прогрессбара в случае иначе,
            addnewshapka: '#60447c',
            texthead: '#333333',
            
            // '#fdfdfd'
            exppanel: '#FFFFFF' // Цыкт неактивной панели
          },
          dark: {
            disableds:"#B0B0B0",
            chatik: '#5A7BBD',
            chatiknotme: '#C6637B',
            chatinfo:'#03173f',
            chatinfonotme: '#4b0c1b',
            chatmess: "#1E1E1E",
            chatdevider: "#FFFFFF",
            chatico: '#5A7BBD',
            primary: '#404E67',
            secondary: '#424242',
            accent: '#FF4081',
            error: '#FF5252',
            info: '#ffffff',
            success: '#4CAF50',
            warning: '#FB8C00',
            backfon: '#362a2d',// Фон сайта
            inyand: '#181818', // Белый и черный
            slech: '#8C8272',
            inyand2: '#FFFFFF', // Черный и белый
            greym: '#404E67', //Серый
            spisok: '#d7d7d7', // Логин и пароль
            card_title: '#f7f2ea', // Шапка для карточки
            btns: '#f9a825', // Обычная кнопка
            btns_menus: '#f9a825',
            text_menus: '#f9a825',
            inputs: '#E8F0FE', // Кнопка действия
            lines_border: '#FFFFFF',  // Границы для карточек и блоков
            select_lines_border: '#c76333',  // Границы для карточек и блоков
            
            icons: colors.yellow.darken3,
            primaryicons: '#FFFFFF', // Белые и серые цвета для иконок или выделения
            inputcolor: '#1F2C34', // Область куда вводится текст, фон
            main_theme: '#1E1E1E', //Основа для меню, карточек и кнопок
            active: '#443f2a', //Выделение активного действия на кнопке или списка
            passiv_text: '#7E7E7E', // Текст для информации, блеклый
            bottom_strip: '#5A0303', // Выделенный низ активной вкладки
            close_icons: '#e92011', // Цвет на удаление
            paused: '#FF9109', //Цвет для нейтрального значения типо желтого сигнала светофора, пример пауза
            open_icons: '#4CAF50',
            text_card: '#A2A2A2', // Текст для обозначения полей заполнения
            scrollbar: '#6F432A',
            fonback: '#322c23', // Фон за таблицами
            ganttext : '#f9a825', //Цвет текста ганта
            gantborder : '#DDDDDD', //Цвет границ ганта
            granica : '#9E9E9E', //цвет границы
            chat: "#272727", //цыет окна чата
            prliniarstop: "#9d9d9d", //Цвет линии прогрессбара в случае приостановлено
            prliniar85: "#bd9b61", //Цвет линии прогрессбара в случае >= 85
            prliniar100: "#cf8271", //Цвет линии прогрессбара в случае >= 100
            prliniarelse: "#6d8f78", // Цвет линии прогрессбара в случае иначе
            addnewshapka: '#60447c',
            texthead: '#333333',
            exppanel: '#F6F6F6' // Цыкт неактивной панели
          },
        },
      },
        lang: {
          locales: { ru },
          current: 'ru',
        },
      icons: {
        iconfont: 'fa',
      },
});
