//    Aperture primitives are part of SolderSCAD.py
//    script to convert gerber solder stencil file to OpenSCAD file 
//    Copyright (C) 2013 Andrew Barrow
//
//    SolderSCAD is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    SolderSCAD is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

stencil_thickness = 0.2;	//Change this line yourself to alter Z thickness

//////////////////////////////////////////////////////////////////////////////////////////////////
// Start of aperture primitives: circle, rectangle, obround, polygon                    
// These accept the same parameters in the same order as Gerber aperture definitions    
// 'drill' holes in pads will be rendered if specified even though they are unprintable 
//////////////////////////////////////////////////////////////////////////////////////////////////

// Circle aperture type
module gerb_circle (diameter, hole_X=0, hole_Y=0) {
	if (hole_X == 0) {
		cylinder (r = diameter/2, h=stencil_thickness, center = true);
	}
	else if (hole_Y == 0) {
		difference(){
			cylinder (r = diameter/2, h=stencil_thickness, center = true);
			cylinder (r = hole_X/2, h=stencil_thickness, center = true);
		}
	}
	else {
		difference(){	
			cylinder (r = diameter/2, h=stencil_thickness, center = true);
			cube (size = [hole_X, hole_Y, stencil_thickness], center = true);
		}	
	} 
}

// Rectangle aperture type
module gerb_rectangle (diam_X, diam_Y, hole_X=0, hole_Y=0) {
	if (hole_X==0) {
		cube (size = [diam_X, diam_Y, stencil_thickness], center = true);
	}
	else if (hole_Y == 0) {
		difference(){
			cube (size = [diam_X, diam_Y, stencil_thickness], center = true);
			cylinder (r = hole_X/2, h=stencil_thickness, center = true);	
		}
	}
	else	{
		difference(){
			cube (size = [diam_X, diam_Y, stencil_thickness], center = true);
			cube (size = [hole_X, hole_Y, stencil_thickness], center = true);
		}
	}
}

// Obround aperture type
module gerb_obround_primitive (diam_X, diam_Y) {
	if (diam_X < diam_Y) {
		union(){
			cube(size = [diam_X, diam_Y-diam_X, stencil_thickness], center = true);
			translate(v = [0, (diam_Y - diam_X) / 2, 0]) cylinder (r = diam_X/2, h=stencil_thickness, center = true);
			translate(v = [0, -((diam_Y - diam_X) / 2), 0]) cylinder (r = diam_X/2, h=stencil_thickness, center = true);
		}
		
	}
	else {	// diam_X is larger
		union(){
			cube(size = [diam_X-diam_Y, diam_Y, stencil_thickness], center = true);
			translate(v = [(diam_X - diam_Y) / 2, 0, 0]) cylinder (r = diam_Y/2, h=stencil_thickness, center = true);
			translate(v = [-((diam_X - diam_Y) / 2), 0, 0]) cylinder (r = diam_Y/2, h=stencil_thickness, center = true);
		}
	}
}

module gerb_obround (diam_X, diam_Y, hole_X=0, hole_Y=0) {
	if (hole_X==0) {
		gerb_obround_primitive(diam_X, diam_Y);
	}
	else if (hole_Y == 0) {
		difference(){
			gerb_obround_primitive(diam_X, diam_Y);
			cylinder (r = hole_X/2, h=stencil_thickness, center = true);	
		}
	}
	else	{
		difference(){
			gerb_obround_primitive(diam_X, diam_Y);
			cube (size = [hole_X, hole_Y, stencil_thickness], center = true);
		}
	}
}

