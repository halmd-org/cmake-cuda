/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2000-2009 Kitware, Inc., Insight Software Consortium

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/
#ifndef cmPropertyMap_h
#define cmPropertyMap_h

#include "cmProperty.h"

class cmake;

class cmPropertyMap : public std::map<cmStdString,cmProperty>
{
public:
  cmProperty *GetOrCreateProperty(const char *name);

  void SetProperty(const char *name, const char *value,
                   cmProperty::ScopeType scope);

  void AppendProperty(const char* name, const char* value,
                      cmProperty::ScopeType scope, bool asString=false);

  const char *GetPropertyValue(const char *name,
                               cmProperty::ScopeType scope,
                               bool &chain) const;

  void SetCMakeInstance(cmake *cm) { this->CMakeInstance = cm; };

  cmPropertyMap() { this->CMakeInstance = 0;};

private:
  cmake *CMakeInstance;
};

#endif

