// screws_v15a.scad
// definitions for common screws, threads, clearance holes. etc
// Diameters are specified
// First are the SAE (inches)
// Next the Metric
// ProfHuster@gmail.com
// 2015-10-08
//
$fn = 48;
zz = 0.01;
zz2 = 2*zz;
// define conversion since openSCAD defaults to metric
inch2mm = 25.4;

// tap drill sizes
nc2_56tap = 0.070 * inch2mm;
nc4_40tap = 2.261;
nc6_32tap = 2.705;
nc8_32tap = 3.454;
nc10_24tap = 3.797;
q20tap = 0.2010 * inch2mm;

// nominal sizes
q20nom = 0.250 * inch2mm;
// clearance sizes
nc2_56close = 0.0890 * inch2mm;
nc2_56free = 0.0960 * inch2mm;
nc4_40close = 0.1160 * inch2mm;
nc4_40free = 0.1285 * inch2mm;
nc6_32close = 0.1440 * inch2mm;
nc6_32free = 0.1495 * inch2mm;
nc8_32close = 0.1695 * inch2mm;
nc8_32free = 0.1770 * inch2mm;
nc10_32close = 0.1960 * inch2mm;
nc10_32free = 0.2010 * inch2mm;
q20close = 0.2570 * inch2mm;
q20free = 0.2660 * inch2mm;

// nut sizes
nc4_40NutHex = inch2mm * 1/4;
nc6_32NutHex = inch2mm * 5/16;
nc8_32NutHex = inch2mm * 11/32;
nc10_32NutHex = inch2mm * 3/8;
q20NutHex = inch2mm * 7/16;

nc4_40NutTh = inch2mm * 3/32;
nc6_32NutTh = inch2mm * 7/64;
nc8_32NutTh = inch2mm * 1/8;
nc10_32NutTh = inch2mm * 1/8;
q20NutTh = inch2mm * 3/16;

// socket head cap screws
nc4_40HeadDia = 0.179 * inch2mm;
nc4_40HeadHi = 0.110 * inch2mm;
nc4_40Hex = (3/32) * inch2mm;
nc4_40HexDepth = 0.051 * inch2mm;

nc6_32HeadDia = 0.222 * inch2mm;
nc6_32HeadHi = 0.136 * inch2mm;
nc6_32Hex = (7/64) * inch2mm;
nc6_32HexDepth = 0.064 * inch2mm;

nc8_32HeadDia = 0.266 * inch2mm;
nc8_32HeadHi = 0.162 * inch2mm;
nc8_32Hex = (9/64) * inch2mm;
nc8_32HexDepth = 0.077 * inch2mm;

nc10_24HeadDia = 0.308 * inch2mm;
nc10_24HeadHi = 0.188 * inch2mm;
nc10_24Hex = (5/32) * inch2mm;
nc10_24HexDepth = 0.090 * inch2mm;

q20HeadDia = 0.370 * inch2mm;
q20HeadHi = 0.247 * inch2mm;
q20Hex = (3/16) * inch2mm;
q20HexDepth = 0.120 * inch2mm;

module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) 
    rotate([0,0,r]) 
    cube([boxWidth, size, height], true);
}

module q20screw(length = 1.0 * inch2mm){
    difference() {
        cylinder(q20HeadHi,q20HeadDia/2,q20HeadDia/2);
        translate([0,0,q20HeadHi-q20HexDepth/2]) hexagon(q20Hex,q20HexDepth+zz);
    }
    translate([0,0,-length]) cylinder(length,q20close/2,q20close/2);
}

// test
// q20screw();

// M E T R I C 
m2_5tap = 2.05;
m2_5free = 2.9;
m2_5NutHex = 5.0;
m2_5NutTh = 2.0;

m3_tap = 2.5;
m3_free = 3.4;
m3_NutHex = 5.5;
m3_NutTh = 2.4;

// EOF
