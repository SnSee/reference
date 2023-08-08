#include "boost/python.hpp"
#include "family.h"

namespace bp = boost::python;
using namespace std;

#define BP_CLASS(name) bp::class_<name>(#name)
#define BP_ATTR(className, attrName) def_readwrite(#attrName, &className::attrName)


namespace bptest {

BOOST_PYTHON_MODULE(bptest) {
    bp::enum_<MemberRole>("MemberRole")
        .value("GRAND_PARENT", GRAND_PARENT)
        .value("PARENT", PARENT)
        .value("CHILD", CHILD)
        .value("GRAND_CHILD", GRAND_CHILD)
    ;
    
    bp::class_<Member>("Member", bp::init<std::string, int, MemberRole>())
        .BP_ATTR(Member, name)
        .BP_ATTR(Member, age)
        .BP_ATTR(Member, role)
        .def(bp::init<std::string, MemberRole>())
    ;
    
    void (Family::*addMember2)(const bp::object &) = &Family::addMember;
    bp::object (Family::*getMember1)(const std::string &) = &Family::getMember;
    bp::list (Family::*getMember2)(MemberRole) = &Family::getMember;

    BP_CLASS(Family)
        .BP_ATTR(Family, inCity)
        .BP_ATTR(Family, location)
        .BP_ATTR(Family, members)
        .BP_ATTR(Family, roleCnt)
        .def("addMember", static_cast<void(Family::*)(const string &, int, MemberRole)>(&Family::addMember))
        .def("addMember", addMember2)
        .def("getMember", getMember1)
        .def("getMember", getMember2)
        .def("showMembers", &Family::showMembers)
        .def("hasChild", &Family::hasChild)
        .def(bp::init<>())
        .def(bp::init<std::string, bool>())
    ;
    
}

}