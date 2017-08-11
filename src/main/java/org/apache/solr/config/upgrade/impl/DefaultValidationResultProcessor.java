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

package org.apache.solr.config.upgrade.impl;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.solr.config.upgrade.ConfigUpgradeTool;
import org.apache.solr.config.upgrade.ToolParams;
import org.apache.solr.config.upgrade.ValidationHandler;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

public class DefaultValidationResultProcessor implements ValidationHandler {
  private final ToolParams params;

  public DefaultValidationResultProcessor(ToolParams params) {
    this.params = params;
  }

  @Override
  public void begin(String confName) {
    System.out.println("Validating "+confName+"...");
    //System.out.println();
  }

  @Override
  public boolean process(String confName, Document result) {
    StreamSource resultSummaryProcessor = new StreamSource(
        ConfigUpgradeTool.class.getClassLoader()
                               .getResourceAsStream("validation_result_summary.xslt"));

    try {
      Transformer summaryTransform =
          TransformerFactory.newInstance().newTransformer(resultSummaryProcessor);
      summaryTransform.setParameter("solrOpVersion", this.params.getUpgradeProcessorConf().getOutputVersion());
      summaryTransform.setParameter("dryRun", this.params.isDryRun());
      summaryTransform.transform(new DOMSource(result), new StreamResult(System.out));

      // Store the results in the specified directory.
      Transformer saveTransform = TransformerFactory.newInstance().newTransformer();
      saveTransform.setOutputProperty(OutputKeys.INDENT, "yes");
      saveTransform.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
      saveTransform.transform(new DOMSource(result),
          new StreamResult(this.params.getResultDirPath().resolve(confName+"_validation.xml").toFile()));

      if (evaluateXPathExpression(result, "/result/incompatibility[contains(level, 'error')]").getLength() == 0) {
        System.out.println();
        System.out.printf("Solr %s validation is successful. Please review %s for more details. \n",
            confName, params.getResultDirPath().resolve(confName+"_validation.xml").toAbsolutePath());
        System.out.println();
        return true;
      } else {
        System.out.println();
        System.out.printf("Solr %s validation failed. Please review %s for more details. \n",
            confName, params.getResultDirPath().resolve(confName+"_validation.xml"));
        System.out.println();
        return false;
      }

    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  private static NodeList evaluateXPathExpression (Document doc, String expr) throws XPathExpressionException {
    XPath xpath = XPathFactory.newInstance().newXPath();
    return (NodeList)xpath.compile(expr).evaluate(doc, XPathConstants.NODESET);
  }


}
