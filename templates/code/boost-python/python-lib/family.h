#ifndef _COMPONENTS_H
#define _COMPONENTS_H

#include <string>
#include "boost/python.hpp"

namespace bptest {

enum MemberRole {
    GRAND_PARENT = 1,
    PARENT = 2,
    CHILD = 3,
    GRAND_CHILD = 4
};

struct Member : public boost::python::object {
    Member(std::string name, int age, MemberRole role);
    Member(std::string name, MemberRole role);

    bool operator<(const Member &other);

    MemberRole role;
    int age;
    std::string name;
};

struct Family : public boost::python::object {
    Family();
    Family(std::string location, bool inCity);
    // Family(const Family &) = delete;
    void setLocation(const std::string &loc) { location = loc; }
    void addMember(const std::string &name, int age, MemberRole role);
    void addMember(const boost::python::object &member);
    boost::python::object getMember(const std::string &name);
    boost::python::list getMember(MemberRole role);
    void showMembers();
    bool hasChild();

    bool inCity;
    std::string location;
    boost::python::list members;
    boost::python::dict roleCnt;
};

}
#endif  // _COMPONENTS_H
