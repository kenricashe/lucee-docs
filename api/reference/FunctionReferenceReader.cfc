component accessors=true {

	property name="functions" type="struct";

	public any function init() {
		_loadExtensionInfo();
		_loadFunctions();

		return this;
	}

	public array function listFunctions() {
		return getFunctions().keyArray();
	}

	public struct function getFunction( required string functionName ) {
		var functions = getFunctions();

		return functions[ arguments.functionName ] ?: {};
	}

// private helpers
	public void function _loadFunctions() {
		var functionNames = getFunctionList().keyArray().sort( "textnocase" );
		var functions = {};

		for( var functionName in functionNames ) {
			var convertedFunc = _getFunctionDefinition( functionName );

			if ( convertedFunc.status neq "hidden" )
				functions[ functionName ] = convertedFunc;
		}

		setFunctions( functions );
	}

	private struct function _getFunctionDefinition( required string functionName ) {
		var coreDefinition = getFunctionData( arguments.functionName );
		var parsedFunction = StructNew( "linked" );

		if ( len ( coreDefinition.nameWithCase ?: "" ) )
			parsedFunction.name     = coreDefinition.nameWithCase;
		else
			parsedFunction.name     = coreDefinition.name ?: "";
		parsedFunction.memberName   = coreDefinition.member.name ?: "";
		parsedFunction.description  = coreDefinition.description ?: "";
		parsedFunction.status       = coreDefinition.status ?: "";
		parsedFunction.deprecated   = parsedFunction.status == "deprecated";
		parsedFunction.class        = coreDefinition.class ?: "";
		parsedFunction.returnType   = coreDefinition.returntype ?: "";
		parsedFunction.argumentType = coreDefinition.argumentType ?: "";
		parsedFunction.keywords     = coreDefinition.keywords ?: [];
		parsedFunction.introduced   = coreDefinition.introduced ?: "";
		parsedFunction.alias        = coreDefinition.alias ?: "";
		parsedFunction.arguments    = [];

		if ( structKeyExists( variables.extensionMap, coreDefinition.name ) )
			parsedFunction.srcExtension = variables.extensionMap[ coreDefinition.name ];

		var args = coreDefinition.arguments ?: [];
		for( var arg in args ) {
			var convertedArg = StructNew( "linked" );
			if ( len ( arg.nameWithCase ?: "" ) )
				convertedArg.name    = arg.nameWithCase;
			else
				convertedArg.name    = arg.name        ?: "";
			convertedArg.description = arg.description ?: "";
			convertedArg.type        = arg.type        ?: "";
			convertedArg.required    = IsBoolean( arg.required ?: "" ) && arg.required;
			convertedArg.default     = arg.defaultValue ?: NullValue();
			convertedArg.alias       = arg.alias        ?: "";
			convertedArg.status		 = arg.status		?: NullValue();
			convertedArg.introduced	 = arg.introduced		?: NullValue();
			if ( arg.status neq "hidden" )
				parsedFunction.arguments.append( convertedArg );
		}

		return parsedFunction;
	}

	private void function _loadExtensionInfo(){
		// load java tags
		variables.extensionMap = {};
		var cfg = getPageContext().getConfig();
		var flds = cfg.getFLDs();
		var ff = flds.getFunctions();
		for (var fname in ff){
			var bi = bundleInfo( ff[fname].getBIF() );
			if ( bi.name != "lucee.core" ) {
				var e = getExtensionOfBundle( bi.name );
				variables.extensionMap[ fname ] = {
					name: e.getName(),
					id: e._getId(),
					version: e._getVersion()
				}
			}
		}

		// load cfml tags
		var extensions = extensionList();
		loop query="extensions" {
			local.e = queryRowData ( extensions, extensions.currentrow, "struct" );
			if (len(e.functions) ){
				for ( fname in e.functions ){
					variables.extensionMap[ listFirst(fname,".") ] = {
						name: e.name,
						id: e.id,
						version: e.version
					}
				}
			}
		}
	}

	private any function getExtensionOfBundle( bundleName ) {
		var cfg = getPageContext().getConfig();
		var extensions = cfg.getAllRHExtensions();
		var luceeMajor = listFirst( server.lucee.version, "." );
		var bundles = "";
		loop collection=extensions.iterator() item="local.ext" {
			if (luceeMajor gte 7)
				bundles = ext.getMetadata().getBundles();
			else {
				bundles = ext.bundles;
			}
			
			loop array=bundles item="local.bundle" {
				if ( bundle.getSymbolicName() == bundleName ) return ext.getMetadata();
			}
		}
		throw "could not find extension for bundle [#bundleName#]";
	}

}