# ! Запросы для создания форинов в проекте

# TRUNCATE TABLE public.projectstatuses CASCADE;
# INSERT INTO public.projectstatuses (name) VALUES ('Черновик'),('На согласовании'),('Утвержден'),('Отклонен'),('В работе'),('Приостановлен'),('Завершен');

# TRUNCATE TABLE public.taskstatuses CASCADE;
# INSERT INTO public.taskstatuses (name) VALUES ('Черновик'),('В работе'),('Приостановлена'),('На проверке'),('Завершена');

# TRUNCATE TABLE public.assignmentstatuses CASCADE;
# INSERT INTO public.assignmentstatuses (name) VALUES ('Черновик'),('Назначено'),('В работе'),('Приостановлено'),('На проверке'),('Завершено');


# TRUNCATE TABLE public.projecttypes CASCADE;
# INSERT INTO public.projecttypes (name) VALUES ('Стратегический'),('Оперативный');
# ! Тестовый проект
# TE TABLE public.projectroles CASCADE;
# INSERT INTO public.projectroles (name) VALUES ('Директор'),('Руководитель проекта'),('Секретарь'),('Координатор'),('Участник'),('Наблюдатель');

# TRUNCATE TABLE public.historyactions CASCADE;
# INSERT INTO public.historyactions (name) VALUES ('Создание'),('Изменение'),('Удаление');
# TRUNCATE TABLE public.historylevels CASCADE;
# INSERT INTO public.historylevels (name) VALUES ('Проект'),('Задача'),('Работа'),('Поручение');

# TRUNCATE TABLE public.doctypes CASCADE;
# INSERT INTO public.doctypes (name) VALUES ('Приказ'),('Паспорт'),('Состав РГ'),('План'),('План КС'),('Отчет'),('Итог'),('Протокол');