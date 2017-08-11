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

import javax.xml.transform.TransformerFactory;

public class ToolParams {
  private final ConfigType confType;
  private final Path solrConfPath;
  private final Path processorConfPath;
  private final Path resultDirPath;
  private final boolean dryRun;
  private final TransformerFactory factory;
  private final UpgradeProcessorsConfig upgradeProcessorConf;

  public ToolParams(ConfigType confType, Path solrConfPath, Path processorConfPath,
      Path resultDirPath, boolean dryRun, boolean verbose) throws Exception {
    this.confType = confType;
    this.solrConfPath = solrConfPath;
    this.processorConfPath = processorConfPath;
    this.resultDirPath = resultDirPath;
    this.dryRun = dryRun;
    this.factory = TransformerFactory.newInstance();
    this.factory.setErrorListener(new SuppressCompilerWarnings(verbose));
    this.upgradeProcessorConf = UpgradeProcessorsConfigFactory.newInstance(processorConfPath);
  }

  public ConfigType getConfType() {
    return confType;
  }

  public Path getSolrConfPath() {
    return solrConfPath;
  }

  public Path getResultDirPath() {
    return resultDirPath;
  }

  public TransformerFactory getFactory() {
    return factory;
  }

  public boolean isDryRun() {
    return dryRun;
  }

  public Path getProcessorConfPath() {
    return processorConfPath;
  }

  public UpgradeProcessorsConfig getUpgradeProcessorConf() {
    return upgradeProcessorConf;
  }

  /**
   * Validate the specified input parameters
   */
  public void checkArgs() {
    if (!Files.exists(solrConfPath)) {
      throw new IllegalStateException("Unable to locate the Solr configuration " + solrConfPath);
    }
    if (!Files.exists(processorConfPath)) {
      throw new IllegalStateException("Unable to locate upgrade processor config file  " + processorConfPath);
    }
    if (!Files.exists(resultDirPath)) {
      throw new IllegalArgumentException("The result directory ( " + resultDirPath+" ) does not exist.");
    }
  }

}
