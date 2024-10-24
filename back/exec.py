import re, sys, os, secrets
from dotenv import load_dotenv

dictType = {
    'String': 'str',
    'Integer': 'int',
    'Text': 'str',
    'Boolean': 'bool',
}

def converColumn(s):
    s: list = re.findall(r'Column\((.*)\).*$', s)[0].split(',')
    
    val = re.sub(r'\(\d{1,}\)', "", s[1]).strip()
    key = s[0].replace('"', "")
    return f'{key}: {dictType[val] if val in dictType else "" }'



class Exec():
    @classmethod
    def runserver(cls, args):
        os.chdir('backend')
        os.system(f'uvicorn main:app  --reload ')
        # --host 172.16.200.33 --port 8000

    @classmethod
    def inschema(cls, args):
        """ Create schema for SQLAlchemy """
    
        lines = []
        while True:
            line = input()
            if line:
                lines.append(converColumn(line))
            else:
                break


        print('\n'.join(lines))

    @classmethod
    def makemigrations(cls, args):
        """ Create alembic's migrations: docker-compose run backend alembic revision --autogenerate -m "New Migration" 
            Input: "exec.py makemigratios namemigrations"
        """

        if len(args) > 2:
            print("Unknown's arguments")
            return

        n = ''    

        if len(args) == 1:
            n = input("Enter migration's name:\n")
            if n == '':
                raise Exception("Empty name")
        else:
            n = args[1]

        # os.system(f'docker-compose run --rm backend alembic revision --autogenerate -m "{n}"')
        os.chdir('backend')
        
        os.system(f'alembic revision --autogenerate -m "{n}"')

    @classmethod  
    def migrate(cls, args):
        """
            Record alembic's migrations: docker-compose run backend alembic upgrade head
        """
        # os.system('docker-compose run --rm backend alembic upgrade head')
        os.chdir('backend')
        os.system('alembic upgrade head')

    @classmethod
    def secret(cls, args):

        n = 16
        if len(args) == 2:
            n = args[1]
        print(secrets.token_urlsafe(int(n)))

    @classmethod    
    def pg_dump(cls,args):
       """
        Создание дампа БД 
       """ 
       import datetime
       load_dotenv()
       n = input("Название для файла:\n")
      
       if n=="":
           n=f'{datetime.date.today()}' 
    #    os.system(f'psql -U {os.environ["DB_USER"]} -P{os.environ["DB_PASSWORD"]}  pg_dump  --data-only -F t {os.environ["DB_NAME"]}  >backups/{n}.sql')
       os.system(f'pg_dump --dbname=postgresql://{os.environ["DB_USER"]}:{os.environ["DB_PASSWORD"]}@127.0.0.1:5432/{os.environ["DB_NAME"]}  >backups/{n}.sql --data-only' )
       print("Файл дампа базы создан")

    @classmethod
    def pg_restore(cls,args):
        load_dotenv()
        n = input("Название для файла:\n")
        if n=="":
            raise Exception("Надо имя файла")
        os.system(f'pg_restore -U {os.environ["DB_USER"]} -v -c -d  {os.environ["DB_NAME"]} < backups/{n}.sql')
        print("OK!")


if __name__ == "__main__":

    args = sys.argv[1:]
    if len(args) == 0:
        help(Exec)
    else:
        getattr(Exec, args[0])(args)
    
    
