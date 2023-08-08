#include <iostream>
#include <vector>
#include <algorithm>
#include "family.h"

using namespace std;
namespace bp = boost::python;

namespace bptest {

void throwBpException(const char *msg) {
    PyErr_SetString(PyExc_RuntimeError, msg);
    boost::python::throw_error_already_set();
}

bp::object getClassType(const std::string &className) {
    bp::object PyMyModule = bp::import("bptest");
    bp::object pyDict = PyMyModule.attr("__dict__");
    bp::object classType = pyDict[className.c_str()];
    assert(classType.ptr() != Py_None);
    return classType;
}

Member::Member(std::string name, int age, MemberRole role) 
    : name(move(name)), age(age), role(role) {}

Member::Member(std::string name, MemberRole role) 
    : Member(name, -1, role) {}

bool Member::operator<(const Member &other) {
    return this->role < other.role;
}

Family::Family() : inCity(false) {}
Family::Family(string location, bool inCity) : location(move(location)), inCity(inCity) {}

void Family::addMember(const string& name, int age, MemberRole role) {
    auto bpMember = getClassType("Member")(name, age, role);
    addMember(bpMember);
}

void Family::addMember(const boost::python::object& member) {
    Member &cppMember = bp::extract<Member&>(member);
    if ((cppMember.role == PARENT || cppMember.role == GRAND_PARENT) && 
        roleCnt.has_key(cppMember.role) && roleCnt[cppMember.role] == 2) {
        throwBpException("Invalid role, already has 2 count.");
    }
    auto cnt = roleCnt.get(cppMember.role, 0);
    roleCnt[cppMember.role] = cnt + 1;
    members.append(member);
}

bp::object Family::getMember(const std::string& name) {
    for (int i = 0; i < bp::len(members); ++i) {
        const Member &cppMem = bp::extract<Member>(members[i]);
        if (cppMem.name == name) {
            return members[i];
        }
    }
    return bp::object();
}

bp::list Family::getMember(MemberRole role) {
    bp::list targetMembers;
    for (int i = 0; i < bp::len(members); ++i) {
        const Member &cppMem = bp::extract<Member>(members[i]);
        if (cppMem.role == role) {
            targetMembers.append(members[i]);
        }
    }
    return targetMembers;
}

void Family::showMembers() {
    vector<Member> vec;
    for (int i = 0; i < bp::len(members); ++i) {
        vec.push_back(bp::extract<Member&>(members[i]));
    }

    std::sort(vec.begin(), vec.end());

    for (const Member& member : vec) {
        cout << member.name << " " << member.age << " " << member.role << endl;
    }
}

bool Family::hasChild() {
    auto cnt = roleCnt.get(CHILD, bp::object(0));
    // cout << "cnt type:" << typeid(cnt).name() << endl;
    return bp::extract<int>(cnt) > 0;
}

}  // namespace bptest
