#!/bin/env python
from bptest import Family, Member, MemberRole


def makeFamily(loc: str = None, inCity: bool = None) -> Family:
    if loc:
        family = Family(loc, inCity)
    else:
        family = Family()
    gf = Member("GrandFather", 80, MemberRole.GRAND_PARENT)
    family.addMember(gf)
    family.addMember(Member("GrandMother", 80, MemberRole.GRAND_PARENT))
    family.addMember(Member("Father", 55, MemberRole.PARENT))
    family.addMember(Member("Mother", 55, MemberRole.PARENT))
    family.addMember(Member("Son", 30, MemberRole.CHILD))
    family.addMember(Member("SonWife", 30, MemberRole.CHILD))
    family.addMember(Member("Daughter", 30, MemberRole.CHILD))
    family.addMember(Member("DaughterHusband", 30, MemberRole.CHILD))
    family.addMember("SonDaughter", 5, MemberRole.GRAND_CHILD)
    family.addMember("DaughterSon", 5, MemberRole.GRAND_CHILD)

    get_gf = family.getMember("GrandFather")
    print(id(get_gf), id(gf))
    assert get_gf is gf
    return family


def test1():
    print("===============================")
    family = makeFamily()
    if family.hasChild():
        print("has child")
        for child in family.getMember(MemberRole.CHILD):
            assert isinstance(child, Member)
            print(child.name, child.age)


def test2():
    print("===============================")
    family = makeFamily()
    family.showMembers()


def main():
    test1()
    test2()


if __name__ == "__main__":
    main()
