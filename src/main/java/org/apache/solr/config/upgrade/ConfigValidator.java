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

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.solr.config.upgrade.UpgradeProcessorsConfig.ProcessorConfig;
import org.w3c.dom.Document;

/**
 * TODO
 */
public class ConfigValidator {
  private final String confName;
  private final Transformer transformer;

  public ConfigValidator(ToolParams params, String confName, ProcessorConfig procConfig) {
    this.confName = confName;
    this.transformer = buildTransformer(params, procConfig);
  }

  public boolean validate(Source config, ValidationHandler handler) throws TransformerException {
    handler.begin(confName);
    DOMResult validationResult = new DOMResult();
    transformer.transform(config, validationResult);
    return handler.process(confName, (Document)validationResult.getNode());
  }

  protected Transformer buildTransformer(ToolParams params, ProcessorConfig procConfig) {
    Path scriptPath = Paths.get(procConfig.getValidatorPath());
    if (!scriptPath.isAbsolute()) {
      scriptPath = params.getProcessorConfPath().getParent().resolve(scriptPath);
    }
    if (!Files.exists(scriptPath)) {
      throw new IllegalArgumentException("Unable to find validation script "+scriptPath);
    }
    try {
      return params.getFactory().newTransformer(new StreamSource(scriptPath.toFile())) ;
    } catch (TransformerConfigurationException e) {
      throw new UpgradeConfigException(e);
    }
  }
}
