from orm.models import *
from orm.schema import *
from services.wsservice import *



class Userquery:
    async def getuser(id):
        user: User = await User.objects.select_related(["otdel", "rank","position","organization","department"]).fields(
            ["telephoneNumber", "phone","email","otdel","department", "organization", "position", "avatar","physicalDeliveryOfficeName",
            "id", "sn", "givenName", "fullname", "position","username"
            ]).get(id=id)
        return querytoPydantic(UserFullInfo, user)