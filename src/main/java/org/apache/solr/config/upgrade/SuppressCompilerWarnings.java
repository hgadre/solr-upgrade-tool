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

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;

/**
 * The Java XSLT compiler generates number of warnings which (generally) do not affect the result of
 * the transformation. This class allows the upgrade tool to suppress such warnings. During the development
 * of the upgrade rules, display of such warnings can be enabled by providing "-v" command line parameter.
 */
class SuppressCompilerWarnings implements ErrorListener {
  private final boolean verbose;

  public SuppressCompilerWarnings(boolean verbose) {
    this.verbose = verbose;
  }

  @Override
  public void warning(TransformerException exception) throws TransformerException {
    if (verbose) {
      System.err.println(exception.getMessageAndLocation());
    }
  }

  @Override
  public void error(TransformerException exception) throws TransformerException {
    System.err.println(exception.getMessageAndLocation());
  }

  @Override
  public void fatalError(TransformerException exception) throws TransformerException {
    System.err.println(exception.getMessageAndLocation());
  }
}