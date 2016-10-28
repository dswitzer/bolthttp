<cfsetting requesttimeout="150" enablecfoutputonly="true">
<cfscript>
	function exitCode( required numeric code ) {
		var exitcodeFile = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/.exitcode";
		FileWrite( exitcodeFile, code );
	}
	try {
		if (!structKeyExists(url, "reporter")) {
			reporter = cgi.server_protocol == "CLI/1.0" ? "text" : "simple";
		}
		testbox = new testbox.system.TestBox( options={}, reporter=reporter, directory="tests");
		writeOutput( testbox.run() );
		resultObject = testbox.getResult();
		errors       = resultObject.getTotalFail() + resultObject.getTotalError();
		exitCode( errors ? 1 : 0 );
	} catch ( any e ) {
		writeOutput( "An error occurred running the tests. Message: [#e.message#], Detail: [#e.detail#]" );
		exitCode( 1 );
	}
</cfscript>