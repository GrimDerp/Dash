module components.lights;
import core.properties, core.gameobject;
import components.component;
import graphics.shaders;

import gl3n.linalg;

class Light : Component
{
public:
	mixin Property!( "vec3", "color", "public" );

	this( GameObject owner, vec3 color )
	{
		super( owner );

		this.color = color;
	}
	
	override void update()
	{

	}

	override void shutdown()
	{

	}

}

class AmbientLight : Light 
{ 
	this( GameObject owner, vec3 color )
	{
		super( owner, color );
	}
}

/* 
 * Directional Light data
 */
class DirectionalLight : Light
{
public:
	mixin Property!( "vec3", "direction" );

	this( GameObject owner, vec3 color, vec3 direction )
	{
		this.direction = direction;
		super( owner, color );
	}
}

/*
 * Point Light Stub
 */
class PointLight : Light
{
public:
	this( GameObject owner, vec3 color )
	{
		super( owner, color );
	}
}

/*
 * SpotLight Stub
 */
class SpotLight : Light
{
public:
	this( GameObject owner, vec3 color )
	{
		super( owner, color );
	}
}
