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

import java.util.Objects;
import java.util.Optional;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;

@JacksonXmlRootElement(localName = "upgradeProcessors")
public class UpgradeProcessorsConfig {
  @JacksonXmlProperty(isAttribute = true)
  private int inputVersion;

  @JacksonXmlProperty(isAttribute = true)
  private int outputVersion;

  @JacksonXmlProperty(localName="processor")
  private ProcessorConfig[] processors;

  public int getInputVersion() {
    return inputVersion;
  }

  public int getOutputVersion() {
    return outputVersion;
  }

  public Optional<ProcessorConfig> getProcessorByConfigType(ConfigType confType) {
    for (ProcessorConfig p : processors) {
      if (Objects.equals(confType.getConfigType(), p.getConfigType())) {
        return Optional.of(p);
      }
    }

    return Optional.empty();
  }

  public static class ProcessorConfig {
    @JacksonXmlProperty(isAttribute = true)
    private String configType;

    @JacksonXmlProperty(isAttribute=true)
    private String validatorPath;

    @JacksonXmlProperty(isAttribute=true)
    private String transformerPath;

    public String getConfigType() {
      return configType;
    }

    public String getValidatorPath() {
      return validatorPath;
    }

    public String getTransformerPath() {
      return transformerPath;
    }
  }
}
