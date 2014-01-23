<cfsetting showdebugoutput="false" />
<cfparam name="url.reportDir" default="report" />
<cfparam name="url.dsn" default="sakila" />

<cfscript>
  baseReportPath = GetDirectoryFromPath(ExpandPath( "*.*")) & url.reportDir & '/';
  tmpReportPath = baseReportPath & 'tmp/';
  reportExt = '.jasper';
  assetsPath = baseReportPath & 'assets/';

  // default generator configuration option
  cfg = {
    format = 'inline'
  };

  // default report configuration option
  conf = {
    assetsPath = assetsPath,
    dataProvider = 'conn',
    dsn = url.dsn
  };

  // append all variable exist in form struct into url struct
  StructAppend(conf, url);

  // append all variable exist in form struct into conf struct
  StructAppend(conf, form);

  // delete fieldnames as it is not required
  StructDelete(conf,'FIELDNAMES');


  // default report file
  reportFile = baseReportPath & 'default/Default' & reportExt;


  // check whether this generator called with report name. if not exist, default report will be generated
  if(structKeyExists(conf, 'report')){
    requestReportFile = baseReportPath & conf.report & reportExt;

    // check whether report file exist in specified path. if not exist, default report will be generated
    if(fileExists(requestReportFile)){
      reportFile = requestReportFile;
    }

  }


  // configure temporary path for generated assets
  cfg['tempDir'] = tmpReportPath;

  // full path of report to be generated
  cfg['jasperPath'] = reportFile;

  // configuration option passed to generate report
  cfg['conf'] = conf;


  // call the xCubeReport library
  new core.xCubeReport3().genReport(argumentCollection=cfg);
</cfscript>