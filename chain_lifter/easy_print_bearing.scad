//DIMENSIONS
width=20;					//width of bearing
out_rad1=50;				//outer radius
out_rad2=out_rad1;			//change for tapered bearings
in_rad=(1/2)*out_rad1;		//inner radius


//MODULE DEFINITIONS
module case()
{
	difference()
	{
		cylinder(width,out_rad1,out_rad2, center=true, $fn=100);
		cylinder(1.1*width,in_rad,in_rad,center=true, $fn=100);
	}
}

module ring()
{
	rotate_extrude($fn=100)
	translate([(3/4)*out_rad1,0,0])
	difference()
	{
		square(1.1*width,(3/4)*width, center=true);
		translate([(3/4)*width,0,0]) circle((1/2)*width, center=true);
		translate([(3/4)*width,(1/2)*width,0]) circle((1/2)*width, center=true);
		translate([(3/4)*width,(-1/2)*width,0]) circle((1/2)*width, center=true);
		
		translate([(-3/4)*width,0,0]) circle((1/2)*width, center=true);
		translate([(-3/4)*width,(1/2)*width,0]) circle((1/2)*width, center=true);
		translate([(-3/4)*width,(-1/2)*width,0]) circle((1/2)*width, center=true);
	}
}

module roller()
{
	translate([0,(3/4)*out_rad1,0])
	rotate_extrude($fn=50)
	intersection ()
	{
		scale([0.96,0.96,0.96])
		difference()
		{
			square(1.1*width, center=true);
			translate([(3/4)*width,0,0]) circle((1/2)*width, center=true);
			translate([(3/4)*width,(1/2)*width,0]) circle((1/2)*width, center=true);
			translate([(3/4)*width,(-1/2)*width,0]) circle((1/2)*width, center=true);
			translate([(-1/2)*1.1*width,0,0]) square(1.1*width, center=true);
		}
	square(width, center=true);
	}
}

//CONSTRUCTION
difference()
{
	case();
	ring();
}

for(n=[1:19])
{
	rotate([0,0,(n*(360/19))]) roller();
}

