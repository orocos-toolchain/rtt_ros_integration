#ifndef __RTT_ROSPARAM_ROSPARAM_H
#define __RTT_ROSPARAM_ROSPARAM_H

#include <rtt/RTT.hpp>
#include <rtt/Property.hpp>

namespace rtt_rosparam {

  class ROSParam : public RTT::ServiceRequester
  {

  public:
    ROSParam(RTT::TaskContext *owner) :
      RTT::ServiceRequester("rosparam",owner),
      getAllRelative("getAllRelative"),
      getAllAbsolute("getAllAbsolute"),
      getAllPrivate("getAllPrivate"),
      getAllComponentPrivate("getAllComponentPrivate"),
      getAll("getAll"),
      setAllRelative("setAllRelative"),
      setAllAbsolute("setAllAbsolute"),
      setAllPrivate("setAllPrivate"),
      setAllComponentPrivate("setAllComponentPrivate"),
      setAll("setAll"),
      get("get"),
      getParam("getParam"),
      getRelative("getRelative"),
      getAbsolute("getAbsolute"),
      getPrivate("getPrivate"),
      getComponentPrivate("getComponentPrivate"),
      set("set"),
      setParam("setParam"),
      setRelative("setRelative"),
      setAbsolute("setAbsolute"),
      setPrivate("setPrivate"),
      setComponentPrivate("setComponentPrivate")
    {
      this->addOperationCaller(getAllRelative);
      this->addOperationCaller(getAllAbsolute);
      this->addOperationCaller(getAllPrivate);
      this->addOperationCaller(getAllComponentPrivate);
      this->addOperationCaller(getAll);

      this->addOperationCaller(setAllRelative);
      this->addOperationCaller(setAllAbsolute);
      this->addOperationCaller(setAllPrivate);
      this->addOperationCaller(setAllComponentPrivate);
      this->addOperationCaller(setAll);

      this->addOperationCaller(get);
      this->addOperationCaller(getParam);
      this->addOperationCaller(getRelative);
      this->addOperationCaller(getAbsolute);
      this->addOperationCaller(getPrivate);
      this->addOperationCaller(getComponentPrivate);

      this->addOperationCaller(set);
      this->addOperationCaller(setParam);
      this->addOperationCaller(setRelative);
      this->addOperationCaller(setAbsolute);
      this->addOperationCaller(setPrivate);
      this->addOperationCaller(setComponentPrivate);
    }

    typedef enum  {
      RELATIVE, //! Relative resolution:  "name" -> "name"
      ABSOLUTE, //! Absolute resolution:  "name" -> "/name"
      PRIVATE,  //! Private resolution:   "name" -> "~name"
      COMPONENT //! Component resolution: "name" -> "~COMPONENT_NAME/name"
    }ResolutionPolicy;

    RTT::OperationCaller<bool(void)> getAllRelative;
    RTT::OperationCaller<bool(void)> getAllAbsolute;
    RTT::OperationCaller<bool(void)> getAllPrivate;
    RTT::OperationCaller<bool(void)> getAllComponentPrivate;
    RTT::OperationCaller<bool(void)> getAll;
    RTT::OperationCaller<bool(void)> setAllRelative;
    RTT::OperationCaller<bool(void)> setAllAbsolute;
    RTT::OperationCaller<bool(void)> setAllPrivate;
    RTT::OperationCaller<bool(void)> setAllComponentPrivate;
    RTT::OperationCaller<bool(void)> setAll;

    RTT::OperationCaller<bool(const std::string &, const unsigned int)> get;
    RTT::OperationCaller<bool(const std::string &, const std::string &)> getParam;
    RTT::OperationCaller<bool(const std::string &)> getRelative;
    RTT::OperationCaller<bool(const std::string &)> getAbsolute;
    RTT::OperationCaller<bool(const std::string &)> getPrivate;
    RTT::OperationCaller<bool(const std::string &)> getComponentPrivate;

    RTT::OperationCaller<bool(const std::string &, const unsigned int)> set;
    RTT::OperationCaller<bool(const std::string &, const std::string &)> setParam;
    RTT::OperationCaller<bool(const std::string &)> setRelative;
    RTT::OperationCaller<bool(const std::string &)> setAbsolute;
    RTT::OperationCaller<bool(const std::string &)> setPrivate;
    RTT::OperationCaller<bool(const std::string &)> setComponentPrivate;
  };
}

#endif // ifndef __RTT_ROSPARAM_ROSPARAM_H
