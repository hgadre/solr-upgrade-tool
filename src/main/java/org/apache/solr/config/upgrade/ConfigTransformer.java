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

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.solr.config.upgrade.UpgradeProcessorsConfig.ProcessorConfig;

public class ConfigTransformer {
  private final Transformer transformer;
  private final Path resultFile;

  public ConfigTransformer(ToolParams params, ProcessorConfig procConfig) {
    try {
      this.transformer = buildTransformer(params, procConfig);
    } catch (TransformerConfigurationException e) {
      throw new UpgradeConfigException (e);
    }

    String confFileName = params.getSolrConfPath().getFileName().toString();
    this.resultFile = params.getResultDirPath().resolve(confFileName);
  }

  public void transform (Source config) throws TransformerException {
    System.out.println("Applying auto transformations...");
    transformer.transform(config, new StreamResult(resultFile.toFile()));
    System.out.println();
    System.out.println("The upgraded configuration file is available at " + resultFile);
  }

  protected Transformer buildTransformer(ToolParams params, ProcessorConfig procConfig)
      throws TransformerConfigurationException {
    Transformer result = params.getFactory().newTransformer(); // identity transform.

    if (procConfig.getTransformerPath() != null) {
      Path scriptPath = Paths.get(procConfig.getTransformerPath());
      if (!scriptPath.isAbsolute()) {
        scriptPath = params.getProcessorConfPath().getParent().resolve(scriptPath);
      }
      if (!Files.exists(scriptPath)) {
        throw new IllegalArgumentException("Unable to find transformation script "+scriptPath);
      }
      result = params.getFactory().newTransformer(new StreamSource(scriptPath.toFile()));
    }

    result.setOutputProperty(OutputKeys.INDENT, "yes");
    result.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
    return result;
  }

}
