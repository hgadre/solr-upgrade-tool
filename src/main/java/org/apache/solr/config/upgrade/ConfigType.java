/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.solr.config.upgrade;

/**
 * This enum defines Solr configuration which can be verified by compatibility checker
 */
public enum ConfigType {
  SCHEMA_XML("schema"), SOLRCONFIG_XML("solrconfig"), CONFIGSET("configset");

  private String configType;

  private ConfigType(String configType) {
    this.configType = configType;
  }

  public String getConfigType() {
    return configType;
  }

  public static ConfigType getConfigType(String configType) {
    if (SCHEMA_XML.getConfigType().equalsIgnoreCase(configType)) {
      return ConfigType.SCHEMA_XML;
    } else if (SOLRCONFIG_XML.getConfigType().equalsIgnoreCase(configType)) {
      return ConfigType.SOLRCONFIG_XML;
    }  else if (CONFIGSET.getConfigType().equalsIgnoreCase(configType)) {
      return ConfigType.CONFIGSET;
    }
    throw new IllegalArgumentException("Invalid configType "+configType);
  }

  @Override
  public String toString() {
    return configType;
  }
}