// Polygon aperture type
module gerb_polygon (diameter, num_sides, rotation=0, hole_X=0, hole_Y=0) {
	if (hole_X == 0) {
		rotate (a=[0,0,rotation]) cylinder (r = diameter/2, h=stencil_thickness, $fn = num_sides, center = true);
	}
	else if (hole_Y == 0) {
		difference(){
			rotate (a=[0,0,rotation]) cylinder (r = diameter/2, h=stencil_thickness, $fn = num_sides, center = true);
			cylinder (r = hole_X/2, h=stencil_thickness, center = true);
		}
	}
	else {
		difference(){	
			rotate (a=[0,0,rotation]) cylinder (r = diameter/2, h=stencil_thickness, $fn = num_sides, center = true);
			cube (size = [hole_X, hole_Y, stencil_thickness], center = true);
		}	
	} 
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// End of aperture primitives -- everything below is generated from the input gerber    
//////////////////////////////////////////////////////////////////////////////////////////////////

// Start of aperture definitions

module D10(){
    gerb_circle(0.0400);
}
module D11(){
    gerb_rectangle(0.0600, 0.0600);
}
module D12(){
    gerb_rectangle(0.0500, 0.0500);
}
module D13(){
    gerb_rectangle(0.0827, 0.0551);
}
module D14(){
    gerb_rectangle(0.1020, 0.1460);
}
module D15(){
    gerb_rectangle(0.1200, 0.0900);
}
module D16(){
    gerb_circle(0.2500);
}
module D17(){
    gerb_circle(0.1378);
}
module D18(){
    gerb_rectangle(0.1378, 0.1378);
}
module D19(){
    gerb_circle(0.1130);
}
module D20(){
    gerb_circle(0.0550);
}
module D21(){
    gerb_rectangle(0.0550, 0.0550);
}
module D22(){
    gerb_obround(0.0650, 0.2840);
}
module D23(){
    gerb_rectangle(0.0394, 0.0275);
}
module D24(){
    gerb_rectangle(0.2200, 0.2300);
}
module D25(){
    gerb_rectangle(0.0560, 0.0720);
}
module D26(){
    gerb_circle(0.0580);
}
module D27(){
    gerb_rectangle(0.0256, 0.0295);
}
module D28(){
    gerb_rectangle(0.0600, 0.0700);
}
module D29(){
    gerb_obround(0.0250, 0.1000);
}
module D30(){
    gerb_rectangle(0.0250, 0.1000);
}
module D31(){
    gerb_obround(0.0160, 0.0900);
}
module D32(){
    gerb_rectangle(0.0160, 0.0900);
}
module D33(){
    gerb_rectangle(0.0157, 0.0827);
}
module D34(){
    gerb_circle(0.0500);
}
module D35(){
    gerb_circle(0.0100);
}
module D36(){
    gerb_circle(0.0040);
}
module D37(){
    gerb_circle(0.0010);
}
module D38(){
    gerb_circle(0.0120);
}
module D39(){
    gerb_circle(0.0500);
}
module D40(){
    gerb_circle(0.0500);
}
module D41(){
    gerb_circle(0.0250);
}
module D42(){
    gerb_circle(0.0080);
}
module D43(){
    gerb_circle(0.1000);
}
module D44(){
    gerb_circle(0.0600);
}
module D45(){
    gerb_circle(0.0550);
}
module D46(){
    gerb_circle(0.0400);
}
module D47(){
    gerb_circle(0.2500);
}
module D48(){
    gerb_circle(0.1378);
}
module D49(){
    gerb_rectangle(0.1378, 0.1378);
}
module D50(){
    gerb_circle(0.1130);
}
module D51(){
    gerb_circle(0.0550);
}
module D52(){
    gerb_rectangle(0.0550, 0.0550);
}
module D53(){
    gerb_obround(0.0650, 0.2840);
}
module D54(){
    gerb_rectangle(0.0500, 0.0500);
}
module D55(){
    gerb_circle(0.0580);
}
module D56(){
    gerb_circle(0.0500);
}
module D57(){
    gerb_circle(0.0500);
}
module D58(){
    gerb_circle(0.1200);
}
module D59(){
    gerb_rectangle(0.0600, 0.0600);
}
module D60(){
    gerb_rectangle(0.0500, 0.0500);
}
module D61(){
    gerb_rectangle(0.0905, 0.0630);
}
module D62(){
    gerb_rectangle(0.0700, 0.0700);
}
module D63(){
    gerb_rectangle(0.1020, 0.1460);
}
module D64(){
    gerb_rectangle(0.1300, 0.1000);
}
module D65(){
    gerb_circle(0.1575);
}
module D66(){
    gerb_rectangle(0.1575, 0.1575);
}
module D67(){
    gerb_circle(0.1230);
}
module D68(){
    gerb_circle(0.0650);
}
module D69(){
    gerb_rectangle(0.0650, 0.0650);
}
module D70(){
    gerb_obround(0.0650, 0.2840);
}
module D71(){
    gerb_rectangle(0.0433, 0.0315);
}
module D72(){
    gerb_rectangle(0.2200, 0.2300);
}
module D73(){
    gerb_rectangle(0.0560, 0.0720);
}
module D74(){
    gerb_circle(0.0630);
}
module D75(){
    gerb_rectangle(0.0295, 0.0334);
}
module D76(){
    gerb_rectangle(0.0600, 0.0700);
}
module D77(){
    gerb_obround(0.0250, 0.1000);
}
module D78(){
    gerb_rectangle(0.0250, 0.1000);
}
module D79(){
    gerb_obround(0.0160, 0.0900);
}
module D80(){
    gerb_rectangle(0.0160, 0.0900);
}
module D81(){
    gerb_rectangle(0.0177, 0.0866);
}
module D82(){
    gerb_circle(0.0550);
}
module D83(){
    gerb_circle(0.0550);
}
module D84(){
    gerb_circle(0.1200);
}
module D85(){
    gerb_circle(0.1575);
}
module D86(){
    gerb_rectangle(0.1575, 0.1575);
}
module D87(){
    gerb_circle(0.1230);
}
module D88(){
    gerb_circle(0.0650);
}
module D89(){
    gerb_rectangle(0.0650, 0.0650);
}
module D90(){
    gerb_circle(0.0630);
}
module D91(){
    gerb_circle(0.0400);
}
module D92(){
    gerb_rectangle(0.0748, 0.0472);
}
module D93(){
    gerb_rectangle(0.1100, 0.0800);
}
module D94(){
    gerb_rectangle(0.0354, 0.0236);
}
module D95(){
    gerb_rectangle(0.0230, 0.0260);
}
module D96(){
    gerb_rectangle(0.0157, 0.0827);
}

// Start drawing stencil
difference(){

    // First draw the solid part
    scale(v=[25.4,25.4,1]) translate(v=[2.9114,2.105,0]) gerb_rectangle(4.6802015748,2.5974015748);

    // Then subtract each aperture flash from it
    scale(v=[25.4,25.4,1]) translate (v=[1.405, 2.387, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[1.405, 2.257, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.75, 2.19, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.75, 2.06, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.625, 2.19, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.625, 2.06, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.5, 2.19, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.5, 2.06, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.375, 2.19, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.375, 2.06, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.036, 1.226, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[3.166, 1.226, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[4.514, 2.229, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[4.644, 2.229, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.675, 2.4, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.675, 2.27, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.45, 2.4, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.45, 2.27, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.225, 2.4, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.225, 2.27, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.0, 2.4, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.0, 2.27, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.25, 1.815, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.25, 1.685, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[4.6, 1.575, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[4.73, 1.575, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[0.972, 1.737, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[0.972, 1.867, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.725, 1.675, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.725, 1.545, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[1.575, 2.605, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[1.705, 2.605, 0]) D59();
    scale(v=[25.4,25.4,1]) translate (v=[2.945, 1.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.945, 1.216, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.85, 2.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.934, 2.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.675, 2.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.759, 2.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.5, 2.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.584, 2.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.325, 2.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.409, 2.3, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.95, 2.4, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.866, 2.4, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.775, 2.4, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.691, 2.4, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.6, 2.4, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.516, 2.4, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.425, 2.4, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.341, 2.4, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.406, 2.152, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.406, 2.236, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.792, 1.752, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.792, 1.836, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.437, 1.848, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.437, 1.764, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.654, 1.207, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.654, 1.291, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.792, 1.581, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.792, 1.665, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.632, 1.474, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.632, 1.39, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.373, 1.559, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.373, 1.475, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.341, 2.615, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.425, 2.615, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.792, 1.208, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.792, 1.292, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.48, 2.003, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.396, 2.003, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.649, 2.063, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.649, 2.147, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.775, 2.335, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.775, 2.419, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.55, 2.335, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.55, 2.419, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.325, 2.335, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.325, 2.419, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.1, 2.335, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.1, 2.419, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.734, 2.147, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.734, 2.063, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.775, 2.585, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.775, 2.501, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.693, 2.585, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.693, 2.501, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.55, 2.585, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.55, 2.501, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.468, 2.585, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.468, 2.501, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.325, 2.585, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.325, 2.501, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.242, 2.585, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.242, 2.501, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.1, 2.585, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.1, 2.501, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.017, 2.585, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.017, 2.501, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.45, 1.825, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.366, 1.825, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.632, 1.21, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.632, 1.29, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.6, 1.675, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.684, 1.675, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.425, 2.7, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.341, 2.7, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.775, 2.334, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.775, 2.25, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.792, 1.408, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.792, 1.492, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.425, 1.9, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.509, 1.9, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.275, 1.2, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[3.275, 1.284, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.351, 1.8, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[4.351, 1.716, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[0.965, 2.047, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[0.965, 1.963, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.408, 1.764, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.408, 1.848, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.733, 1.978, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.649, 1.978, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.35, 1.65, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[2.35, 1.566, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.564, 2.063, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.564, 2.147, 0]) D60();
    scale(v=[25.4,25.4,1]) translate (v=[1.875, 2.42, 0]) D63();
    scale(v=[25.4,25.4,1]) translate (v=[1.595, 2.42, 0]) D63();
    scale(v=[25.4,25.4,1]) translate (v=[2.541, 1.421, 0]) D72();
    scale(v=[25.4,25.4,1]) translate (v=[2.631, 1.711, 0]) D73();
    scale(v=[25.4,25.4,1]) translate (v=[2.451, 1.711, 0]) D73();
    scale(v=[25.4,25.4,1]) translate (v=[3.894, 2.025, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[3.894, 1.925, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[3.894, 1.825, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[3.894, 1.725, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[4.249, 1.725, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[4.249, 1.825, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[4.249, 1.925, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[4.249, 2.025, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[4.247, 1.25, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[4.247, 1.35, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[4.247, 1.45, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[4.247, 1.55, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[3.892, 1.55, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[3.892, 1.45, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[3.892, 1.35, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[3.892, 1.25, 0]) D76();
    scale(v=[25.4,25.4,1]) translate (v=[3.05, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.1, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.15, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.2, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.25, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.3, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.35, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.4, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.5, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.55, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.6, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.65, 1.425, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.65, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.6, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.55, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.5, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.45, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.35, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.3, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.25, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.2, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.15, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.1, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.05, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.0, 1.787, 0]) D77();
    scale(v=[25.4,25.4,1]) translate (v=[3.0, 1.425, 0]) D78();
    scale(v=[25.4,25.4,1]) translate (v=[3.45, 1.425, 0]) D78();
    scale(v=[25.4,25.4,1]) translate (v=[3.4, 1.787, 0]) D78();
    scale(v=[25.4,25.4,1]) translate (v=[4.5506, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.5762, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.6018, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.6274, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.653, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.6786, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.7042, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.7298, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.781, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.8066, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.8322, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.8578, 1.8, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.8578, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.8322, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.8066, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.781, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.7554, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.7042, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.6786, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.653, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.6274, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.6018, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.5762, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.5506, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.525, 2.07, 0]) D79();
    scale(v=[25.4,25.4,1]) translate (v=[4.525, 1.8, 0]) D80();
    scale(v=[25.4,25.4,1]) translate (v=[4.7554, 1.8, 0]) D80();
    scale(v=[25.4,25.4,1]) translate (v=[4.7298, 2.07, 0]) D80();
    scale(v=[25.4,25.4,1]) translate (v=[1.21, 3.01, 0]) D91();
    scale(v=[25.4,25.4,1]) translate (v=[1.21, 1.4, 0]) D91();
    scale(v=[25.4,25.4,1]) translate (v=[4.83, 1.22, 0]) D91();
    scale(v=[25.4,25.4,1]) translate (v=[4.69, 2.98, 0]) D91();
    scale(v=[25.4,25.4,1]) translate (v=[3.15, 2.275, 0]) D92();
    scale(v=[25.4,25.4,1]) translate (v=[3.15, 2.1018, 0]) D92();
    scale(v=[25.4,25.4,1]) translate (v=[2.95, 2.275, 0]) D92();
    scale(v=[25.4,25.4,1]) translate (v=[2.95, 2.1018, 0]) D92();
    scale(v=[25.4,25.4,1]) translate (v=[3.15, 2.575, 0]) D92();
    scale(v=[25.4,25.4,1]) translate (v=[3.15, 2.4018, 0]) D92();
    scale(v=[25.4,25.4,1]) translate (v=[2.95, 2.575, 0]) D92();
    scale(v=[25.4,25.4,1]) translate (v=[2.95, 2.4018, 0]) D92();
    scale(v=[25.4,25.4,1]) translate (v=[1.42, 2.7, 0]) D93();
    scale(v=[25.4,25.4,1]) translate (v=[1.42, 2.51, 0]) D93();
    scale(v=[25.4,25.4,1]) translate (v=[3.72, 2.61, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.72, 2.5726, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.72, 2.5352, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.8145, 2.5352, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.8145, 2.5726, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.8145, 2.61, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.37, 2.61, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.37, 2.5726, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.37, 2.5352, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.4645, 2.5352, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.4645, 2.5726, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[3.4645, 2.61, 0]) D94();
    scale(v=[25.4,25.4,1]) translate (v=[1.4665, 2.182, 0]) D95();
    scale(v=[25.4,25.4,1]) translate (v=[1.4271, 2.182, 0]) D95();
    scale(v=[25.4,25.4,1]) translate (v=[1.3878, 2.182, 0]) D95();
    scale(v=[25.4,25.4,1]) translate (v=[1.3878, 2.0737, 0]) D95();
    scale(v=[25.4,25.4,1]) translate (v=[1.4665, 2.0737, 0]) D95();
    scale(v=[25.4,25.4,1]) translate (v=[3.375, 1.275, 0]) D96();
    scale(v=[25.4,25.4,1]) translate (v=[3.4222, 1.275, 0]) D96();
    scale(v=[25.4,25.4,1]) translate (v=[3.4695, 1.275, 0]) D96();
}
