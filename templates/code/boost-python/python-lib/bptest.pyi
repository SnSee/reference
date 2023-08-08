from enum import Enum
from typing import Union, Optional


class MemberRole(Enum):
    GRAND_PARENT = 1
    PARENT = 2
    CHILD = 3
    GRAND_CHILD = 4


class Member:
    name: str
    age: int
    role: MemberRole
    def __init__(self, name: str, age: int, role: MemberRole) -> None: ...


class Family:
    inCity: bool
    location: str
    members: list[Member]
    def __init__(self, location: str=None, inCity: bool=None) -> None: ...
    def setLocation(location: str) -> None: ...
    def addMember(name_or_member: Union[str, Member], age: Optional[int]=None, role: Optional[MemberRole]=None) -> bool: ...
    def getMember(name_or_role: Union[str, MemberRole]) -> Union[Member, list[Member]]: ...
    def showMembers() -> None: ...
    def hasChild() -> bool: ...
