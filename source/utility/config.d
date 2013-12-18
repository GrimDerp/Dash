module utility.config;
import math.vector;
import utility.filepath;

import core.dgame : GameState;
import graphics.graphics : GraphicsAdapter;
import utility.output : Verbosity;

import yaml;

import std.array, std.conv, std.string;

static class Config
{
static:
public:
	void initialize()
	{
		auto constructor = new Constructor;
		constructor.addConstructorScalar( "!vector2", &constructVector2 );
		constructor.addConstructorMapping( "!vector2-map", &constructVector2 );
		constructor.addConstructorScalar( "!vector3", &constructVector3 );
		constructor.addConstructorMapping( "!vector3-map", &constructVector2 );
		constructor.addConstructorScalar( "!gamestate", &constructEnum!GameState );
		constructor.addConstructorScalar( "!adapter", &constructEnum!GraphicsAdapter );
		constructor.addConstructorScalar( "!verbosity", &constructEnum!Verbosity );

		auto loader = Loader( FilePath.Resources.Config );
		loader.constructor = constructor;
		config = loader.load();
	}

	T get( T )( string path )
	{
		Node current;
		string left;
		string right = path;

		for( current = config; right.length; )
		{
			uint split = right.indexOf( '.' );
			if( split == -1 )
			{
				current = current[ right ];
				right = "";
				break;
			}
			else
			{
				left = right[ 0..split ];
				right = right[ split + 1..$ ];
				current = current[ left ];
			}
		}

		return current.as!T;
	}

private:
	Node config;
}

Vector!2 constructVector2( ref Node node )
{
	auto result = new Vector!2;

	if( node.isMapping )
	{
		result.values[ 0 ] = node[ "x" ].as!float;
		result.values[ 1 ] = node[ "y" ].as!float;
	}
	else if( node.isScalar )
	{
		string[] vals = node.as!string.split();

		if( vals.length != 2 )
		{
			throw new Exception( "Invalid number of values: " ~ node.as!string );
		}

		result.x = vals[ 0 ].to!float;
		result.y = vals[ 1 ].to!float;
	}

	return result;
}

Vector!3 constructVector3( ref Node node )
{
	auto result = new Vector!3;

	if( node.isMapping )
	{
		result.values[ 0 ] = node[ "x" ].as!float;
		result.values[ 1 ] = node[ "y" ].as!float;
		result.values[ 2 ] = node[ "z" ].as!float;
	}
	else if( node.isScalar )
	{
		string[] vals = node.as!string.split();

		if( vals.length != 3 )
		{
			throw new Exception( "Invalid number of values: " ~ node.as!string );
		}

		result.x = vals[ 0 ].to!float;
		result.y = vals[ 1 ].to!float;
		result.z = vals[ 2 ].to!float;
	}

	return result;
}

T constructEnum( T )( ref Node node ) if( is( T == enum ) )
{
	if( node.isScalar )
	{
		return node.as!string.to!T;
	}
	else
	{
		throw new Exception( "Enum must be represented as a scalar." );
	}
}
